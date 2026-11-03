package com.ayjs.mxzg.gameserver.module.planewar.handler;

import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.config.excel.cache.BattleTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.LanguageSysCache;
import com.ayjs.mxzg.config.excel.cache.planewar.PlaneWarConsumeSysCache;
import com.ayjs.mxzg.config.excel.cache.planewar.PlaneWarHeroSysCache;
import com.ayjs.mxzg.config.excel.cache.planewar.PlaneWarInformationSysCache;
import com.ayjs.mxzg.config.excel.cache.planewar.PlaneWarLevelSysCache;
import com.ayjs.mxzg.config.excel.entity.CBattleType;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.config.excel.entity.CLanguage;
import com.ayjs.mxzg.config.excel.entity.planewar.CPlaneWarConsume;
import com.ayjs.mxzg.config.excel.entity.planewar.CPlaneWarHero;
import com.ayjs.mxzg.config.excel.entity.planewar.CPlaneWarInformation;
import com.ayjs.mxzg.config.excel.entity.planewar.CPlaneWarLevel;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.planewar.converter.PlaneWarPBConverter;
import com.ayjs.mxzg.gameserver.module.planewar.domain.PlaneWar;
import com.ayjs.mxzg.gameserver.module.planewar.event.PlaneWarPassEvent;
import com.ayjs.mxzg.gameserver.module.planewar.service.PlaneWarService;
import com.ayjs.mxzg.gameserver.module.rank.constant.RankType;
import com.ayjs.mxzg.gameserver.module.rank.service.AbstractPlayerRankService;
import com.ayjs.mxzg.gameserver.module.rank.service.RankServiceProxy;
import com.ayjs.mxzg.protocol.PlaneWarGMsg;
import com.ayjs.mxzg.protocol.PvpGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.mxzg.template.language.LanguageHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.List;
import java.util.Set;

/**
 * @Author: CWJ
 * @Date: 2020/9/15
 **/
@Component
public class PlaneWarHandler extends ProtocolHandler {

    @Autowired
    private PlaneWarLevelSysCache planeWarLevelSysCache;
    @Autowired
    private PlaneWarInformationSysCache planeWarInformationSysCache;
    @Autowired
    private PlaneWarHeroSysCache planeWarHeroSysCache;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;
    @Autowired
    private LanguageSysCache languageSysCache;
    @Autowired
    private PlaneWarConsumeSysCache planeWarConsumeSysCache;
    @Autowired
    private BattleTypeSysCache battleTypeSysCache;

    @Autowired
    private PlaneWarService planeWarService;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private HeroService heroService;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private LanguageHelper languageHelper;
    @Autowired
    private ThingService thingService;
    @Autowired
    private PlaneWarPBConverter planeWarPBConverter;
    @Autowired
    private RankServiceProxy rankServiceProxy;
    @Autowired
    private EventBus eventBus;


    @CMD(id = CmdCode._75701)
    public void getData(PlayerContext playerContext, PlaneWarGMsg.GReqPlaneWarData req) {
        PlaneWar planeWar = planeWarService.get(playerContext.getId());
        playerContext.write(CmdCode._75701, planeWarPBConverter.builderData(planeWar));
    }

    @CMD(id = CmdCode._75702)
    public void challenge(PlayerContext playerContext, PlaneWarGMsg.GReqPlaneWarChallenge req) {
        CPlaneWarLevel config = planeWarLevelSysCache.getOrThrow(req.getIdx());
        DayOfWeek dayOfWeek = LocalDate.now().getDayOfWeek();
        Set<Integer> openElement = planeWarInformationSysCache.getOpenElement(dayOfWeek.getValue());
        Asserts.isTrue(openElement.contains(config.getElement()),
                ErrorCode.PLANE_WAR_LEVEL_ERROR.getValue(),
                String.format("关卡idx:{%s}-{%s}未开放", config.getIdx(), GsonUtils.toJson(openElement)));

        PlaneWar planeWar = planeWarService.get(playerContext.getId());
        Integer currLv = planeWar.getPassLevelInfo().getOrDefault(config.getElement(), 0);
        Asserts.isTrue(config.getLevel() == currLv + 1,
                ErrorCode.PLANE_WAR_LEVEL_ERROR.getValue(),
                String.format("挑战关卡{%s}等级错误，当前等级{%s}", config.getIdx(), currLv));

        int remainingChallengeCount = planeWarService.getRemainingChallengeCount(planeWar);
        Asserts.isTrue(remainingChallengeCount > 0,
                ErrorCode.PLANE_WAR_COUNT_LOW.getValue(),
                String.format("挑战次数{%s}不足", remainingChallengeCount));

        CPlaneWarInformation planeWarInformationConfig = planeWarInformationSysCache.getOrThrow(config.getElement());
        CBattleType cBattleType = battleTypeSysCache.getOrThrow(planeWarInformationConfig.getBattle_type());
        HeroLineUp planeWarLineUp = heroLineUpService.getLineUpByType(playerContext.getId(), cBattleType.getLine_up_type());

        Asserts.isTrue(planeWarLineUp.getFormationMap().size() > 0,
                ErrorCode.PLANE_WAR_LINE_UP_ERROR.getValue(),
                String.format("阵容错误，数量{%s}", planeWarLineUp.getFormationMap().size()));

        planeWarLineUp.getFormationMap().keySet().forEach(heroId -> {
            Hero hero = heroService.getHero(planeWar.getRid(), heroId);
            CHeroType cHeroType = heroTypeSysCache.getOrThrow(hero.getType());
            Asserts.isTrue(cHeroType.getElem() == config.getElement(),
                    ErrorCode.PLANE_WAR_LEVEL_ERROR.getValue(),
                    String.format("阵容错误，{%s}关卡元素不匹配，英雄元素{%s}", config.getIdx(), cHeroType.getElem()));
        });

        BattlerDo playerDo = battleHelper.queryPlayerBattler(cBattleType.getLine_up_type(), playerContext.getId(), Faction.ATTACKER);
        CLanguage language = languageSysCache.getByKey(String.valueOf(config.getBattle_language()));
        String battleName = languageHelper.getLanguageBy(language);
        List<CPlaneWarHero> heroConfigs = planeWarHeroSysCache.getByLevelIdxAndTurn(config.getIdx(), planeWarService.getTurn().getTurn());
        BattlerDo monsterDo = battleHelper.queryNpcBattler(heroConfigs, battleName);
        BattleResult battleResult = battleHelper.invokeBattle(BattleType.valueOf(cBattleType.getType()), playerDo, monsterDo);

        if (battleResult.isWin()) {
            planeWar.addPassLevel(config.getElement());
            eventBus.post(PlaneWarPassEvent.of(planeWar.getRid(), config.getElement(), config.getLevel()));
        }
        planeWar.addHadChallengeCount(1);
        planeWarService.update(planeWar);

        if (battleResult.isWin()) {
            thingService.add(planeWar.getRid(), config.getReward(), GameEvent.PLANE_WAR_CHALLENGE, NoticeType.SLIENT);
        }

        playerContext.write(CmdCode._75702, planeWarPBConverter.builderChallenge(planeWar, battleResult,
                config));
    }

    @CMD(id = CmdCode._75703)
    public void sweep(PlayerContext playerContext, PlaneWarGMsg.GReqPlaneWarSweep req) {
        CPlaneWarLevel config = planeWarLevelSysCache.getOrThrow(req.getIdx());
        DayOfWeek dayOfWeek = LocalDate.now().getDayOfWeek();
        Set<Integer> openElement = planeWarInformationSysCache.getOpenElement(dayOfWeek.getValue());
        Asserts.isTrue(openElement.contains(config.getElement()),
                ErrorCode.PLANE_WAR_LEVEL_ERROR.getValue(),
                String.format("关卡{%s}-{%s}未开放", config.getIdx(), dayOfWeek));

        PlaneWar planeWar = planeWarService.get(playerContext.getId());
        Integer currLv = planeWar.getPassLevelInfo().getOrDefault(config.getElement(), 0);
        Asserts.isTrue(config.getLevel() <= currLv,
                ErrorCode.PLANE_WAR_LEVEL_ERROR.getValue(),
                String.format("挑战关卡{%s}等级错误，当前等级{%s}", config.getIdx(), currLv));

        int remainingChallengeCount = planeWarService.getRemainingChallengeCount(planeWar);
        Asserts.isTrue(remainingChallengeCount > 0,
                ErrorCode.PLANE_WAR_COUNT_LOW.getValue(),
                String.format("挑战次数{%s}不足", remainingChallengeCount));

        planeWar.addHadChallengeCount(1);
        planeWarService.update(planeWar);

        thingService.add(planeWar.getRid(), config.getReward(), GameEvent.PLANE_WAR_CHALLENGE);

        playerContext.write(CmdCode._75703, planeWarPBConverter.builderSweep());
    }


    @CMD(id = CmdCode._75704)
    public void buyCount(PlayerContext playerContext, PlaneWarGMsg.GReqPlaneWarBuyCount req) {
        PlaneWar planeWar = planeWarService.get(playerContext.getId());
        Asserts.isTrue(planeWar.getHadBuyCount() < planeWarService.getBuyMaxCount(planeWar.getRid()),
                ErrorCode.PLANE_WAR_BUY_COUNT_MAX.getValue(),
                String.format("购买次数达到上限{%s}不足", planeWar.getHadBuyCount()));

        CPlaneWarConsume consumeConfig = planeWarConsumeSysCache.getOrThrow(planeWar.getHadBuyCount() + 1);

        Asserts.isTrue(thingService.enough(planeWar.getRid(), consumeConfig.getConsume()),
                ErrorCode.ITEM_NUM_LOW.getValue(),
                String.format("道具{%s}数量不足", GsonUtils.toJson(consumeConfig.getConsume())));

//        int remainingChallengeCount = planeWarService.getRemainingChallengeCount(planeWar);
//        Asserts.isTrue(remainingChallengeCount < planeWarService.getFreeMaxCount(planeWar.getRid()),
//                ErrorCode.PLANE_WAR_CHALLENGE_COUNT_MAX.getValue(),
//                String.format("挑战次数{%s}-{%s}已达上限", remainingChallengeCount, planeWarService.getFreeMaxCount(planeWar.getRid())));
        thingService.cost(planeWar.getRid(), consumeConfig.getConsume(), GameEvent.PLANE_WAR_BUY_COUNT_COST);

        planeWar.setHadBuyCount(planeWar.getHadBuyCount() + 1);
        planeWarService.update(planeWar);

        playerContext.write(CmdCode._75704, planeWarPBConverter.builderBuyCount(planeWar));
    }

    @CMD(id = CmdCode._75705)
    public void rank(PlayerContext playerContext, PlaneWarGMsg.GReqPlaneWarRank req) {
        AbstractPlayerRankService rankService = rankServiceProxy.getPlayerRank(RankType.PLANE_WAR);
        List<PvpGMsg.PSRankPlayerData> rankList = rankService.showRanks(RankType.PLANE_WAR.getRankCount());
        PvpGMsg.PSRankPlayerData self = rankService.selfRank(playerContext.getId());
        playerContext.write(CmdCode._75705, planeWarPBConverter.builderRank(rankList, self));
    }
}
