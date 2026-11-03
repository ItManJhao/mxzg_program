package com.ayjs.mxzg.gameserver.module.stagematch.rim.service;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.battle.model.mirror.HeroVo;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.config.excel.cache.stageMatch.rim.SuperStageTokenRewardCache;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.excel.entity.stageMatch.rim.CSuperStageTokenReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.dao.StageMatchDao;
import com.ayjs.mxzg.gameserver.module.stagematch.rim.dao.StageSeasonDetailDao;
import com.ayjs.mxzg.gameserver.module.stagematch.rim.domain.HeroMvpInfo;
import com.ayjs.mxzg.gameserver.module.stagematch.rim.domain.StageSeasonDetail;
import com.ayjs.mxzg.gameserver.module.stagematch.rim.event.StageMatchSeasonBattleEvent;
import com.ayjs.mxzg.gameserver.module.stagematch.rim.event.StageTokenSettleEvent;
import lombok.extern.slf4j.Slf4j;
import org.jetbrains.annotations.NotNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/6/16
 **/
@Service
@Observer
@Slf4j
public class StageMatchRimService implements IRechargeBuyingService {
    @Autowired
    private RoleService roleService;
    @Autowired
    private StageSeasonDetailDao stageSeasonDetailDao;
    @Autowired
    private SuperStageTokenRewardCache stageMatchTokenRewardCache;
    @Autowired
    private MailService mailService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private StageMatchDao stageMatchDao;

    public static int TOTAL_SEASON_ID = -1;

    public List<StageSeasonDetail> listAllSeason(long rid) {
        return stageSeasonDetailDao.list("rid", rid);
    }

    public void update(StageSeasonDetail entity) {
        stageSeasonDetailDao.update(entity);
    }

    public int getSeasonId() {
        return stageMatchDao.get().getSeason();
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void battle(StageMatchSeasonBattleEvent event) {

        //记录到当前赛季
        recordInSeason(event, getSeasonId());

        //记录到总赛季
        recordInSeason(event, TOTAL_SEASON_ID);

    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void battle(StageTokenSettleEvent event) {
        settle(event.getSeason());
    }

    private void recordInSeason(StageMatchSeasonBattleEvent event, int seasonId) {
        StageSeasonDetail seasonDetail = getSeasonDetail(event.getRid(), seasonId);

        if (event.getCurrScore() > seasonDetail.getMaxScore()) {
            seasonDetail.setMaxScore(event.getCurrScore());
        }

        if (event.getStageId() > seasonDetail.getStageId()) {
            seasonDetail.setStageId(event.getStageId());
        }

        if (event.getDmg() > seasonDetail.getMaxDmg()) {
            seasonDetail.setMaxDmg(event.getDmg());
        }

        if (event.getWin()) {
            seasonDetail.setCurrWinningStreak(seasonDetail.getCurrWinningStreak() + 1);
            if (seasonDetail.getCurrWinningStreak() > seasonDetail.getMaxWinningStreak()) {
                seasonDetail.setMaxWinningStreak(seasonDetail.getCurrWinningStreak());
            }
            if (event.isNormal()) {
                seasonDetail.setNormalWinCount(seasonDetail.getNormalWinCount() + 1);
            } else {
                seasonDetail.setEliteWinCount(seasonDetail.getEliteWinCount() + 1);
            }
        } else {
            seasonDetail.setCurrWinningStreak(0);
        }
        if (event.isNormal()) {
            seasonDetail.setNormalTotalCount(seasonDetail.getNormalTotalCount() + 1);
        } else {
            seasonDetail.setEliteTotalCount(seasonDetail.getEliteTotalCount() + 1);
        }

        if (!CollectionUtil.isEmpty(event.getMvpHeroVos())) {

            Map<Integer, Integer> heroMvpCount = seasonDetail.getHeroMvpCount();
            int mvpCount = 0;
            if (seasonDetail.getMvpHero().getHeroType() > 0) {
                mvpCount = seasonDetail.getHeroMvpCount().getOrDefault(seasonDetail.getMvpHero().getHeroType(), 0);
            }

            for (HeroVo heroVo : event.getMvpHeroVos()) {
                int heroType = heroVo.getHero_type();
                Integer currHeroCount = heroMvpCount.getOrDefault(heroType, 0);
                currHeroCount += 1;
                if (mvpCount < currHeroCount) {
                    // TODO 替换规则
                    seasonDetail.setMvpHero(HeroMvpInfo.of(heroVo));
                    mvpCount = currHeroCount;
                }
                heroMvpCount.put(heroType, currHeroCount);
            }

        }

        if (event.getDefendTeamFighting1() + event.getDefendTeamFighting2() >
                seasonDetail.getStrongestOpponentFighting() + seasonDetail.getStrongestOpponentFighting2()) {
            seasonDetail.setStrongestOpponentFighting(event.getDefendTeamFighting1());
            seasonDetail.setStrongestOpponentFighting(event.getDefendTeamFighting1());
            seasonDetail.setStrongestOpponentRid(event.getDefendId());
        }

        update(seasonDetail);
    }

    /***
     * 结算
     */
    public void settle(int seasonId) {
        //过滤等级以下的玩家
        List<Role> roles = roleService.getAllRole().stream().filter(role -> role.getLevel() > 50).collect(Collectors.toList());
        List<Mail> mails = new ArrayList<>();
        roles.forEach(role -> {
            StageSeasonDetail seasonDetail = getSeasonDetail(role.getId(), seasonId);
            int winCount = seasonDetail.getNormalWinCount() + seasonDetail.getEliteWinCount();
            if (winCount > 0) {
                List<CSuperStageTokenReward> reissueList = stageMatchTokenRewardCache.getAll().stream().filter(config ->
                        config.getWin_count() <= winCount && (!seasonDetail.getStageRecords().contains(config.getIdx())
                                || (seasonDetail.isBuyStageToken() && !seasonDetail.getStageTokenRecords().contains(config.getIdx()))))
                        .collect(Collectors.toList());
                if (reissueList.size() > 0) {
                    List<ImmutableThing> rewards = new ArrayList<>();
                    for (CSuperStageTokenReward config : reissueList) {
                        if (!seasonDetail.getStageRecords().contains(config.getIdx())) {
                            rewards.addAll(config.getReward());
                            seasonDetail.getStageRecords().add(config.getIdx());
                        }
                        if (seasonDetail.isBuyStageToken() && !seasonDetail.getStageTokenRecords().contains(config.getIdx())) {
                            rewards.addAll(config.getToken_reward());
                            seasonDetail.getStageTokenRecords().add(config.getIdx());
                        }
                    }
                    update(seasonDetail);
                    ImmutableThingUtil.mergeThing(rewards);
                    mails.add(mailService.newSimpleMail(role.getId(), MailScene.STAGE_TOKEN_REWARD, rewards, GameEvent.STAGE_TOKEN_REWARD));
                }
            }
        });
        if (mails.size() > 0) {
            mailService.insertMails(mails);
        }
    }

    @NotNull
    public StageSeasonDetail getSeasonDetail(long rid, int sessionId) {
        StageSeasonDetail seasonDetail = listAllSeason(rid).stream().filter(detail -> detail.getSeasonId() == sessionId)
                .findFirst().orElse(null);
        if (seasonDetail == null) {
            seasonDetail = new StageSeasonDetail();
            seasonDetail.setSeasonId(sessionId);
            seasonDetail.setRid(rid);
            stageSeasonDetailDao.add(seasonDetail);
        }
        return seasonDetail;
    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.STAGE_MATCH;
    }

    @Override
    public boolean canBuy(long rid, int productId) {
        StageSeasonDetail stageSeasonDetail = getSeasonDetail(rid, getSeasonId());
        return !stageSeasonDetail.isBuyStageToken();
    }

    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {
        StageSeasonDetail stageSeasonDetail = getSeasonDetail(rid, getSeasonId());
        log.info("{}设置段位赛战令！", rid);
        stageSeasonDetail.setBuyStageToken(true);
        update(stageSeasonDetail);

        thingService.add(rid, cBuyGem.getItem(), GameEvent.STAGE_TOKEN_BUY_REWARD);
    }
}
