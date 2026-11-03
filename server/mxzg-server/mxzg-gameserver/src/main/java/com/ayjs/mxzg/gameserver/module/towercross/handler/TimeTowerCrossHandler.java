/**
 *
 */
package com.ayjs.mxzg.gameserver.module.towercross.handler;

import com.ayjs.mxzg.battle.model.BattleCondition;
import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.ConditionType;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.JewelTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.LanguageSysCache;
import com.ayjs.mxzg.config.excel.cache.OpenConditionSysCache;
import com.ayjs.mxzg.config.excel.cache.timetower.TimeTowerBaseSysCache;
import com.ayjs.mxzg.config.excel.cache.timetower.TimeTowerMarkSysCache;
import com.ayjs.mxzg.config.excel.cache.timetower.TimeTowerMissonSysCache;
import com.ayjs.mxzg.config.excel.cache.timetower.TimeTowerMosterSysCache;
import com.ayjs.mxzg.config.excel.cache.timetower.TimeTowerRewardSysCache;
import com.ayjs.mxzg.config.excel.constant.TowerConst;
import com.ayjs.mxzg.config.excel.entity.CLanguage;
import com.ayjs.mxzg.config.excel.entity.COpenCondition;
import com.ayjs.mxzg.config.excel.entity.timetower.CTimeTowerMisson;
import com.ayjs.mxzg.config.excel.entity.timetower.CTimeTowerMoster;
import com.ayjs.mxzg.config.excel.entity.timetower.CTimeTowerReward;
import com.ayjs.mxzg.config.excel.entity.timetower.TowerFailCondition;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroJewel;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroJewelService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.role.constant.EntryType;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.towercross.domain.TowerCrossResult;
import com.ayjs.mxzg.gameserver.module.towercross.domain.TowerCrossRole;
import com.ayjs.mxzg.gameserver.module.towercross.service.TowerCrossResultService;
import com.ayjs.mxzg.gameserver.module.towercross.service.TowerCrossRoleService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.gameserver.module.worldLevel.manager.WorldLevelManager;
import com.ayjs.mxzg.message.module.rank.dto.CrossRankType;
import com.ayjs.mxzg.message.module.timetower.TimeTowerMessage.CSTimeTowerRank;
import com.ayjs.mxzg.message.module.timetower.TimeTowerMessage.CSTimeTowerReward;
import com.ayjs.mxzg.message.module.timetower.TimeTowerMessage.ReqTimeTowerInfoMessage;
import com.ayjs.mxzg.message.module.timetower.TimeTowerMessage.ReqTimeTowerInfoMessage.ReqTimeTowerInfoMessageBuilder;
import com.ayjs.mxzg.message.module.timetower.TimeTowerMessage.ReqTimeTowerPassMessage;
import com.ayjs.mxzg.message.module.timetower.TimeTowerMessage.ReqTimeTowerPassMessage.ReqTimeTowerPassMessageBuilder;
import com.ayjs.mxzg.message.module.timetower.TimeTowerMessage.ReqTimeTowerRankMessage;
import com.ayjs.mxzg.message.module.timetower.TimeTowerMessage.ReqTimeTowerRankMessage.ReqTimeTowerRankMessageBuilder;
import com.ayjs.mxzg.message.module.timetower.TimeTowerMessage.ResTimeTowerInfoMessage;
import com.ayjs.mxzg.message.module.timetower.TimeTowerMessage.ResTimeTowerRankMessage;
import com.ayjs.mxzg.message.module.timetower.TimeTowerMessage.ResTimeTowerRewardMessage;
import com.ayjs.mxzg.protocol.TimeTower.GReqTimeTowerChallenge;
import com.ayjs.mxzg.protocol.TimeTower.GReqTimeTowerInfo;
import com.ayjs.mxzg.protocol.TimeTower.GReqTimeTowerRankInfo;
import com.ayjs.mxzg.protocol.TimeTower.GResTimeTowerChallenge;
import com.ayjs.mxzg.protocol.TimeTower.GResTimeTowerInfo;
import com.ayjs.mxzg.protocol.TimeTower.GResTimeTowerRankInfo;
import com.ayjs.mxzg.protocol.TimeTower.PSTimeTowerRank;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.mxzg.template.language.LanguageHelper;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.google.common.collect.ImmutableList;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * @author YY
 *
 */
@Slf4j
@Controller
public class TimeTowerCrossHandler extends ProtocolHandler implements MessageHandler {

    @Autowired
    private TowerCrossRoleService towerCrossRoleService;
    @Autowired
    private TimeTowerMissonSysCache timeTowerMissonSysCache;
    @Autowired
    private TimeTowerMosterSysCache timeTowerMosterSysCache;
    @Autowired
    private LanguageSysCache languageSysCache;
    @Autowired
    private LanguageHelper languageHelper;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private TimeTowerBaseSysCache timeTowerBaseSysCache;
    @Autowired
    private TimeTowerMarkSysCache timeTowerMarkSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private RoleService roleService;
    @Autowired
    private TowerCrossResultService towerCrossResultService;
    @Autowired
    private MailService mailService;
    @Autowired
    private TimeTowerRewardSysCache timeTowerRewardSysCache;
    @Autowired
    private OpenConditionSysCache openConditionSysCache;
    @Autowired
    private WorldLevelManager worldLevelManager;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private HeroJewelService heroJewelService;
    @Autowired
    private JewelTypeSysCache jewelTypeSysCache;


    private int startTime;
    private int endTime;

    @CMD(id = CmdCode._74001)
    public void scanTowerInfo(PlayerContext playerContext, GReqTimeTowerInfo msg) {
        TowerCrossRole tower = towerCrossRoleService.getTower(playerContext.getId());
        try {
            Role role = roleService.getOrThrow(playerContext.getId());
            //请求、上报跨服数据
            ReqTimeTowerInfoMessageBuilder message = ReqTimeTowerInfoMessage.builder();
            message.rid(tower.getRid());
            message.currLayer(tower.getCurrLayer());
            message.serverId(role.getServerId());
            messageDispatcher.dispatch(message.build());
        } catch (Exception e) {
            //当跨服无法连接时，返回本地数据
            GResTimeTowerInfo.Builder builder = GResTimeTowerInfo.newBuilder();
            builder.setMissionId(tower.getCurrLayer());
            builder.setMaxPass(tower.getHisLayer());
            builder.setHeart(timeTowerBaseSysCache.getHeart() - tower.getFailNum());
            builder.setAccumulatePass(tower.getWeekPass());
            builder.addAllMissionMark(tower.getMark());
            builder.setStartTime(startTime);
            builder.setEndTime(endTime);
            playerContext.write(CmdCode._74001, msg);
        }
    }

    @RemoteMethod
    public void scanTowerInfo(ResTimeTowerInfoMessage message) {
        TowerCrossRole tower = towerCrossRoleService.getTower(message.getRid());
        if (tower.getRound() != message.getRound()) {
            tower.setWeekPass(0);
            tower.setRound(message.getRound());
            towerCrossRoleService.updateTower(tower);
        }
        GResTimeTowerInfo.Builder builder = GResTimeTowerInfo.newBuilder();
        builder.setMissionId(tower.getCurrLayer());
        builder.setMaxPass(tower.getHisLayer());
        builder.setHeart(timeTowerBaseSysCache.getHeart() - tower.getFailNum());
        builder.setAccumulatePass(tower.getWeekPass());
        builder.addAllMissionMark(tower.getMark());
        builder.setStartTime(message.getStartTime());
        builder.setEndTime(message.getEndTime());
        contextManager.write(message.getRid(), CmdCode._74001, builder.build());

        //要是没人来玩这个塔，那么时间也不会更新
        startTime = message.getStartTime();
        endTime = message.getEndTime();
    }

    public List<BattleCondition> formatCondition(ImmutableList<TowerFailCondition> conditions) {
        List<BattleCondition> list = new ArrayList<>();
        for (TowerFailCondition condition : conditions) {
            ConditionType conditionType = null;
            if (condition.getCid() == 1) {
                conditionType = ConditionType.BLOOD_VOLUME_RATIO;
            } else if (condition.getCid() == 2) {
                conditionType = ConditionType.DEATH_HERO;
            }
            if (conditionType == null) {
                continue;
            }
            BattleCondition bc = BattleCondition.valueOf(conditionType, Collections.singletonList(condition.getValue()));
            list.add(bc);
        }
        return list;
    }

    @CMD(id = CmdCode._74002)
    public void challenge(PlayerContext playerContext, GReqTimeTowerChallenge msg) {
        if (startTime > 0 && endTime > 0) {
            int nowTime = TimeDateUtil.getCurrentTimeInt();
            Asserts.isTrue(startTime <= nowTime && nowTime <= endTime, ErrorCode.TIME_TOWER_TIME_LIMIT.getValue(), "当前不在赛季时间内");
        }

        Role role = roleService.getOrThrow(playerContext.getId());

        COpenCondition cOpenCondition = openConditionSysCache.getCondition(EntryType.TIME_TOWER);
        Asserts.isTrue(role.getLevel() >= cOpenCondition.getCondition_value(), ErrorCode.ROLE_LEVEL_LACK.getValue(), "您的冒险等级不足");
        Asserts.isTrue(worldLevelManager.getWorldLevel() >= cOpenCondition.getWorld_level(), ErrorCode.WORLD_LEVEL_LACK.getValue(), "世界等级未满足要求");

        TowerCrossRole tower = towerCrossRoleService.getTower(playerContext.getId());

        CTimeTowerMisson cTimeTowerMisson = timeTowerMissonSysCache.getById(tower.getCurrLayer() + 1);
        Asserts.isTrue(cTimeTowerMisson != null, ErrorCode.TIME_TOWER_MAX_LAYER.getValue(), "你已经通过最高关卡");

        List<CTimeTowerMoster> monsters = timeTowerMosterSysCache.getByMission(tower.getCurrLayer() + 1);
        Asserts.isTrue(monsters != null, ErrorCode.TIME_TOWER_MAX_LAYER.getValue(), "你已经通过最高关卡");

        Asserts.isTrue(tower.getFailNum() < timeTowerBaseSysCache.getHeart(), ErrorCode.TIME_TOWER_MAX_FAIL.getValue(), "你的挑战生命已经用完了");

        HeroLineUp heroLineUp = heroLineUpService.getLineUpByType(playerContext.getId(), LineUpType.TIME_TOWER);

        int totalJewel = 0;
        for (Long heroId : heroLineUp.getFormationMap().keySet()) {
            List<HeroJewel> heroPart = heroJewelService.getHeroParts(role.getId(), heroId);
            for (HeroJewel heroJewel : heroPart) {
                if (heroJewel.getSysId() > 0) {
                    totalJewel += jewelTypeSysCache.getById(heroJewel.getSysId()).getStar();
                }
            }
        }
        Asserts.isTrue(totalJewel >= cTimeTowerMisson.getNeed_gem_lv(), ErrorCode.HERO_JEWEL_STAR.getValue(), String.format("宝石星级不足{%s},关卡{%s}", totalJewel, cTimeTowerMisson.getMission()));

        CLanguage cLanguage = languageSysCache.getByKey(String.valueOf(TowerConst.TIME_TOWER_LANGUAGE_ID));
        String mosterName = String.format(languageHelper.getLanguageBy(cLanguage), tower.getCurrLayer() + 1);
        BattleResult battleResult = battleHelper.invokePVEBattle(BattleType.TIME_TOWER, playerContext.getId(), monsters, mosterName, formatCondition(cTimeTowerMisson.getConditions()));

        int mark = 0;
        boolean isWin = battleResult.isWin();
        List<ImmutableThing> jumpRewards = null;
        if (!isWin) {
            //挑战失败
            tower.setFailNum(tower.getFailNum() + 1);
            towerCrossRoleService.updateTower(tower);
        } else {
            //挑战成功
            tower.setCurrLayer(tower.getCurrLayer() + 1);
            tower.setWeekPass(tower.getWeekPass() + 1);

            if (cTimeTowerMisson.getType() == 1) {
                mark = timeTowerMarkSysCache.getMark(battleResult.getReport().getRoundsCount());
            }

            List<ImmutableThing> rewardList = new ArrayList<>();
            rewardList.addAll(cTimeTowerMisson.getReward());
            if (mark == 1) {
                //自动跳关
                jumpRewards = new ArrayList<>();

                List<CTimeTowerMisson> jumpMissions = timeTowerMissonSysCache.getJumps(tower.getCurrLayer());
                for (CTimeTowerMisson jumpMission : jumpMissions) {
                    if (jumpMission.getMission() > tower.getCurrLayer()) {
                        tower.setCurrLayer(jumpMission.getMission());
                    }
                    jumpRewards.addAll(jumpMission.getReward());
                }
                tower.setWeekPass(tower.getWeekPass() + jumpMissions.size());
                rewardList.addAll(jumpRewards);
            }
            if (tower.getCurrLayer() > tower.getHisLayer()) {
                tower.setHisLayer(tower.getCurrLayer());
            }

            CTimeTowerMisson thisTimeTowerMisson = timeTowerMissonSysCache.getById(tower.getCurrLayer());
            CTimeTowerMisson nextTimeTowerMisson = timeTowerMissonSysCache.getById(tower.getCurrLayer() + 1);
            if (thisTimeTowerMisson != null && nextTimeTowerMisson != null && thisTimeTowerMisson.getLv() != nextTimeTowerMisson.getLv()) {
                tower.getMark().clear();
            } else {
                if (mark > 0) {
                    tower.getMark().add(mark);
                }
            }
            towerCrossRoleService.updateTower(tower);

            rewardList = ImmutableThingUtil.mergeThing(rewardList);
            thingService.add(playerContext.getId(), rewardList, GameEvent.TIME_TOWER_MISSION, NoticeType.SLIENT);
        }

        GResTimeTowerChallenge.Builder builder = GResTimeTowerChallenge.newBuilder();
        builder.setCurMissionId(tower.getCurrLayer());
        builder.setComment(mark);
        builder.setHeart(timeTowerBaseSysCache.getHeart() - tower.getFailNum());
        builder.setReport(battleResult.getReport());
        if (isWin) {
            builder.addAllReward(PbUtil.buildReward(cTimeTowerMisson.getReward()));
            if (jumpRewards != null) {
                jumpRewards = ImmutableThingUtil.mergeThing(jumpRewards);
                builder.addAllJumpReward(PbUtil.buildReward(jumpRewards));
            }
        }
        playerContext.write(CmdCode._74002, builder.build());

        if (isWin) {

            int fighting = heroLineUpService.getLineUpFighting(heroLineUp);

            //上传过关数据
            ReqTimeTowerPassMessageBuilder crossBuilder = ReqTimeTowerPassMessage.builder();
            crossBuilder.rid(tower.getRid());
            crossBuilder.currLayer(tower.getCurrLayer());
            crossBuilder.serverId(role.getServerId());
            crossBuilder.fighting(fighting);
            messageDispatcher.dispatch(crossBuilder.build());
        }
    }

    @CMD(id = CmdCode._74003)
    public void scanRankInfo(PlayerContext playerContext, GReqTimeTowerRankInfo msg) {

        Role role = roleService.getOrThrow(playerContext.getId());

        ReqTimeTowerRankMessageBuilder crossBuilder = ReqTimeTowerRankMessage.builder();
        crossBuilder.rid(playerContext.getId());
        crossBuilder.serverId(role.getServerId());
        messageDispatcher.dispatch(crossBuilder.build());
    }

    @RemoteMethod
    public void scanRankInfo(ResTimeTowerRankMessage message) {
        GResTimeTowerRankInfo.Builder builder = GResTimeTowerRankInfo.newBuilder();
        builder.setMyRank(message.getMyRank());
        if (message.getRanks() != null) {
            for (CSTimeTowerRank csRank : message.getRanks()) {
                builder.addRankList(buildRank(csRank));
            }
        }
        contextManager.write(message.getRid(), CmdCode._74003, builder.build());
    }

    private PSTimeTowerRank buildRank(CSTimeTowerRank csRank) {
        PSTimeTowerRank.Builder builder = PSTimeTowerRank.newBuilder();
        builder.setPlayerId(csRank.getRid());
        builder.setPlayerName(csRank.getName());
        builder.setServerId(csRank.getServerId());
        builder.setPlayerLv(csRank.getLevel());
        builder.setHeadId(csRank.getHeadId());
        builder.setBorderId(csRank.getBorderId());
        builder.setMaxPass(csRank.getCurrLayer());
        builder.setRank(csRank.getRank());
        builder.setImageId(csRank.getImageId());
        builder.setFighting(csRank.getFighting());
        return builder.build();
    }

    @RemoteMethod
    public void tellReward(ResTimeTowerRewardMessage message) {
        TowerCrossResult result = towerCrossResultService.getResult(message.getRound());
        if (result.getResult() != 0) {
            return;
        }
        if (message.getRewardRank() == null) {
            return;
        }
        result.setResult(1);
        towerCrossResultService.update(result);

        //已经发了排名奖励的玩家ID
        Set<Long> rankRids = new HashSet<>();
        List<Mail> mails = new ArrayList<>();
        for (CSTimeTowerReward towerReward : message.getRewardRank()) {
            if (!roleService.isRole(towerReward.getRid())) {
                continue;
            }
            CTimeTowerReward cTimeTowerReward = timeTowerRewardSysCache.getReward(towerReward.getRank());
            if (cTimeTowerReward == null) {
                continue;
            }
            Mail mail = mailService.newSimpleMail(towerReward.getRid(), MailScene.TIME_TOWER,
                    cTimeTowerReward.getReward(), GameEvent.TIME_TOWER_RANK);
            mails.add(mail);
            rankRids.add(towerReward.getRid());
        }

        CTimeTowerReward cJoinReward = timeTowerRewardSysCache.getReward(CrossRankType.TIME_TOWER.getRankCount() + 1);
        if (cJoinReward != null) {
            //发放参与奖
            long countTime = TimeDateUtil.getCurrentTime() - TimeDateUtil.ONEWEEK * 2;
            for (Role role : roleService.getAllRole()) {
                if (role.getLastLoginTime() < countTime) {
                    continue;
                }
                if (rankRids.contains(role.getId())) {
                    continue;
                }
                TowerCrossRole towerCrossRole = towerCrossRoleService.getTower(role.getId());
                if (towerCrossRole.getRound() != message.getRound()) {
                    continue;
                }
                if (towerCrossRole.getWeekPass() <= 0) {
                    continue;
                }
                Mail mail = mailService.newSimpleMail(role.getId(), MailScene.TIME_TOWER,
                        cJoinReward.getReward(), GameEvent.TIME_TOWER_JOIN);
                mails.add(mail);
            }
        }
        if (!mails.isEmpty()) {
            mailService.insertMails(mails);
        }
        log.info("时空魔塔发放排名奖励");
    }
}
