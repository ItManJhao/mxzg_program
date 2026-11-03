package com.ayjs.mxzg.gameserver.module.promotionNew.promotion097.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.ListMapUtil;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion097.converter.Promotion097PB;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion097.dao.Promotion097Dao;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion097.domain.Promotion097;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.BasePromotionService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion097LaborDayConfig;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.google.common.collect.ImmutableList;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
public class Promotion097Service extends BasePromotionService<Promotion097> {

    @Autowired
    private Promotion097Dao promotion097Dao;

    @Autowired
    private Promotion097PB promotion097PB;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.LABOR_DAY_LUCK_DRAW;
    }

    @Override
    public IRepository<Promotion097> getRepository() {
        return promotion097Dao;
    }

    @Override
    protected void resetOnNewTurns(Promotion097 promotion, PromotionControl control) {
        int beginRound = 1;
        Map<Integer, Set<Integer>> recordMap = promotion.getRewardRecordMap();
        recordMap.clear();
        recordMap.put(beginRound, new HashSet<>());
        initChoiceRewardMap(promotion, beginRound);
        promotion.setLeftResetTime(getRoundNum() - 1);
        promotion.setCurRound(beginRound);
        promotion.setTimes(1);
    }

    // 初始化玩家奖励列表
    public void initChoiceRewardMap(Promotion097 promotion097, int curRound) {
        Map<Integer, Promotion097LaborDayConfig> curTurnsData = getCurTurnsData(curRound);
        Map<Integer, Integer> choiceRewardMap = promotion097.getChoiceRewardMap();
        choiceRewardMap.clear();    // 先清除掉上一轮的数据
        for (Promotion097LaborDayConfig itemConfig : curTurnsData.values()) {
            ImmutableList<ImmutableThing> rewardThings = itemConfig.getRewardThings();
            choiceRewardMap.put(itemConfig.getPosition(), itemConfig.getRewardThings().get(0).getThingId());
        }
    }

    public boolean isOpening() {
        return promotionControlService.isPromotionRunning(thisPromotionType());
    }


    // 重置
    public void reset(Promotion097 promotionInfo) {
        int leftTimeOld = promotionInfo.getLeftResetTime();
        Asserts.isTrue(leftTimeOld > 0, ErrorCode.PROMOTION_097_RESET_TIME_UN_ENOUGH.getValue(), String.format("重置次数不足{%s}", leftTimeOld));
        int curRoundOld = promotionInfo.getCurRound();

        // 更新数据库基本数据
        int leftResetTimeNew = leftTimeOld - 1;
        int curRoundNew = Math.min(getRoundNum(), curRoundOld + 1);

        initChoiceRewardMap(promotionInfo, curRoundNew);
        Map<Integer, Set<Integer>> rewardRecordMap = promotionInfo.getRewardRecordMap();
        rewardRecordMap.put(curRoundNew, new HashSet<>());
        promotionInfo.setLeftResetTime(leftResetTimeNew);
        promotionInfo.setCurRound(curRoundNew);
        promotionInfo.setTimes(1);
        updatePromotion(promotionInfo);
    }

    // 检查是否可以重置
    public boolean checkCanReset(Promotion097 promotionInfo) {
        Set<Integer> rewardRecordSet = promotionInfo.getRewardRecordMap().get(promotionInfo.getCurRound());
        HashSet<Integer> rewardPosSet = new HashSet<>();
        for (int rewardPos = 1; rewardPos <= 4; rewardPos++) {
            rewardPosSet.add(rewardPos);    // 四个大奖的位置
        }
        return rewardRecordSet.containsAll(rewardPosSet);
    }

    // 检查是否需要重置
    public void checkNeedReset(PlayerContext playerContext, int times, int curRound) {
        Promotion097 promotionInfo = getPromotionInfo(playerContext.getId());
        if (curRound >= getRoundNum()) {
            // 最后一轮之后修正次数
            promotionInfo.setTimes(Math.min(getCurTurnsData(curRound).size(), times));
            updatePromotion(promotionInfo);
            return;
        }
        if (times > getCurTurnsData(curRound).size()) {
            reset(promotionInfo);
            playerContext.write(CmdCode._76308, promotion097PB.buildDataInfo(promotionInfo));
        }
    }

    public List<Promotion097LaborDayConfig> getAllConfigInfo() {
        PromotionControl control = promotionControlService.getControl(PromotionType.LABOR_DAY_LUCK_DRAW);
        Collection<Promotion097LaborDayConfig> allConfig = control.getAllConfig(Promotion097LaborDayConfig.class);
        return allConfig.stream().sorted(Comparator.comparingInt(Promotion097LaborDayConfig::getId)).collect(Collectors.toList());
    }

    public Map<Integer, Promotion097LaborDayConfig> getCurTurnsData(int curRound) {
        Map<Integer, Map<Integer, Promotion097LaborDayConfig>> rewardInfoMap = ListMapUtil.fillTwoLayerMap(getAllConfigInfo(), Promotion097LaborDayConfig::getRound, Promotion097LaborDayConfig::getPosition);
        Map<Integer, Promotion097LaborDayConfig> map = rewardInfoMap.get(curRound);
        Asserts.notNull(map, String.format("不存在当前轮次的数据{%s}", curRound));
        return map;
    }

    public Promotion097LaborDayConfig getDataByTurnsAndPos(int curRound, int pos) {
        Promotion097LaborDayConfig posConfig = getCurTurnsData(curRound).get(pos);
        Asserts.notNull(posConfig, String.format("该位置不存在{%s}", pos));
        return posConfig;
    }

    public int getRoundNum() {
        return getAllConfigInfo().stream().collect(Collectors.groupingBy(Promotion097LaborDayConfig::getRound)).size();
    }

    // 根据权重随机返回当前奖励列表的位置
    public int getTurnsRandomRewardPos(long rid) {
        int allProbability = 0;
        ArrayList<Integer> canDrawList = new ArrayList<>();

        Promotion097 promotion097 = getPromotionInfo(rid);
        int curRound = promotion097.getCurRound();  // 本轮次，区分于turns
        int curTimes = promotion097.getTimes();    // 已经抽奖的次数
        Set<Integer> rewardRecordSet = promotion097.getRewardRecordMap().get(curRound);
        Map<Integer, Promotion097LaborDayConfig> curTurnsData = getCurTurnsData(curRound);
        for (Promotion097LaborDayConfig itemRewardConfig : curTurnsData.values()) {
            if (!rewardRecordSet.contains(itemRewardConfig.getPosition()) && curTimes > itemRewardConfig.getCanAppear()) {
                // 不曾领取过并且当前次数有资格抽到
                allProbability += itemRewardConfig.getWeight();
                canDrawList.add(itemRewardConfig.getPosition());
            }
        }
        if (allProbability == 0) {  // 全部抽过了
            return -1;
        }

        // 根据权重抽一个随机位置上的奖励
        Random random = new Random();
        int randomNum = random.nextInt(allProbability) + 1;
        int sumProb = 0;
        for (Integer pos : canDrawList) {
            Promotion097LaborDayConfig rewardConfig = curTurnsData.get(pos);
            if (sumProb + rewardConfig.getWeight() >= randomNum) {
                return pos;
            } else {
                sumProb += rewardConfig.getWeight();
            }
        }
        return -1;
    }


}
