/**
 *
 */
package com.ayjs.mxzg.gameserver.module.tower.handler;

import com.alibaba.fastjson.JSON;
import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.StringUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.FirstRewardTowerSysCache;
import com.ayjs.mxzg.config.excel.cache.LanguageSysCache;
import com.ayjs.mxzg.config.excel.cache.TowerSweepSysCache;
import com.ayjs.mxzg.config.excel.cache.TowerSysCache;
import com.ayjs.mxzg.config.excel.cache.TowerrewardSysCache;
import com.ayjs.mxzg.config.excel.constant.TowerConst;
import com.ayjs.mxzg.config.excel.entity.CFirstRewardTower;
import com.ayjs.mxzg.config.excel.entity.CLanguage;
import com.ayjs.mxzg.config.excel.entity.CTower;
import com.ayjs.mxzg.config.excel.entity.CTowerSweep;
import com.ayjs.mxzg.config.excel.entity.CTowerreward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ItemType;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.role.constant.EntryType;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.tower.converter.TowerConverter;
import com.ayjs.mxzg.gameserver.module.tower.dao.TowerRaidersLogDao;
import com.ayjs.mxzg.gameserver.module.tower.domain.Tower;
import com.ayjs.mxzg.gameserver.module.tower.domain.TowerRaiders;
import com.ayjs.mxzg.gameserver.module.tower.domain.TowerRaidersLog;
import com.ayjs.mxzg.gameserver.module.tower.event.TowerChallengeEvent;
import com.ayjs.mxzg.gameserver.module.tower.event.TowerPassEvent;
import com.ayjs.mxzg.gameserver.module.tower.event.TowerRewardEvent;
import com.ayjs.mxzg.gameserver.module.tower.event.TowerSweepEvent;
import com.ayjs.mxzg.gameserver.module.tower.service.TowerService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.module.battle.command.SaveBattleReportCommand;
import com.ayjs.mxzg.protocol.TowerGMsg.GReqEditBattle;
import com.ayjs.mxzg.protocol.TowerGMsg.GReqTowerBattle;
import com.ayjs.mxzg.protocol.TowerGMsg.GReqTowerData;
import com.ayjs.mxzg.protocol.TowerGMsg.GReqTowerEnergyBuy;
import com.ayjs.mxzg.protocol.TowerGMsg.GReqTowerFirstReward;
import com.ayjs.mxzg.protocol.TowerGMsg.GReqTowerLog;
import com.ayjs.mxzg.protocol.TowerGMsg.GReqTowerRewardList;
import com.ayjs.mxzg.protocol.TowerGMsg.GReqTowerSweep;
import com.ayjs.mxzg.protocol.TowerGMsg.GResEditBattle;
import com.ayjs.mxzg.protocol.TowerGMsg.GResTowerBattle;
import com.ayjs.mxzg.protocol.TowerGMsg.GResTowerData;
import com.ayjs.mxzg.protocol.TowerGMsg.GResTowerEnergyBuy;
import com.ayjs.mxzg.protocol.TowerGMsg.GResTowerFirstReward;
import com.ayjs.mxzg.protocol.TowerGMsg.GResTowerLog;
import com.ayjs.mxzg.protocol.TowerGMsg.GResTowerRewardList;
import com.ayjs.mxzg.protocol.TowerGMsg.GResTowerSweep;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.mxzg.template.language.LanguageHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.stream.Collectors;

/**
 * @author YY
 *
 */
@Controller
public class TowerHandler extends ProtocolHandler {
    @Autowired
    private TowerService towerService;
    @Autowired
    private TowerrewardSysCache towerrewardSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private TowerSweepSysCache towerSweepSysCache;
    @Autowired
    private FirstRewardTowerSysCache firstRewardTowerSysCache;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private TowerSysCache towerSysCache;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private RoleService roleService;
    @Autowired
    private TowerRaidersLogDao towerRaidersLogDao;
    @Autowired
    private TowerConverter towerConverter;
    @Autowired
    private CommandBus commandBus;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private LanguageSysCache languageSysCache;
    @Autowired
    private LanguageHelper languageHelper;

    @CMD(id = CmdCode._3200)
    public void getTowerData(PlayerContext playerContext, GReqTowerData msg) {
        Tower tower = towerService.getTower(playerContext.getId());

        int nowTime = TimeDateUtil.getCurrentTimeInt();
        if (tower.getEnergy() < TowerConst.TICKETS_LIMIT) {
            //自动恢复的门票数
            int addEnergyNum = (nowTime - tower.getEnergyTime())
                    / TowerConst.TICKETS_REGENERATE_TIME;
            if (addEnergyNum > 0) {
                int energy = tower.getEnergy() + addEnergyNum;
                if (energy > TowerConst.TICKETS_LIMIT) {
                    //门票不能超上限
                    addEnergyNum = TowerConst.TICKETS_LIMIT - tower.getEnergy();//实标恢复数量
                    energy = TowerConst.TICKETS_LIMIT;
                    tower.setEnergyTime(nowTime);
                } else {
                    tower.setEnergyTime(tower.getEnergyTime() + TowerConst.TICKETS_REGENERATE_TIME * addEnergyNum);
                }
                tower.setEnergy(energy);
                towerService.updateTower(tower);
            }
        }
        GResTowerData.Builder builder = GResTowerData.newBuilder();
        builder.setStage(tower.getStage());
        builder.setEnergy(tower.getEnergy());
        builder.setEnergyTime(tower.getEnergyTime());
        builder.setSweepTimes(tower.getSweepTimes());
        playerContext.write(CmdCode._3200, builder.build());
    }

    @CMD(id = CmdCode._3201)
    public void towerLog(PlayerContext playerContext, GReqTowerLog msg) {
        Tower tower = towerService.getTower(playerContext.getId());
        TowerRaidersLog towerRaidersLog = towerRaidersLogDao.get(msg.getStage());

        GResTowerLog.Builder builder = GResTowerLog.newBuilder();
        if (msg.getStage() == tower.getStage() - 1 && tower.getLastRaiders() != null && StringUtil.isNotBlank(tower.getLastRaiders().getBattleId())) {
            builder.setSelf(towerConverter.convertFrom(tower.getLastRaiders()));
        }
        if (towerRaidersLog != null) {
            builder.setLowest(towerConverter.convertFrom(towerRaidersLog.getLowest()));
            builder.setFastest(towerConverter.convertFrom(towerRaidersLog.getFastest()));
        }

        builder.setStage(msg.getStage());
        playerContext.write(CmdCode._3201, builder.build());
    }

    @CMD(id = CmdCode._3202)
    public void towerEnergyBuy(PlayerContext playerContext, GReqTowerEnergyBuy msg) {
        Asserts.isTrue(msg.getNum() > 0,
                ErrorCode.ERROR_PARAM.getValue(),
                () -> "buy num less than 0 :" + msg.getNum());

        ImmutableThing cost = ImmutableThing.of(ItemType.IT_GEM, msg.getNum() * TowerConst.TICKETS_GEM_COST);
        thingService.cost(playerContext.getId(), cost, GameEvent.SHOP_RESOURCE);

        Tower tower = towerService.getTower(playerContext.getId());
        tower.setEnergy(tower.getEnergy() + msg.getNum());
        towerService.updateTower(tower);

        GResTowerEnergyBuy.Builder builder = GResTowerEnergyBuy.newBuilder();
        builder.setEnergy(tower.getEnergy());
        playerContext.write(CmdCode._3202, builder.build());
    }

    /**
     * 已领取的幻境首通奖励
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._3203)
    public void towerRewardList(PlayerContext playerContext, GReqTowerRewardList msg) {
        Tower tower = towerService.getTower(playerContext.getId());

        GResTowerRewardList.Builder builder = GResTowerRewardList.newBuilder();
        builder.addAllList(tower.getStageRewardId());
        playerContext.write(CmdCode._3203, builder.build());
    }


    @CMD(id = CmdCode._3204)
    public void towerFirstReward(PlayerContext playerContext, GReqTowerFirstReward msg) {
        Tower tower = towerService.getTower(playerContext.getId());

        //已经领取该奖励
        Asserts.isTrue(!tower.getStageRewardId().contains(msg.getIdx()), ErrorCode.TOWER_STAGE_REWARD_RECEIVED.getValue(),
                () -> "Award received tower id :" + msg.getIdx());

        CFirstRewardTower cFirstRewardTower = firstRewardTowerSysCache.getChapterOrThrow(msg.getIdx());

        Asserts.isTrue(tower.getStage() - 1 >= cFirstRewardTower.getChapter(),
                ErrorCode.TOWER_REWARD_CONDITION_NOT_SATISFIED.getValue(),
                () -> String.format("tower.getStage():%s cFirstRewardTower.getChapter():%s",
                        tower.getStage(), cFirstRewardTower.getChapter()));

        tower.getStageRewardId().add(msg.getIdx());
        towerService.updateTower(tower);

        thingService.add(playerContext.getId(), cFirstRewardTower.getReward(), GameEvent.TOWER_FIRST_REWARD);

        GResTowerFirstReward.Builder builder = GResTowerFirstReward.newBuilder();
        builder.setIdx(msg.getIdx());
        playerContext.write(CmdCode._3204, builder.build());
        eventBus.post(TowerRewardEvent.of(playerContext.getId(), msg.getIdx()));
    }

    @CMD(id = CmdCode._3205, entry = EntryType.MAIN_FANTASY_TOWER)
    public void towerBattle(PlayerContext playerContext, GReqTowerBattle msg) {
        Role role = roleService.getOrThrow(playerContext.getId());
        Tower tower = towerService.getTower(playerContext.getId());
        //前端说验证参数可以控制在网络不好的情况下，玩家连点导致挑战了好多层的问题
        Asserts.isTrue(tower.getStage() == msg.getStage(), ErrorCode.ERROR_PARAM.getValue(),
                () -> String.format("tower.getStage():%s msg.getStage():%s",
                        tower.getStage(), msg.getStage()));

        Asserts.isTrue(tower.getEnergy() > 0, ErrorCode.TOWER_ENERGY_NOT_ENOUGH.getValue(),
                () -> "tower.getEnergy():" + tower.getEnergy());

        List<CTower> towerList = towerSysCache.getByMission(tower.getStage());
        Asserts.isTrue(towerList != null, ErrorCode.TOWER_MAX_LAYER.getValue(), "" + tower.getStage());

        CLanguage cLanguage = languageSysCache.getByKey(String.valueOf(TowerConst.LANGUAGE_STAGE_ID));
        String mosterName = String.format(languageHelper.getLanguageBy(cLanguage), tower.getStage());
        BattleResult battleResult = battleHelper.invokePVEBattle(BattleType.TOWER, playerContext.getId(), towerList, mosterName);

        Rewards rewards = null;
        boolean isWin = battleResult.isWin();
        if (!isWin) {
            if (tower.getEnergy() >= TowerConst.TICKETS_LIMIT) {
                tower.setEnergyTime(TimeDateUtil.getCurrentTimeInt());
            }

            tower.setEnergy(tower.getEnergy() - 1);
            towerService.updateTower(tower);
        } else {
            CTowerreward cTowerreward = towerrewardSysCache.getOrThrow(tower.getStage());

            tower.setStage(tower.getStage() + 1);
            tower.setTime(TimeDateUtil.getCurrentTimeInt());

            HeroLineUp heroLineUp = heroLineUpService.getLineUpByType(playerContext.getId(), LineUpType.TOWER);
            int fighting = heroLineUpService.getLineUpFighting(heroLineUp);
            TowerRaiders raiders = TowerRaiders.createOf(battleResult.getContext().buildBattleLog(), fighting, role.getHeadId(), role.getBorderId());
            tower.setLastRaiders(raiders);
            towerService.updateTower(tower);

            rewards = thingService.add(playerContext.getId(), cTowerreward.getFirst_reward_tower(),
                    GameEvent.TOWER_AWARD, NoticeType.SLIENT);

            //tower中记录的是下一层还没有挑战通关的数据，所以需要减1
            eventBus.post(TowerPassEvent.of(playerContext.getId(), tower.getStage() - 1, raiders));
            commandBus.invoke(SaveBattleReportCommand.of(battleResult.getReport()));
        }

        GResTowerBattle.Builder builder = GResTowerBattle.newBuilder();
        builder.setStage(tower.getStage());
        builder.setEnergy(tower.getEnergy());
        builder.setEnergyTime(tower.getEnergyTime());
        if (rewards != null) {
            builder.addAllItems(PbUtil.buildReward(rewards));
        }
        builder.setReport(battleResult.getReport());
        playerContext.write(CmdCode._3205, builder.build());

        eventBus.post(TowerChallengeEvent.of(playerContext.getId(), tower.getStage(), isWin, role.getFighting(), role.getLevel()));
    }

    @CMD(id = CmdCode._3206)
    public void towerSweep(PlayerContext playerContext, GReqTowerSweep msg) {
        Tower tower = towerService.getTower(playerContext.getId());

        Asserts.isTrue(tower.getSweepTimes() < towerSweepSysCache.getMaxCount(), ErrorCode.TOWER_MAX_SWEEP.getValue(),
                () -> "sweepTime:" + tower.getSweepTimes());

        CTowerSweep cTowerSweep = towerSweepSysCache.getOrThrow(tower.getSweepTimes() + 1);
        //扫荡的层数
        CTowerreward cTowerreward = towerrewardSysCache.getOrThrow(tower.getStage() - 1);

        if (cTowerSweep.getCost_gem() > 0) {
            // 当前扫荡是否要扣费
            ImmutableThing cost = ImmutableThing.of(ItemType.IT_GEM, cTowerSweep.getCost_gem());
            thingService.cost(playerContext.getId(), cost, GameEvent.TOWER_SWEEP);
        }
        tower.setSweepTimes(tower.getSweepTimes() + 1);
        towerService.updateTower(tower);

        thingService.add(playerContext.getId(), cTowerreward.getReward(), GameEvent.TOWER_SWEEP);


        GResTowerSweep.Builder builder = GResTowerSweep.newBuilder();
        builder.setSweepTimes(tower.getSweepTimes());
        playerContext.write(CmdCode._3206, builder.build());

        eventBus.post(TowerSweepEvent.of(playerContext.getId(), 1));
    }

    @CMD(id = CmdCode._3220)
    public void editBattle(PlayerContext playerContext, GReqEditBattle editBattle) {
        List<String> batleInfo = JSON.parseArray(editBattle.getBattleInfo(), String.class);
        List<CTower> towers = batleInfo.stream().map(CTower::createOf).collect(Collectors.toList());
        BattlerDo defender = battleHelper.queryNpcBattler(towers, "幻境之塔测试");
        BattlerDo attacker = battleHelper.queryPlayerBattler(BattleType.MAIN, playerContext.getId(), Faction.ATTACKER);
        BattleResult result = battleHelper.invokeBattle(BattleType.TOWER, attacker, defender);

        GResEditBattle.Builder builder = GResEditBattle.newBuilder().setReport(result.getReport());
        playerContext.write(CmdCode._3220, builder.build());
    }
}
