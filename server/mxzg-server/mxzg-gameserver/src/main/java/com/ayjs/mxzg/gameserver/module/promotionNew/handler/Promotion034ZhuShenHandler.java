package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.battle.command.BattleCommand;
import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.HeroHpInfo;
import com.ayjs.mxzg.battle.model.UnitType;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.exception.ErrorCodeException;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.config.excel.cache.LanguageSysCache;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion034PveRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion034PveSysCache;
import com.ayjs.mxzg.config.excel.entity.CLanguage;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion034Pve;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion034PveReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.config.struct.ItemType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion034ZhuShen;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.ZhuShenPassEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion034ZhuShenService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.ZhuShenLevelInfo;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.protocol.Promotion034GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.mxzg.template.language.LanguageHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2019/10/25
 **/
@Component
public class Promotion034ZhuShenHandler extends ProtocolHandler {

    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private Promotion034ZhuShenService promotion034ZhuShenService;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    ThingService thingService;
    @Autowired
    CommandBus commandBus;
    @Autowired
    private Promotion034PveSysCache promotion034PveSysCache;
    @Autowired
    private Promotion034PveRewardSysCache promotion034PveRewardSysCache;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private LanguageSysCache languageSysCache;
    @Autowired
    private LanguageHelper languageHelper;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private BattleTemplate battleTemplate;

    @CMD(id = CmdCode._13150)
    public void sendData(PlayerContext playerContext, Promotion034GMsg.GReqZhuShenData req) {
        Promotion034ZhuShen promotionInfo = promotion034ZhuShenService.getPromotionInfo(playerContext.getId());
        Promotion034GMsg.GResZhuShenData.Builder builder = Promotion034GMsg.GResZhuShenData.newBuilder();
        promotionInfo.getLevelInfoMap().forEach((type, levelInfo) -> {
            Promotion034GMsg.PSLevelData.Builder levelData = Promotion034GMsg.PSLevelData.newBuilder();
            levelData.setType(type);
            levelData.setLevel(levelInfo.getLevel());
            levelData.setHp(levelInfo.getCurrHpRate());
            builder.addLevelData(levelData);
        });
        playerContext.write(CmdCode._13150, builder.build());
    }

    @CMD(id = CmdCode._13152)
    public void reward(PlayerContext playerContext, Promotion034GMsg.GReqBuyItem req) {
        int count = req.getCount();
        if (!promotionControlService.isPromotionRunning(PromotionType.ZHU_SHEN_ZHI_ZHAN)) {
            throw new ErrorCodeException(ErrorCode.HERO_ARRIVE_END.getValue(), "活动已结束");
        }
        if (count <= 0) {
            throw new ErrorCodeException(ErrorCode.SYSTEM_ERROR.getValue(), String.format("请求数量[%s]错误", count));
        }
        int promotionPveItemNeedGem = systemSysCache.getPromotionPveItemNeedGem();
        ImmutableThing cost = ImmutableThing.of(ItemType.IT_GEM, promotionPveItemNeedGem);
        List<ImmutableThing> costs = ImmutableThingUtil.multiplyThing(Arrays.asList(cost), count);

        thingService.cost(playerContext.getId(), costs, GameEvent.ZHU_SHEN);
        List<ImmutableThing> rewards = ImmutableThingUtil.multiplyThing(systemSysCache.getPromotionPveItemReward(), count);
        thingService.add(playerContext.getId(), rewards, GameEvent.ZHU_SHEN);

    }

    @CMD(id = CmdCode._13153)
    public void battle(PlayerContext playerContext, Promotion034GMsg.GReqZhuShenBattle req) {
        int missionType = req.getMissionType();
        int missionId = req.getMissionId();
        int sweepCount = req.getSweepCount();
        Asserts.isTrue(sweepCount >= 0, ErrorCode.SYSTEM_ERROR.getValue(), () -> String.format("扫荡数量[%s]请求错误", sweepCount));

        Promotion034ZhuShen promotionInfo = promotion034ZhuShenService.getPromotionInfo(playerContext.getId());

        PromotionControl control = promotionControlService.getControl(PromotionType.ZHU_SHEN_ZHI_ZHAN);
        Asserts.isTrue(promotionControlService.isPromotionRunning(PromotionType.ZHU_SHEN_ZHI_ZHAN),
                ErrorCode.PROMOTION_NOT_STARTING.getValue(), "诸神之战活动未开启");
        ZhuShenLevelInfo levelInfo = promotionInfo.getLevelInfoMap().get(missionType);
        Asserts.notNull(levelInfo,
                ErrorCode.SYSTEM_ERROR.getValue(), String.format("关卡信息不存在,{%s}", missionType));

        int level = levelInfo.getLevel();
        Asserts.isTrue(missionId == level, ErrorCode.SYSTEM_ERROR.getValue(), "关卡错误");

        int sweepCount_ = sweepCount < 1 ? 1 : sweepCount;

        CPromotion034PveReward rewardConfig = promotion034PveRewardSysCache.getConfigsByTurn(control.getTurns()).stream()
                .filter(configTemp -> configTemp.getMission_type() == missionType
                && configTemp.getMission_id() == missionId).findFirst().get();
        BattlerVo battlerVo = promotionInfo.getTypeVoMap().get(missionType);
        BattleType battleType = BattleType.valueOf(rewardConfig.getBattle_type());
        BattleResult battleResult = null;
        int battleCount = 0;
        long damageValue = 0;
        for (int round = 1; round <= sweepCount_; round++) {//第一次进入战斗
            if (battlerVo == null) {
                List<CPromotion034Pve> configs = promotion034PveSysCache.getConfigsByTurn(control.getTurns()).stream().
                        filter(configTemp -> configTemp.getMission_type() == missionType
                        && configTemp.getMission_id() == missionId).collect(Collectors.toList());

                CLanguage cLanguage = languageSysCache.getByKey(rewardConfig.getName_lang());
                battleResult = battleHelper.invokePVEBattle(battleType, playerContext.getId(), configs, languageHelper.getLanguageBy(cLanguage));
            } else {//根据vo进入战斗
                CLanguage cLanguage = languageSysCache.getByKey(rewardConfig.getName_lang());
                BattlerDo monsterDo = battleTemplate.queryBattler(battlerVo, languageHelper.getLanguageBy(cLanguage), Faction.DEFENDER, UnitType.MOSTER);
                BattlerDo playerDo = battleHelper.queryPlayerBattler(battleType, playerContext.getId(), Faction.ATTACKER);
                BattleCommand battleCommand = BattleCommand.createOf(battleType, playerDo, monsterDo);
                commandBus.invoke(battleCommand);
                battleResult = battleCommand.getResult();
            }
            battleCount = round;
            damageValue += battleResult.getTotalDamage(Faction.ATTACKER);
            if (battleResult.isWin()) {
                break;
            }
            battlerVo = battleResult.buildDefenderVo();
        }
        thingService.cost(playerContext.getId(), ImmutableThingUtil.multiplyThing(systemSysCache.getPromotionPveFightNeedItem(), battleCount), GameEvent.ZHU_SHEN);

        long currHp = battleResult.defenderHpInfo().values().stream().mapToLong(HeroHpInfo::getCurrentHp).sum();
        if (levelInfo.getTotalHp() <= 0) {
            levelInfo.setTotalHp(battleResult.defenderHpInfo().values().stream().mapToLong(HeroHpInfo::getMaxHp).sum());
        }
        long maxHp = levelInfo.getTotalHp();

        //战斗结束后,怪物信息入库
        List<ImmutableThing> rewards = new ArrayList<>();
        if (battleResult.isWin()) {//通关

            levelInfo.setLevel(level + 1);
            levelInfo.setCurrHpRate(Promotion034ZhuShenService.HP_RATE);
            levelInfo.setTotalHp(0);
            promotionInfo.getTypeVoMap().put(missionType, null);

            rewards.addAll(rewardConfig.getFinal_reward());
            promotionInfo.getTypeVoMap().remove(missionType);
            boolean nextLv = promotion034PveRewardSysCache.getConfigsByTurn(control.getTurns()).stream().
                    anyMatch(configTemp -> configTemp.getMission_type() == missionType
                    && configTemp.getMission_id() == missionId + 1);
//            if (!nextLv)//不存在下一关时,代表这个类型已经通关
            eventBus.post(ZhuShenPassEvent.of(playerContext.getId(), missionType));
        } else {
            levelInfo.setCurrHpRate((int) Math.ceil(currHp * 1.0f / maxHp * Promotion034ZhuShenService.HP_RATE));
            promotionInfo.getTypeVoMap().put(missionType, battleResult.buildDefenderVo());
        }

        promotion034ZhuShenService.updatePromotion(promotionInfo);
        //奖励
        for (int i = 0; i < sweepCount_; i++) {
            rewards.add(RandomUtil.getRand(rewardConfig.getRandom_reward()));
        }

        rewards = ImmutableThingUtil.mergeThing(rewards);
        thingService.add(playerContext.getId(), rewards, GameEvent.ZHU_SHEN, NoticeType.SLIENT);

        Promotion034GMsg.GResZhuShenBattle.Builder builder = Promotion034GMsg.GResZhuShenBattle.newBuilder();
        if (sweepCount == 0) {//非战斗,不发送战报
            builder.setReport(battleResult.getReport());
        }
        builder.setSweepCount(sweepCount);

        Promotion034GMsg.PSLevelData.Builder levelData = Promotion034GMsg.PSLevelData.newBuilder();
        levelData.setType(missionType);
        levelData.setLevel(level);
        levelData.setHp(battleResult.isWin() ? 0 : levelInfo.getCurrHpRate());

        builder.addAllRewards(PbUtil.buildReward(rewards));
        builder.setTotalHp(currHp);
        builder.setLevelData(levelData);
        builder.setDamageValue(damageValue);
        playerContext.write(CmdCode._13153, builder.build());
    }
}
