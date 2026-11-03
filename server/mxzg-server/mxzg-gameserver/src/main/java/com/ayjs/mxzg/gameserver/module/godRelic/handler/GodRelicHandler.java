package com.ayjs.mxzg.gameserver.module.godRelic.handler;

import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.UnitType;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.cache.GodRelicLevelSysCache;
import com.ayjs.mxzg.config.excel.cache.GodRelicStarRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.GodRelicSysCache;
import com.ayjs.mxzg.config.excel.cache.GodRelicUnlockSysCache;
import com.ayjs.mxzg.config.excel.cache.LanguageSysCache;
import com.ayjs.mxzg.config.excel.constant.GodRelicConst;
import com.ayjs.mxzg.config.excel.entity.CGodRelic;
import com.ayjs.mxzg.config.excel.entity.CGodRelicLevel;
import com.ayjs.mxzg.config.excel.entity.CGodRelicStarReward;
import com.ayjs.mxzg.config.excel.entity.CLanguage;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.gm.GMCommand;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.GMCmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.godRelic.domain.GodRelic;
import com.ayjs.mxzg.gameserver.module.godRelic.domain.GodRelicLevel;
import com.ayjs.mxzg.gameserver.module.godRelic.event.GodRelicAddStarEvent;
import com.ayjs.mxzg.gameserver.module.godRelic.event.GodRelicPassEvent;
import com.ayjs.mxzg.gameserver.module.godRelic.service.GodRelicService;
import com.ayjs.mxzg.gameserver.module.godRelic.service.GodRelicTargetHelper;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.protocol.GodRelicGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.mxzg.template.language.LanguageHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/3/23
 **/
@Component
public class GodRelicHandler extends ProtocolHandler {

    @Autowired
    private GodRelicService godRelicService;
    @Autowired
    private GodRelicSysCache godRelicSysCache;
    @Autowired
    private GodRelicLevelSysCache godRelicLevelSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private GodRelicStarRewardSysCache godRelicStarRewardSysCache;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private GodRelicTargetHelper godRelicTargetHelper;
    @Autowired
    private GodRelicUnlockSysCache godRelicUnlockSysCache;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private GodRelicConst godRelicConst;
    @Autowired
    private BattleTemplate battleTemplate;
    @Autowired
    private LanguageSysCache languageSysCache;
    @Autowired
    private LanguageHelper languageHelper;

    @CMD(id = CmdCode._62001)
    public void sendData(PlayerContext playerContext, GodRelicGMsg.GReqGodRelicData req) {
        GodRelic godRelic = godRelicService.load(playerContext.getId());
        GodRelicGMsg.GResGodRelicData.Builder builder = GodRelicGMsg.GResGodRelicData.newBuilder();
        builder.setBuyCount(godRelic.getBuyCount());
        builder.setCanChallengeCount(godRelic.getCanChallengeCount());
        godRelicService.loadAllGodRelicLevel(playerContext.getId()).forEach(godRelicLevel -> {
            if (godRelicLevel.getCompleteTarget().size() != 0) {
                builder.addStarMap(builderStar(godRelicLevel.getChapter(), godRelicLevel.getLevel(), godRelicLevel.getCompleteTarget()));
            }
        });
        builder.addAllStarRewardRecord(godRelic.getStarRewardRecord());
        playerContext.write(CmdCode._62001, builder.build());
    }

    public GodRelicGMsg.PSStarData builderStar(int chapter, int level, List<Integer> targetIds) {
        GodRelicGMsg.PSStarData.Builder builder = GodRelicGMsg.PSStarData.newBuilder();
        builder.setChapter(chapter);
        builder.setLevel(level);
        builder.addAllCompleteId(targetIds);
        return builder.build();
    }

    //限制了每章的最大关卡数未32
    private int chapterLevel(int chapter, int lv) {
        return chapter << 5 | lv;
    }

    @CMD(id = CmdCode._62002)
    public void challenge(PlayerContext playerContext, GodRelicGMsg.GReqGodRelicChallenge req) {

        GodRelic godRelic = godRelicService.load(playerContext.getId());

        CGodRelic config = godRelicSysCache.getById(req.getIdx());

        if (chapterLevel(godRelic.getMaxChapter(), godRelic.getMaxLevel() + 1) < chapterLevel(config.getChapter(), config.getLevel())) {
            Asserts.isTrue(godRelic.getMaxLevel() >= godRelicSysCache.getByChapter(godRelic.getMaxChapter()).size(),
                    ErrorCode.GOD_RELIC_PASS_LEVEL_LOW.getValue(), String.format("关卡数不够{%s}-{%s},请求关卡{%s}",
                            godRelic.getMaxChapter(), godRelic.getMaxLevel(), config.getIdx()));

            Asserts.isTrue(godRelic.getSumStar() >= godRelicUnlockSysCache.getById(config.getChapter()).getUnlock_need_star(),
                    ErrorCode.GOD_RELIC_CHAPTER_STAR_LOW.getValue(), String.format("星级数不足{%s}-{%s}",
                            godRelic.getSumStar(), godRelicUnlockSysCache.getById(config.getChapter()).getUnlock_need_star()));

            Asserts.isTrue(godRelic.getMaxChapter() + 1 == config.getChapter() && config.getLevel() == 1, ErrorCode.GOD_RELIC_PASS_LEVEL_LOW.getValue(),
                    String.format("通关关卡数不足{%s}-{%s},请求关卡{%s}", godRelic.getMaxChapter(), godRelic.getMaxLevel(), config.getIdx()));

        }

        Asserts.isTrue(godRelic.getCanChallengeCount() > 0, ErrorCode.GOD_RELIC_CHALLENGE_COUNT_LOW.getValue(), String.format("挑战次数不足{%s}", config.getIdx()));

        Map<Integer, List<CGodRelicLevel>> byMission = godRelicLevelSysCache.getByMission(req.getIdx());

        BattlerDo playerDo = battleHelper.queryPlayerBattler(BattleType.GOD_RELIC, playerContext.getId(), Faction.ATTACKER);

        List<BattleResult> battleResults = new ArrayList<>();
        boolean win = true;
        for (int i = 1; i <= byMission.size(); i++) {
            List<CGodRelicLevel> cGodRelicLevels = byMission.get(i);
            CLanguage language = languageSysCache.getByKey(godRelicConst.getLevelLanguage());
            BattlerDo monsterDo = battleTemplate.queryBattler(cGodRelicLevels, String.format(languageHelper.getLanguageBy(language),
                    config.getChapter(), config.getLevel()), Faction.DEFENDER, UnitType.MOSTER);
            BattleResult battleResult = battleHelper.invokeBattle(BattleType.GOD_RELIC, playerDo, monsterDo);

            battleResults.add(battleResult);
            if (!battleResult.isWin()) {
                win = false;
                break;
            }
        }

        List<Integer> completeIds = new ArrayList<>();
        GodRelicLevel godRelicLevel = godRelicService.loadLevel(playerContext.getId(), config.getChapter(), config.getLevel());
        List<Integer> maxCompleteIds = godRelicLevel.getCompleteTarget();
        Rewards reward = null;
        for (Integer targetId : config.getTarget()) {
            boolean complete = godRelicTargetHelper.verify(targetId, battleResults);
            if (complete) {
                completeIds.add(targetId);
            }
        }
        if (win) {
            if (maxCompleteIds.size() <= completeIds.size()) {
                godRelicLevel.setCompleteTarget(completeIds);
                godRelicService.update(godRelicLevel);

                if (completeIds.size() > maxCompleteIds.size()) {
                    godRelic.setSumStar(godRelic.getSumStar() + completeIds.size() - maxCompleteIds.size());
                    eventBus.post(GodRelicAddStarEvent.of(playerContext.getId()));
                }
                maxCompleteIds.addAll(completeIds);
                maxCompleteIds = completeIds;
            }

            if (chapterLevel(godRelic.getMaxChapter(), godRelic.getMaxLevel()) < chapterLevel(config.getChapter(), config.getLevel())) {
                godRelic.setMaxChapter(config.getChapter());
                godRelic.setMaxLevel(config.getLevel());
                reward = thingService.add(playerContext.getId(), config.getFirst_reward(), GameEvent.GOD_RELIC_PASS_REWARD, NoticeType.SLIENT);
            } else {
                reward = thingService.add(playerContext.getId(), config.getReward(), GameEvent.GOD_RELIC_PASS_REWARD, NoticeType.SLIENT);
            }

            godRelic.setCanChallengeCount(godRelic.getCanChallengeCount() - 1);
            godRelicService.update(godRelic);

            eventBus.post(GodRelicPassEvent.of(playerContext.getId(), req.getIdx()));
        }

        GodRelicGMsg.GResGodRelicChallenge.Builder builder = GodRelicGMsg.GResGodRelicChallenge.newBuilder();
        builder.addAllBattleReport(battleResults.stream().map(BattleResult::getReport).collect(Collectors.toList()));
        builder.setCanChallengeCount(godRelic.getCanChallengeCount());
        if (reward != null) {
            builder.addAllReward(PbUtil.buildReward(reward));
        }
        builder.setStarMap(builderStar(config.getChapter(), config.getLevel(), completeIds));
        builder.setMaxStarMap(builderStar(config.getChapter(), config.getLevel(), maxCompleteIds));
        playerContext.write(CmdCode._62002, builder.build());

    }

    @CMD(id = CmdCode._62003)
    public void buyCount(PlayerContext playerContext, GodRelicGMsg.GReqGodRelicBuyCount req) {
        GodRelic godRelic = godRelicService.load(playerContext.getId());

        Asserts.isTrue(godRelic.getBuyCount() < godRelicConst.getGodRelicDailyBuyTimes(), ErrorCode.GOD_RELIC_BUY_COUNT_OVER.getValue(),
                String.format("诸神遗迹购买上限{%S}", godRelic.getBuyCount()));

        Asserts.isTrue(thingService.enough(playerContext.getId(), godRelicConst.getGodRelicDailyBuyNeed()), ErrorCode.ITEM_NUM_LOW.getValue(),
                String.format("道具不足"));

        thingService.cost(playerContext.getId(), godRelicConst.getGodRelicDailyBuyNeed(), GameEvent.GOD_RELIC_BUY_COUNT_COST);

        godRelic.setBuyCount(godRelic.getBuyCount() + 1);
        godRelic.setCanChallengeCount(godRelic.getCanChallengeCount() + 1);
        godRelicService.update(godRelic);

        GodRelicGMsg.GResGodRelicBuyCount.Builder builder = GodRelicGMsg.GResGodRelicBuyCount.newBuilder();
        builder.setBuyCount(godRelic.getBuyCount());
        builder.setCanChallengeCount(godRelic.getCanChallengeCount());
        playerContext.write(CmdCode._62003, builder.build());

    }

    @CMD(id = CmdCode._62004)
    public void getStarReward(PlayerContext playerContext, GodRelicGMsg.GReqGodRelicGetStarReward req) {

        GodRelic godRelic = godRelicService.load(playerContext.getId());

        CGodRelicStarReward config = godRelicStarRewardSysCache.getById(req.getIdx());

        Asserts.isTrue(!godRelic.getStarRewardRecord().contains(req.getIdx()), ErrorCode.GOD_RELIC_BUY_COUNT_OVER.getValue(),
                String.format("该星级奖励{%S}已经领取", req.getIdx()));

        int sum = 0;

        List<GodRelicLevel> levels = godRelicService.loadAllGodRelicLevel(playerContext.getId()).stream().
                filter(godRelicLevelTemp -> godRelicLevelTemp.getChapter() == config.getChapter()).collect(Collectors.toList());
        for (GodRelicLevel level : levels) {
            sum += level.getCompleteTarget().size();
        }

        Asserts.isTrue(sum >= config.getStar(), ErrorCode.GOD_RELIC_CHAPTER_STAR_LOW.getValue(),
                String.format("星级数不够{%s}-{%s}", sum, config.getStar()));

        thingService.add(playerContext.getId(), config.getReward(), GameEvent.GOD_RELIC_STAR_REWARD);

        godRelic.getStarRewardRecord().add(config.getIdx());
        godRelicService.update(godRelic);

        GodRelicGMsg.GResGodRelicGetStarReward.Builder builder = GodRelicGMsg.GResGodRelicGetStarReward.newBuilder();
        builder.setIdx(req.getIdx());
        playerContext.write(CmdCode._62004, builder.build());
    }

    @CMD(id = CmdCode._62005)
    public void sweep(PlayerContext playerContext, GodRelicGMsg.GReqGodRelicSweep req) {

        GodRelic godRelic = godRelicService.load(playerContext.getId());

        CGodRelic config = godRelicSysCache.getById(req.getIdx());

        Asserts.isTrue(godRelic.getMaxChapter() > config.getChapter() ||
                        (godRelic.getMaxChapter() == config.getChapter() && godRelic.getMaxLevel() >= config.getLevel()),
                ErrorCode.GOD_RELIC_PASS_LEVEL_LOW.getValue(), String.format("通关关卡数不够{%s}", config.getIdx()));

        GodRelicLevel godRelicLevel = godRelicService.loadLevel(playerContext.getId(), config.getChapter(), config.getLevel());
        int completeStar = godRelicLevel.getCompleteTarget().size();
        Asserts.isTrue(completeStar >= config.getTarget().size(),
                ErrorCode.GOD_RELIC_CHAPTER_STAR_LOW.getValue(), String.format("星级数不够{%s}", completeStar));

        Asserts.isTrue(godRelic.getCanChallengeCount() > 0, ErrorCode.GOD_RELIC_CHALLENGE_COUNT_LOW.getValue(), String.format("挑战次数不足{%s}", config.getIdx()));

        godRelic.setCanChallengeCount(godRelic.getCanChallengeCount() - 1);
        godRelicService.update(godRelic);

        thingService.add(playerContext.getId(), config.getReward(), GameEvent.GOD_RELIC_PASS_REWARD);

        GodRelicGMsg.GResGodRelicSweep.Builder builder = GodRelicGMsg.GResGodRelicSweep.newBuilder();
        builder.setCanChallengeCount(godRelic.getCanChallengeCount());

        playerContext.write(CmdCode._62005, builder.build());
    }

    @GMCommand(command = GMCmdCode.GOD_RELIC_ADD_LEVEL)
    public void addLv(Role role, List<String> param) {
        int chapter = Integer.valueOf(param.get(0));
        int level = Integer.valueOf(param.get(1));
        GodRelic godRelic = godRelicService.load(role.getId());
        List<GodRelicLevel> update = new ArrayList<>();
        for (CGodRelic config : godRelicSysCache.getAll()) {
            if (chapterLevel(chapter, level) >= chapterLevel(config.getChapter(), config.getLevel())) {
                GodRelicLevel godRelicLevel = godRelicService.loadLevel(role.getId(), config.getChapter(), config.getLevel());
                List<Integer> complete = new ArrayList<>(config.getTarget());
                if (complete.size() > godRelicLevel.getCompleteTarget().size()) {
                    godRelic.setSumStar(godRelic.getSumStar() + complete.size() - godRelicLevel.getCompleteTarget().size());
                    godRelicLevel.setCompleteTarget(complete);
                    update.add(godRelicLevel);
                }
            }
        }
        if (update.size() > 0) {
            godRelic.setMaxChapter(chapter);
            godRelic.setMaxLevel(level);
            godRelicService.update(godRelic);
            godRelicService.updateList(update);
            eventBus.post(GodRelicAddStarEvent.of(role.getId()));
        }
    }

    @GMCommand(command = GMCmdCode.GOD_RELIC_ADD_COUNT)
    public void addCount(Role role, List<String> param) {
        int count = Integer.valueOf(param.get(0));
        GodRelic godRelic = godRelicService.load(role.getId());
        godRelic.setCanChallengeCount(count);
        godRelicService.update(godRelic);
    }
}
