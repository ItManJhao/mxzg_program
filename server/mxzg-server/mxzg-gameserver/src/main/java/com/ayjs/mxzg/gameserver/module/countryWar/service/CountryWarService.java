package com.ayjs.mxzg.gameserver.module.countryWar.service;

import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarConst;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarMissionGiftSysCache;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarMissionSysCache;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarTimeSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarMissionGift;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarTime;
import com.ayjs.mxzg.config.excel.entity.countrywar.CountryWarMissionType;
import com.ayjs.mxzg.config.excel.entity.countrywar.CountryWarStage;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.countryWar.dao.CountryWarDao;
import com.ayjs.mxzg.gameserver.module.countryWar.dao.CountryWarSystemDao;
import com.ayjs.mxzg.gameserver.module.countryWar.domain.CountryWar;
import com.ayjs.mxzg.gameserver.module.countryWar.domain.CountryWarScoreMission;
import com.ayjs.mxzg.gameserver.module.countryWar.domain.CountryWarSystem;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.message.module.countryWar.dto.CountryWarStageTimeInfo;
import com.ayjs.mxzg.protocol.CountryWarGMsg;
import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2021/4/19
 **/
@Service
@Slf4j
public class CountryWarService implements IRechargeBuyingService {

    @Autowired
    private CountryWarDao countryWarDao;
    @Autowired
    private CountryWarMissionSysCache countryWarMissionSysCache;
    @Autowired
    private CountryWarSystemDao countryWarSystemDao;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private CountryWarConst countryWarConst;
    @Autowired
    private ThingService thingService;
    @Autowired
    private CountryWarTimeSysCache countryWarTimeSysCache;
    @Autowired
    private CountryWarMissionGiftSysCache countryWarMissionGiftSysCache;

    @Getter
    @Setter
    private CountryWarStageTimeInfo countryWarStageTimeInfo;

    public CountryWar get(long rid) {
        CountryWar countryWar = countryWarDao.get(rid);
        if (countryWar == null) {
            countryWar = new CountryWar();
            countryWar.setRid(rid);
            countryWarDao.add(countryWar);
        }
        if (countryWarStageTimeInfo == null) {
            //
            log.warn("不存在国战的阶段时间信息，也许跨服没链接！");
            return countryWar;
        }
        if (countryWar.getRound() != countryWarStageTimeInfo.getRound()) {
            //新轮次，重置所有数据；
            countryWar.setRound(countryWarStageTimeInfo.getRound());
            countryWar.getCityRewardCount().clear();
            countryWar.getEventRewardCount().clear();
            countryWar.setAttackItemNum(countryWarConst.getAttackItemInit());
            countryWar.setMoveItemNum(countryWarConst.getMoveItemInit());
            countryWar.setLastAttackAdd(LocalDateTime.now());
            countryWar.setLastMoveAdd(LocalDateTime.now());

            countryWar.setScore(0);
            countryWar.getScoreMission().clear();
            countryWar.getScoreReward().clear();
            countryWar.getScoreMysteryReward().clear();
            countryWar.setBuyMystery(false);
            for (Integer type : countryWarMissionSysCache.getAllType()) {
                CountryWarScoreMission mission = new CountryWarScoreMission();
                mission.setType(type);
                mission.setRefreshDate(LocalDate.of(1970, 1, 1));
                countryWar.getScoreMission().put(type, mission);
            }

            countryWar.setLotteryCount(0);

            countryWar.getFlagMissionCount().clear();
            countryWar.getFlagMissionReward().clear();
            countryWar.setFlagRound(0);
            countryWar.getFlagRoundReward().clear();
            countryWar.getShopBuyCount().clear();

            countryWarDao.update(countryWar);
        }
        if (countryWarStageTimeInfo.getStage() == CountryWarStage.WAR.getValue()) {
            if (countryWar.getLastAttackAdd().isBefore(countryWarStageTimeInfo.getStageStartTime())) {
                countryWar.setLastAttackAdd(countryWarStageTimeInfo.getStageStartTime());
                countryWar.setLastMoveAdd(countryWarStageTimeInfo.getStageStartTime());
            }

            tryAddAttackItem(countryWar);
            tryAddMoveItem(countryWar);

            refreshScoreMission(countryWar);
            //增加积分
            addDayReward(countryWar);

            //刷新商店记录
            if (!countryWar.getShopRefreshTime().isEqual(LocalDate.now())) {
                countryWar.getShopBuyCount().clear();
                countryWar.setShopRefreshTime(LocalDate.now());
            }

        }
        return countryWar;
    }

    /***
     * 刷新积分任务
     * @param countryWar
     */
    private void refreshScoreMission(CountryWar countryWar) {
        countryWar.getScoreMission().forEach((type, mission) -> {
            CountryWarMissionType typeEnum = CountryWarMissionType.typeOf(type);
            if (mission.getRound() == 0 || !LocalDate.now().isBefore(mission.getRefreshDate().plusDays(typeEnum.getDay()))) {
                LocalDate warStartTime = countryWarTimeSysCache.getById(countryWarStageTimeInfo.getIdx()).getStart_time().toLocalDate();
                long interval = Math.abs(LocalDate.now().toEpochDay() - warStartTime.toEpochDay());
                int intervalRound = (int) (interval / typeEnum.getDay());
                mission.setRound(intervalRound % countryWarMissionSysCache.getRoundMax(type) + 1);
                mission.setRefreshDate(warStartTime.plusDays(intervalRound * typeEnum.getDay()));
                mission.getMissionCount().clear();
                mission.getMissionReward().clear();
                countryWarDao.update(countryWar);
            }
        });
    }

    public void addDayReward(CountryWar countryWar) {
        if (countryWar.isBuyMystery() && !countryWar.getMysteryDay().isEqual(LocalDate.now())) {

            if (countryWarStageTimeInfo == null || countryWarStageTimeInfo.getStage() != CountryWarStage.WAR.getValue()) {
                return;
            }
            long score = countryWarMissionGiftSysCache.getById(getOpenType()).getDay_reward().get(0).getItem_num();
            countryWar.setScore((int) (countryWar.getScore() + score));
            countryWar.setMysteryDay(LocalDate.now());
            countryWarDao.update(countryWar);
        }
    }

    private void tryAddAttackItem(CountryWar countryWar) {
        if (countryWar.getAttackItemNum() < countryWarConst.getAttackItemMax()) {
            int attackItemAdd = (LocalDateTimeUtil.toEpochSecond(LocalDateTime.now()) -
                    LocalDateTimeUtil.toEpochSecond(countryWar.getLastAttackAdd())) / countryWarConst.getAttackAddInterval();
            if (attackItemAdd > 0) {
                countryWar.setAttackItemNum(countryWar.getAttackItemNum() + attackItemAdd);
                countryWar.setLastAttackAdd(countryWar.getLastAttackAdd().plusSeconds(attackItemAdd * countryWarConst.getAttackAddInterval()));
            }
        }
    }

    private void tryAddMoveItem(CountryWar countryWar) {
        if (countryWar.getMoveItemNum() < countryWarConst.getMoveItemMax()) {
            int moveItemAdd = (LocalDateTimeUtil.toEpochSecond(LocalDateTime.now()) -
                    LocalDateTimeUtil.toEpochSecond(countryWar.getLastMoveAdd())) / countryWarConst.getMoveAddInterval();
            if (moveItemAdd > 0) {
                countryWar.setMoveItemNum(countryWar.getMoveItemNum() + moveItemAdd);
                countryWar.setLastMoveAdd(countryWar.getLastMoveAdd().plusSeconds(moveItemAdd * countryWarConst.getMoveAddInterval()));
            }
        }
    }


    public CountryWarSystem getCountryWarSystem() {
        CountryWarSystem countryWarSystem = countryWarSystemDao.getSingle();

        if (countryWarStageTimeInfo == null) {
            return countryWarSystem;
        }
        if (countryWarSystem.getRound() != countryWarStageTimeInfo.getRound()) {
            countryWarSystem.getCityRewardCount().clear();
            countryWarSystem.getEventRewardCount().clear();
            countryWarSystem.setRound(countryWarStageTimeInfo.getRound());
            countryWarSystemDao.update(countryWarSystem);
        }
        return countryWarSystem;
    }

    public void update(CountryWarSystem system) {
        countryWarSystemDao.update(system);
    }

    public void update(CountryWar countryWar) {
        countryWarDao.update(countryWar);
    }

//    public int getRound(int type) {
//        int maxRound = countryWarMissionSysCache.getRoundMax(type);
//        if (countryWarStageTimeInfo == null &&
//                countryWarStageTimeInfo.getStage() != CountryWarStage.WAR.getValue()) {
//            //不在交战阶段
//            return maxRound;
//        }
//        CountryWarMissionType missionType = CountryWarMissionType.typeOf(type);
//        int interval = (int) (LocalDate.now().toEpochDay() - countryWarTimeSysCache.getById(countryWarStageTimeInfo.getIdx())
//                .getStart_time().toLocalDate().toEpochDay());
//        return interval / missionType.getDay() % maxRound + 1;
//
//    }

    /**
     * 获取本轮所有有效的对象
     *
     * @return
     */
    public List<CountryWar> list() {
        if (countryWarStageTimeInfo == null) {
            return Collections.emptyList();
        }
        List<CountryWar> countryWars = countryWarDao.listAll();
        countryWars = countryWars.stream().filter(countryWar -> countryWar.getRound() == countryWarStageTimeInfo.getRound())
                .collect(Collectors.toList());
        return countryWars;
    }


    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.COUNTRY_WAR_SCORE;
    }

    @Override
    public boolean canBuy(long rid, int productId) {
        CountryWar countryWar = get(rid);
        return !countryWar.isBuyMystery();
    }

    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {
        CountryWar countryWar = get(rid);
        countryWar.setBuyMystery(true);
        update(countryWar);
        CountryWarGMsg.GResCountryWarScoreBuyGem.Builder builder = CountryWarGMsg.GResCountryWarScoreBuyGem.newBuilder();
        builder.setBuyGem(true);
        contextManager.write(rid, CmdCode._76360, builder.build());

        if (countryWarStageTimeInfo == null) {
            log.error("国战活动时间不存在");
            return;
        }

        CCountryWarTime timeConfig = countryWarTimeSysCache.getOrThrow(countryWarStageTimeInfo.getIdx());
        CCountryWarMissionGift config = countryWarMissionGiftSysCache.getById(timeConfig.getType());
        thingService.add(rid, config.getReward(), GameEvent.COUNTRY_WAR_SCORE_BUY);
    }

    /***
     * 获取当前国战开启类型，未参与或者不在交战状态返回0
     * @return
     *      国战类型
     */
    public int getOpenType() {
        if (countryWarStageTimeInfo == null || !countryWarStageTimeInfo.isJoin()
                || countryWarStageTimeInfo.getStage() != CountryWarStage.WAR.getValue()) {
            return 0;
        }
        return countryWarTimeSysCache.getOrThrow(countryWarStageTimeInfo.getIdx()).getType();
    }

    public static void main(String[] args) {
        System.out.println(-2 % 7);
    }
}
