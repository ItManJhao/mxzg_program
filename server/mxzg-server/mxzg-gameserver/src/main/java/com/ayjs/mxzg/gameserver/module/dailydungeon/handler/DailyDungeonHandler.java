package com.ayjs.mxzg.gameserver.module.dailydungeon.handler;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.battle.command.BattleCommand;
import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.DailyMissionCostSysCache;
import com.ayjs.mxzg.config.excel.cache.DailyMissionRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.DailyMissionSysCache;
import com.ayjs.mxzg.config.excel.cache.LanguageSysCache;
import com.ayjs.mxzg.config.excel.entity.CDailyMission;
import com.ayjs.mxzg.config.excel.entity.CDailyMissionCost;
import com.ayjs.mxzg.config.excel.entity.CDailyMissionReward;
import com.ayjs.mxzg.config.excel.entity.CLanguage;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.clergy.service.ClergyService;
import com.ayjs.mxzg.gameserver.module.dailydungeon.constant.DailyDungeonModel;
import com.ayjs.mxzg.gameserver.module.dailydungeon.constant.DailyDungeonType;
import com.ayjs.mxzg.gameserver.module.dailydungeon.domain.DailyDungeon;
import com.ayjs.mxzg.gameserver.module.dailydungeon.event.JoinDailyDungeonEvent;
import com.ayjs.mxzg.gameserver.module.dailydungeon.service.DailyDungeonService;
import com.ayjs.mxzg.gameserver.module.role.constant.EntryType;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.role.service.RoleVipService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.DailyDungeonGMsg;
import com.ayjs.mxzg.protocol.DailyDungeonGMsg.GReqDailyDungeonData;
import com.ayjs.mxzg.protocol.DailyDungeonGMsg.GReqDailyDungeonEnd;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.mxzg.template.language.LanguageHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.Map;
import java.util.Objects;

@Controller
public class DailyDungeonHandler extends ProtocolHandler {

    @Autowired
    private DailyDungeonService dailyDungeonService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private DailyMissionRewardSysCache dailyMissionRewardSysCache;
    @Autowired
    private DailyMissionCostSysCache dailyMissionCostSysCache;
    @Autowired
    private DailyMissionSysCache dailyMissionSysCache;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private CommandBus commandBus;
    @Autowired
    private LanguageSysCache languageSysCache;
    @Autowired
    private LanguageHelper languageHelper;
    @Autowired
    private RoleVipService roleVipService;
    @Autowired
    private ClergyService clergyService;

    /**
     * 日常副本数据
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._19001)
    public void dailyDungeonData(PlayerContext playerContext, GReqDailyDungeonData msg) {
        DailyDungeonGMsg.GResDailyDungeonList.Builder builder = DailyDungeonGMsg.GResDailyDungeonList.newBuilder();
        DailyDungeon dailyDungeon = dailyDungeonService.select(playerContext.getId());
        dailyDungeon.getDungeonMap().forEach((k, v) -> builder.addList(dailyDungeonService.toGReqDailyDungeonData(k, v)));
        playerContext.write(CmdCode._19001, builder.build());
    }

    @CMD(id = CmdCode._19002, entry = EntryType.MAIN_MISSION)
    public void dailyDungeonBattle(PlayerContext playerContext, GReqDailyDungeonEnd msg) {

        CDailyMissionReward dailyMissionReward = dailyMissionRewardSysCache.getDailyMissionReward(msg.getMissionType(),
                msg.getMissionId());
        Asserts.notNull(dailyMissionReward, ErrorCode.CONFIG_NOT_EXISTS.getValue(),
                () -> "CDailyMissionReward is null type:" + msg.getMissionType() + " mission Id:" + msg.getMissionId());

        Role role = roleService.getOrThrow(playerContext.getId());
        Asserts.isTrue(role.getLevel() >= dailyMissionReward.getOpen_level(),ErrorCode.DAILY_MISSION_NOT_TOP_LEVEL.getValue(),"" +
                "未达到该副本开放等级");

        DailyDungeon dailyDungeon = dailyDungeonService.select(playerContext.getId());
        Map<Integer, DailyDungeonModel> dungeonMap = dailyDungeon.getDungeonMap();
        DailyDungeonModel dailyDungeonModel = dungeonMap.get(msg.getMissionType());
        if (dailyDungeonModel == null) {
            dailyDungeonModel = new DailyDungeonModel();
            dailyDungeonModel.setRefreshTime(DateTimeUtil.tomorrowBreak());
            dungeonMap.put(msg.getMissionType(), dailyDungeonModel);
        }

        // TODO 当前关卡是否能挑战，战力，上一关是否通过
        Asserts.isTrue(role.getMaxFighting() > dailyMissionReward.getPower_require(),
                ErrorCode.DAILY_MISSION_FIGHTING_NOT_ENOUGH.getValue(),
                () -> "role fighting:" + role.getMaxFighting() + " need fighting" + dailyMissionReward.getPower_require());

        Asserts.isTrue(dailyDungeonModel.getPassMaxMission() + 1 >= msg.getMissionId(),
                ErrorCode.DAILY_MISSION_CAN_NOT_FIGHT.getValue(),
                () -> "current mission id:" + dailyMissionReward.getMission() + " can not fight:" + msg.getMissionId());


        DailyDungeonModel finalDailyDungeonModel = dailyDungeonModel;
        Asserts.isTrue(dailyDungeonModel.getBattleNum() + 1 <= roleVipService.getDailyDungeonNum(playerContext.getId()),
                ErrorCode.DAILY_DUNGEON_BATTLE_NUM.getValue(),
                () -> "current times:" + finalDailyDungeonModel.getBattleNum() + " max times:" + roleVipService.getDailyDungeonNum(playerContext.getId()));

        GameEvent gameEvent = GameEvent.DAILY_DUNGEON;
        DailyDungeonGMsg.GResDailyDungeonEnd.Builder builder = DailyDungeonGMsg.GResDailyDungeonEnd.newBuilder();
        boolean isWin = false;

        // 扫荡
        if (msg.getSweep() == 1) {
            // 判断是否可以扫荡
            Asserts.isTrue(dailyDungeonModel.getPassMaxMission() >= msg.getMissionId(),
                    ErrorCode.DAILY_MISSION_CAN_NOT_SWEEP.getValue(),
                    () -> "current mission id:" + dailyMissionReward.getMission()
                            + " can not sweep fight:" + msg.getMissionId());
            isWin = true;
            // 扫荡 奖励通知走通用接口
            gameEvent = GameEvent.DAILY_DUNGEON_SWEEP;
        } else {
            // 战斗，奖励和战报一起返回，统一接口不弹框
            gameEvent = GameEvent.DAILY_DUNGEON;

            //  调用战斗方法
            BattlerDo attacker = battleHelper.queryPlayerBattler(BattleType.DAILY, playerContext.getId(), Faction.ATTACKER);

            CLanguage cLanguage = languageSysCache.getByKey(dailyMissionReward.getLan());
            String defNick = "";
            if (Objects.nonNull(cLanguage)) {
                defNick = languageHelper.getLanguageBy(cLanguage);
            }
            List<CDailyMission> dailyMissionList = dailyMissionSysCache.getDailyMission(msg.getMissionType(), msg.getMissionId());
            BattlerDo defender = battleHelper.queryNpcBattler(dailyMissionList, defNick);

            BattleCommand battleCommand = BattleCommand.createOf(BattleType.DAILY, attacker, defender);
            commandBus.invoke(battleCommand);

            BattleResult battleResult = battleCommand.getResult();
            isWin = battleResult.isWin();
            builder.setReport(battleResult.getReport());
        }

        //扣钱
        CDailyMissionCost cDailyMissionCost = dailyMissionCostSysCache.getConfig(msg.getMissionType(),
                dailyDungeonModel.getBattleNum() + 1);
        if (CollectionUtil.isNotEmpty(cDailyMissionCost.getCost())) {
            thingService.cost(role.getId(), cDailyMissionCost.getCost(), gameEvent);
        }

        DailyDungeonType dailyDungeonType = DailyDungeonType.of(msg.getMissionType());

        if (isWin) {
            //更新次数
            dailyDungeonModel.setBattleNum(dailyDungeonModel.getBattleNum() + 1);

            if (msg.getMissionId() > dailyDungeonModel.getPassMaxMission()) {//更新关卡
                dailyDungeonModel.setPassMaxMission(msg.getMissionId());
            }

            //神职特权加成收益
            List<ImmutableThing> rewardList = clergyService.dungeonPrivilege(playerContext.getId(), dailyDungeonType, dailyMissionReward.getReward());
            int chance_status = rewardList.size() > 0 ? 1 : 0;
            rewardList.addAll(dailyMissionReward.getReward());
            rewardList = ImmutableThingUtil.mergeThing(rewardList);

            //加道具
            Rewards rewards = thingService.add(role.getId(), rewardList, gameEvent, NoticeType.SLIENT);
            if (msg.getSweep() == 0) {
                // 战斗，奖励随战报一起返回
                builder.addAllList(PbUtil.buildReward(rewards));
                builder.setChanceStatus(chance_status);
            }

            if (msg.getSweep() == 1) {
                DailyDungeonGMsg.GResDailyDungeonSweep.Builder builder1 = DailyDungeonGMsg.GResDailyDungeonSweep.newBuilder();
                builder1.setMissionType(msg.getMissionType());
                builder1.addAllList(PbUtil.buildReward(rewardList));
                builder1.setChanceStatus(chance_status);
                playerContext.write(CmdCode._19003, builder1.build());
            }

        }
        dailyDungeonService.updateOne(dailyDungeon);


        builder.setMissionId(msg.getMissionId());
        builder.setMissionType(msg.getMissionType());
        playerContext.write(CmdCode._19002, builder.build());
        eventBus.post(JoinDailyDungeonEvent.of(playerContext.getId(), dailyDungeonType));
    }
}
