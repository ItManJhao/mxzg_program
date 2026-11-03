package com.ayjs.mxzg.gameserver.module.dreamland.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.config.excel.cache.DreamlandFirstRewardSysCache;
import com.ayjs.mxzg.config.excel.constant.DreamLandConst;
import com.ayjs.mxzg.config.excel.entity.CDreamLandFirstReward;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.dreamland.constant.DreamlandBattleStatus;
import com.ayjs.mxzg.gameserver.module.dreamland.domin.Dreamland;
import com.ayjs.mxzg.gameserver.module.dreamland.service.DreamlandService;
import com.ayjs.mxzg.gameserver.module.friend.domain.Relationship;
import com.ayjs.mxzg.gameserver.module.friend.service.RelationshipService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.rank.constant.RankType;
import com.ayjs.mxzg.gameserver.module.rank.service.AbstractPlayerRankService;
import com.ayjs.mxzg.gameserver.module.rank.service.RankServiceProxy;
import com.ayjs.mxzg.protocol.DreamlandGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.Comparator;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2019/12/11
 **/
@Controller
@Slf4j
public class DreamlandHandler extends ProtocolHandler {

    @Autowired
    private DreamlandService dreamlandService;
    @Autowired
    private RelationshipService relationshipService;
    @Autowired
    private DreamlandFirstRewardSysCache dreamlandFirstRewardSysCache;
    @Autowired
    private RankServiceProxy rankServiceProxy;
    @Autowired
    private HeroService heroService;

    /***
     * 永恒梦境数据
     * @param playerContext
     * @param req
     */
    @CMD(id = CmdCode._40001)
    public void sendData(PlayerContext playerContext, DreamlandGMsg.GReqDreamlandData req) {
        playerContext.write(CmdCode._40001, dreamlandService.sendData(playerContext.getId()));
    }

    /***
     * 好友助战列表
     * @param playerContext
     * @param req
     */
    @CMD(id = CmdCode._40002)
    public void friendAssistList(PlayerContext playerContext, DreamlandGMsg.GReqFriendAssistHeroList req) {
        playerContext.write(CmdCode._40002, dreamlandService.friendAssistList(playerContext.getId()));
    }

    /***
     * 选择好友助战
     * @param playerContext
     * @param req
     */
    @CMD(id = CmdCode._40006)
    public void dreamlandSelectFriend(PlayerContext playerContext, DreamlandGMsg.GReqDreamlandSelectFriend req) {

        Relationship relationship = relationshipService.getRelationship(playerContext.getId(), req.getRid());
        Asserts.notNull(relationship, ErrorCode.FRIEND_SHIP_MISS.getValue(), "非好友");

        Dreamland friendDreamland = dreamlandService.loadAndRefresh(req.getRid());
        Asserts.isTrue(friendDreamland.getAssistHero().getId() > 0, ErrorCode.DREAMLAND_NOT_ASSIST.getValue(), "好友无助战英雄！");

        Dreamland dreamland = dreamlandService.loadAndRefresh(playerContext.getId());
//        Asserts.isTrue(dreamland.getSelectHero().size() == 0, ErrorCode.DREAMLAND_EXIST_FRIEND_HERO.getValue(), "不可重复选择助战好友英雄");

        List<Hero> heros = heroService.getHeros(playerContext.getId());
        Hero hero = heros.stream().max(Comparator.comparingLong(Hero::getFighting)).orElse(null);

        Asserts.notNull(hero, ErrorCode.FRIEND_HERO_HIGH.getValue(), "战力过高{0}");
        int helpFight = heroService.computeStrength(friendDreamland.getAssistHero());
        int maxFight = hero.getFighting();
        Asserts.notNull(helpFight < maxFight *
                        (DreamLandConst.HELP_BATTLE_LIMIT / 10000.0f)
                , ErrorCode.FRIEND_HERO_HIGH.getValue(), String.format("战力过高{%s}，最高战力{%s}", helpFight, maxFight));

        playerContext.write(CmdCode._40006, dreamlandService.selectFriend(friendDreamland, dreamland));
    }

    /***
     * 永恒梦镜排行榜
     * @param playerContext
     * @param req
     */
    @CMD(id = CmdCode._40003)
    public void dreamlandRank(PlayerContext playerContext, DreamlandGMsg.GReqDreamlandRank req) {
        DreamlandGMsg.GResDreamlandRank.Builder builder = DreamlandGMsg.GResDreamlandRank.newBuilder();
        AbstractPlayerRankService rankService = rankServiceProxy.getPlayerRank(RankType.DREAMLAND);
        builder.setSelfData(rankService.selfRank(playerContext.getId()));
        builder.addAllList(rankService.showRanks(100));
        playerContext.write(CmdCode._40003, builder.build());
    }


    /***
     * 获取关卡通关奖励
     * @param playerContext
     * @param req
     */
    @CMD(id = CmdCode._40004)
    public void dreamlandGetLevel(PlayerContext playerContext, DreamlandGMsg.GReqDreamlandGetLevel req) {

        CDreamLandFirstReward config = dreamlandFirstRewardSysCache.getOrThrow(req.getIdx());
        Dreamland dreamland = dreamlandService.loadAndRefresh(playerContext.getId());

        Asserts.isTrue(dreamland.getMaxLv() >= req.getIdx(), ErrorCode.DREAMLAND_LV_HAD_REWARD.getValue(),
                String.format("关卡数不够：{%s}，请求:{%s}", dreamland.getMaxLv(), config.getIdx()));

        Asserts.isTrue(dreamland.getRewardLv() < config.getIdx(), ErrorCode.DREAMLAND_LV_HAD_REWARD.getValue(),
                String.format("通关奖励已经领取：{%s}，请求:{%s}", dreamland.getRewardLv(), config.getIdx()));

        playerContext.write(CmdCode._40004, dreamlandService.dreamlandGetLevel(playerContext.getId(), config));
    }

    /***
     * 进入下一关
     * @param playerContext
     * @param req
     */
    @CMD(id = CmdCode._40005)
    public void dreamlandBattle(PlayerContext playerContext, DreamlandGMsg.GReqDreamlandBattle req) {
        Dreamland dreamland = dreamlandService.loadAndRefresh(playerContext.getId());
        Asserts.isTrue(dreamland.getBattleStatus() == DreamlandBattleStatus.BATTLE.getValue(), ErrorCode.DREAMLAND_NOT_IN_BATTLE.getValue(),
                String.format("状态不满足：{%s}", dreamland.getBattleStatus()));

        playerContext.write(CmdCode._40005, dreamlandService.battle(playerContext.getId()));
    }

    /***
     * 选择buff并下一关
     * @param playerContext
     * @param req
     */
    @CMD(id = CmdCode._40007)
    public void dreamlandSelectBuff(PlayerContext playerContext, DreamlandGMsg.GReqDreamlandSelectBuff req) {

        Dreamland dreamland = dreamlandService.loadAndRefresh(playerContext.getId());

        Asserts.isTrue(dreamland.getBattleStatus() == DreamlandBattleStatus.SELECT.getValue(), ErrorCode.DREAMLAND_NOT_IN_BATTLE.getValue(),
                String.format("状态不满足：{%s}", dreamland.getBattleStatus()));
        if (!dreamland.getRandomBuffIds().contains(req.getIdx())) {
            log.debug(String.format("不存在该buff，当前buff：{%s}，选择buff：{%s}", JsonUtil.toJson(dreamland.getRandomBuffIds()), req.getIdx()));
            return;
        }
        playerContext.write(CmdCode._40007, dreamlandService.selectBuffAndBattle(playerContext.getId(), req.getIdx()));
    }

    /**
     * 查询队伍数据
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._40008)
    public void getDreamlandHeroLine(PlayerContext playerContext, DreamlandGMsg.GReqDreamlandStartBattle msg) {
        Dreamland dreamland = dreamlandService.loadAndRefresh(playerContext.getId());

        /*Asserts.isTrue(dreamland.getBattleStatus() == DreamlandBattleStatus.NORMAL.getValue(), ErrorCode.DREAMLAND_IN_BATTLE.getValue(),
                String.format("状态不满足：{%s}", dreamland.getBattleStatus()));*/

        //没有战斗便初识化战斗数据，有便直接推送战斗队伍数据
        if (dreamland.getBattleStatus() == DreamlandBattleStatus.NORMAL.getValue()) {
            dreamlandService.addBattleRole(dreamland);
        }

        DreamlandGMsg.GResDreamlandStartBattle.Builder builder = DreamlandGMsg.GResDreamlandStartBattle.newBuilder();
        builder.addAllLineUp(dreamlandService.buildLineUp(dreamland));
        playerContext.write(CmdCode._40008, builder.build());

    }

    /**
     * 派遣助战英雄
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._40009)
    public void dreamlandDispatchHero(PlayerContext playerContext, DreamlandGMsg.GReqDreamlandDispatchHero msg) {

        Asserts.isTrue(msg.getHeroId() > 0, ErrorCode.DREAMLAND_NOT_HERO.getValue(), "派遣的英雄不能为空。");

        playerContext.write(CmdCode._40009, dreamlandService.dispatchHero(playerContext.getId(), msg.getHeroId()));
    }

    /**
     * 推送当前状态
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._40010)
    public void updateStatus(PlayerContext playerContext, DreamlandGMsg.GReqDreamlandBattleStatus msg) {
        playerContext.write(CmdCode._40010, dreamlandService.updateStatus(playerContext.getId()));
    }


    /**
     * 推送玩家最近的一次战报
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._40011)
    public void dreamlandBattleReport(PlayerContext playerContext, DreamlandGMsg.GReqDreamlandBattle msg) {
        playerContext.write(CmdCode._40011, dreamlandService.battleReport(playerContext.getId()));
    }

    /**
     * 战斗结束
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._40012)
    public void dreamlandEndBattle(PlayerContext playerContext, DreamlandGMsg.GReqDreamlandEndBattle msg) {

        Dreamland dreamland = dreamlandService.loadAndRefresh(playerContext.getId());

        Asserts.isTrue(dreamland.getBattleStatus() != DreamlandBattleStatus.NORMAL.getValue(), ErrorCode.DREAMLAND_IN_BATTLE.getValue(),
                String.format("状态不满足：{%s}", dreamland.getBattleStatus()));

        playerContext.write(CmdCode._40012, dreamlandService.endBattle(dreamland));
    }

    /**
     * 增加关卡
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._40013)
    public void dreamlandWinAddLv(PlayerContext playerContext, DreamlandGMsg.GReqDreamlandWinAddLv msg) {
        Dreamland dreamland = dreamlandService.loadAndRefresh(playerContext.getId());
        playerContext.write(CmdCode._40013, dreamlandService.winAddLv(dreamland));
    }

}
