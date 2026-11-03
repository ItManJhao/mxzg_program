package com.ayjs.mxzg.gameserver.module.clan.handler;

import com.ayjs.mxzg.battle.command.BattleCommand;
import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.UnitType;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.InternerPool;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.ClanBossBuySysCache;
import com.ayjs.mxzg.config.excel.cache.ClanBossSysCache;
import com.ayjs.mxzg.config.excel.cache.ItemSysCache;
import com.ayjs.mxzg.config.excel.cache.LanguageSysCache;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.entity.CClanBoss;
import com.ayjs.mxzg.config.excel.entity.CLanguage;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.clan.constant.ClanConstant;
import com.ayjs.mxzg.gameserver.module.clan.constant.ClanLock;
import com.ayjs.mxzg.gameserver.module.clan.domain.Clan;
import com.ayjs.mxzg.gameserver.module.clan.domain.ClanBoss;
import com.ayjs.mxzg.gameserver.module.clan.domain.ClanBossBattleInfo;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanDungeonChallengeEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanDungeonKillEvent;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanBossService;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanService;
import com.ayjs.mxzg.gameserver.module.clan.struct.ClanDungeonDamageData;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion034ZhuShenService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.protocol.ClanDungeonGMsg;
import com.ayjs.mxzg.protocol.ClanDungeonGMsg.GResClanMissionEnd;
import com.ayjs.mxzg.protocol.ClanDungeonGMsg.GResClanMissionInfo;
import com.ayjs.mxzg.protocol.ClanGMsg;
import com.ayjs.mxzg.protocol.ClanGMsg.GReqClanRankDamage;
import com.ayjs.mxzg.protocol.ClanGMsg.GResClanRankDamage;
import com.ayjs.mxzg.protocol.ClanGMsg.PSClanRankDamageData;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.mxzg.template.language.LanguageHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;


@Controller
public class ClanBossHandler extends ProtocolHandler {

    @Autowired
    private ClanBossService clanBossService;
    @Autowired
    private ClanService clanService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private ClanBossSysCache clanBossSysCache;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private CommandBus commandBus;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private ItemSysCache itemSysCache;
    @Autowired
    private ClanBossBuySysCache clanBossBuySysCache;
    @Autowired
    private BattleTemplate battleTemplate;
    @Autowired
    private LanguageSysCache languageSysCache;
    @Autowired
    private LanguageHelper languageHelper;

    /**
     * 请求公会伤害排行
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._7022)
    public void clanDamageRank(PlayerContext playerContext, GReqClanRankDamage msg) {
        GResClanRankDamage.Builder builder = GResClanRankDamage.newBuilder();
        Role role = roleService.getOrThrow(playerContext.getId());
        if (role.getClanId() > 0) {
            Clan clan = clanService.getOrThrow(role.getClanId());
            for (ClanDungeonDamageData model : clan.getClanDungeonDamageList()) {
                PSClanRankDamageData.Builder data = PSClanRankDamageData.newBuilder();
                data.setRid(model.getRid());
                data.setRank(model.getRank());
                Role memberRole = roleService.getOrThrow(model.getRid());
                data.setPhoto(memberRole.getHeadId());
                data.setNick(memberRole.getNick());
                data.setLevel(memberRole.getLevel());
                data.setDamage(model.getBossHp());
                builder.addList(data);
            }
        }
        playerContext.write(CmdCode._7022, builder.build());
    }


    /**
     * 公会副本信息
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._7051)
    public void clanBossInfo(PlayerContext playerContext, ClanDungeonGMsg.GReqClanMissionInfo msg) {
        GResClanMissionInfo.Builder builder = GResClanMissionInfo.newBuilder();
        Role role = roleService.getOrThrow(playerContext.getId());
        if (role.getClanId() != 0) {
            ClanBoss clanBoss = clanBossService.selectClanBoss(role.getClanId());
            builder.setBossIdx(clanBoss.getBossIdx());
            builder.setBossHp(clanBoss.getNowHp());

            ClanBossBattleInfo clanBossBattleInfo = clanBossService.selectClanBossBattleNum(playerContext.getId());
            if (clanBossBattleInfo.getBattleTime() <= DateTimeUtil.dayBreak()) {//重制公会副本次数
                clanBossBattleInfo = clanBossService.remakeClanBossBattleInfo(clanBossBattleInfo);
                clanBossService.updateClanBossBattleInfo(clanBossBattleInfo);
            }

            builder.setAttackCount(clanBossBattleInfo.getUseBattle());
            builder.setLeftCount(clanBossBattleInfo.getNowBattle());
            builder.setBuyCount(systemSysCache.getClanBossTimesBuyLimit() - clanBossBattleInfo.getPurchaseNum());
        }
        playerContext.write(CmdCode._7051, builder.build());
    }

    /**
     * 公会
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._7052)
    public void clanMissionEnd(PlayerContext playerContext, ClanDungeonGMsg.GReqClanMissionEnd msg) {
        Role role = roleService.getOrThrow(playerContext.getId());
        Clan clan = clanService.getOrThrow(role.getClanId());

        ClanBossBattleInfo clanBattleNum = clanBossService.selectClanBossBattleNum(playerContext.getId());

        Asserts.isTrue(clanBattleNum.getNowBattle() > 0, ErrorCode.CLAN_BOSS_BATTLE_NUM.getValue(),
                String.format("挑战次数不足,当前次数{%s}", clanBattleNum.getNowBattle()));

        HeroLineUp heroLineUps = heroLineUpService.getLineUpByType(playerContext.getId(), LineUpType.CLAN_BOSS);

        Asserts.isTrue(!heroLineUps.getFormationMap().isEmpty(), ErrorCode.HERO_LINEUP_EMPTY.getValue(), "Clan DungeonLine now null!!");
        boolean isKill = false;//是否领取过该副本BOSS的击杀奖励
        BattleResult battleResult = null;
        CClanBoss clanBossConfig = null;
        List<ImmutableThing> rewardList = null;
        synchronized (InternerPool.intern(ClanLock.CLAN_DUNGEON_LOCK, role.getClanId())) {
            ClanBoss clanBoss = clanBossService.selectClanBoss(clan.getId());
            clanBossConfig = clanBossSysCache.getOrThrow(clanBoss.getBossIdx());

            clanBattleNum.setNowBattle(clanBattleNum.getNowBattle() - 1);
            clanBattleNum.setUseBattle(clanBattleNum.getUseBattle() + 1);
            clanBattleNum.setBattleTime(DateTimeUtil.currentSecond());
            clanBossService.updateClanBossBattleInfo(clanBattleNum);

            //战斗
            //副本BOSS（守方对象）
            CLanguage cLanguage = languageSysCache.getByKey("" + clanBossConfig.getHero_type());
            String defenderName = "";
            if (Objects.nonNull(cLanguage)) {
                defenderName = languageHelper.getLanguageBy(cLanguage);
            }
            BattlerDo defender = battleTemplate.queryBattler(clanBoss.getBattlerVo(), defenderName, Faction.DEFENDER, UnitType.MOSTER);
            //攻方
            BattlerDo attacker = battleHelper.queryPlayerBattler(LineUpType.CLAN_BOSS, role.getId(), Faction.ATTACKER);
            //战场
            BattleCommand battleCommand = BattleCommand.createOf(BattleType.CLAN_BOSS, attacker, defender);
            commandBus.invoke(battleCommand);
            //战报
            battleResult = battleCommand.getResult();
            //血量
            long maxHp = battleResult.defenderHpInfo().get(clanBossConfig.getPos()).getMaxHp();
            long currHp = battleResult.defenderHpInfo().get(clanBossConfig.getPos()).getCurrentHp();

            //领取当次伤害奖励
            rewardList = clanBossService.updateClanBossDamage(
                    clan, role, battleResult.getTotalDamage(Faction.ATTACKER), clanBossConfig);

            isKill = clanBattleNum.getClanKillList().contains(clanBoss.getBossIdx());

            if (battleResult.isWin()) {//击杀BOSS
                //增加公会历史记录
                clanService.insertClanMsg(clan, ClanConstant.CLAN_KILL_BOSS,
                        clanBossConfig.getHero_type(), null, role);
                //击杀奖励
                clanBossService.getClanBossKillReward(role.getId(), clanBossConfig);
                //发送排行榜奖励
                clanBossService.getClanBossRankReward(clan, clanBoss.getBossIdx());
                //加公会经验
                thingService.add(role.getId(), clanBossConfig.getKiller_exp(), GameEvent.CLAN_BOSS_KILL, NoticeType.SLIENT);
                //更新公会BOSS
                int maxClanBoss = clanBossSysCache.getAll().stream().mapToInt(CClanBoss::getBoss).max().getAsInt();
                int nextBoss = Math.min(maxClanBoss, clanBoss.getBossIdx() + 1);
                clanBossConfig = clanBossSysCache.getOrThrow(nextBoss);
                clanBoss.setBossIdx(clanBossConfig.getBoss());
                clanBoss.setNowHp(ClanConstant.HP_RATE);
                clanBoss.setBattlerVo(getClanDungeonBattlerVo(clanBossConfig));
                clanBossService.updateClanBoss(clanBoss);
            } else {
                //更新公会BOSS
                clanBoss.setBattlerVo(battleResult.buildDefenderVo());
                clanBoss.setNowHp((int) Math.ceil(currHp * 1.0f / maxHp * Promotion034ZhuShenService.HP_RATE));
                clanBossService.updateClanBoss(clanBoss);
            }
        }
        GResClanMissionEnd.Builder builder = GResClanMissionEnd.newBuilder();
        //奖励发送
        builder.addAllList(PbUtil.buildReward(rewardList));
        builder.setIsAwarded(isKill);
        if (battleResult.isWin()) {
            eventBus.post(ClanDungeonKillEvent.of(clan.getId(), role.getId(), clanBossConfig.getBoss()));
        }

        builder.setReport(battleResult.getReport());
        playerContext.write(CmdCode._7052, builder.build());

        eventBus.post(ClanDungeonChallengeEvent.of(role.getId()));

        //广播公会变化
        clanService.broadcastToClan(clan.getId(), CmdCode._7009, ClanGMsg.GResUpdateAllClanInfo.newBuilder().build());
    }

    /**
     * 构建新的公会副本VO对象
     *
     * @return
     */
    private BattlerVo getClanDungeonBattlerVo(CClanBoss clanBoss) {
        List<CClanBoss> clanBossList = new ArrayList<>();
        clanBossList.add(clanBoss);
        return battleHelper.queryNpcBattler(clanBossList, "公会副本BOSS").toBattlerVo();
    }


    /**
     * 购买公会副本挑战次数
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._7053)
    public void clanMissionBuy(PlayerContext playerContext, ClanDungeonGMsg.GReqClanMissionBuy msg) {
        ClanDungeonGMsg.GResClanMissionBuy.Builder builder = ClanDungeonGMsg.GResClanMissionBuy.newBuilder();
        Role role = roleService.getOrThrow(playerContext.getId());
        ClanBossBattleInfo clBattleNum = clanBossService.selectClanBossBattleNum(playerContext.getId());
        if (clBattleNum.getPurchaseNum() >= systemSysCache.getClanBossTimesBuyLimit()) {
            playerContext.writeError(ErrorCode.CLAN_BATTLE_NUM_BUY);
            return;
        }
        clBattleNum.setPurchaseNum(clBattleNum.getPurchaseNum() + 1);
        clBattleNum.setNowBattle(clBattleNum.getNowBattle() + 1);
        //扣费
        thingService.cost(role.getId(), clanBossBuySysCache.getOrThrow(clBattleNum.getPurchaseNum()).getCost(), GameEvent.CLAN_BOSS_BATTLE);
        //更新数据
        clanBossService.updateClanBossBattleInfo(clBattleNum);
        playerContext.write(CmdCode._7053, builder.build());
    }

}
