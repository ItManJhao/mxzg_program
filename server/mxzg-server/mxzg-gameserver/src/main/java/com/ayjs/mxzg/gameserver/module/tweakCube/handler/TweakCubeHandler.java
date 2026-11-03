package com.ayjs.mxzg.gameserver.module.tweakCube.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.tweakCube.TweakCubeConst;
import com.ayjs.mxzg.config.excel.cache.tweakCube.TweakCubeTrenchOpenSysCache;
import com.ayjs.mxzg.config.excel.entity.tweakCube.CTweakCubeTrenchOpen;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.tweakCube.converter.TweakCubePB;
import com.ayjs.mxzg.gameserver.module.tweakCube.domain.Trench;
import com.ayjs.mxzg.gameserver.module.tweakCube.domain.TweakCube;
import com.ayjs.mxzg.gameserver.module.tweakCube.service.TweakCubeService;
import com.ayjs.mxzg.protocol.TweakCubeGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Objects;

/**
 * @Author: CWJ
 * @Date: 2020/9/8
 **/
@Component
public class TweakCubeHandler extends ProtocolHandler {

    @Autowired
    private TweakCubeService tweakCubeService;
    @Autowired
    private HeroService heroService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private TweakCubeTrenchOpenSysCache tweakCubeTrenchOpenSysCache;
    @Autowired
    private TweakCubeConst tweakCubeConst;


    @CMD(id = CmdCode._75501)
    public void getData(PlayerContext playerContext, TweakCubeGMsg.GReqTweakCube req) {
        TweakCube tweakCube = tweakCubeService.get(playerContext.getId());
        playerContext.write(CmdCode._75501, TweakCubePB.builder(tweakCube));
    }

    @CMD(id = CmdCode._75502)
    public void trenchAddHero(PlayerContext playerContext, TweakCubeGMsg.GReqTrenchAddHero req) {
        TweakCube tweakCube = tweakCubeService.get(playerContext.getId());

        Asserts.isTrue(tweakCube.getHeroRanks().size() >= tweakCubeConst.getTweakCubeRankHeroNum(),
                ErrorCode.TWEAK_CUBE_RANK_LOW.getValue(),
                String.format("供奉英雄数量不足{%s}", tweakCube.getHeroRanks().size()));

        Asserts.isTrue(!tweakCube.getHeroRanks().contains(req.getHeroId()),
                ErrorCode.TWEAK_CUBE_HERO_CANT_ADD_TRENCH.getValue(),
                String.format("已经在供奉榜上{%s}-{%s}", GsonUtils.toJson(tweakCube.getHeroRanks()), req.getHeroId()));

        Asserts.isTrue(!tweakCubeService.isInTrench(playerContext.getId(), req.getHeroId()),
                ErrorCode.TWEAK_CUBE_HERO_CANT_ADD_TRENCH.getValue(),
                String.format("已经在槽位上{%s}-{%s}", GsonUtils.toJson(tweakCube.getTrenchHeroes()), req.getHeroId()));

        Asserts.isTrue(tweakCube.getTrenches().size() >= req.getTrenchIndex() && req.getTrenchIndex() >= 1,
                ErrorCode.TWEAK_CUBE_TRENCH_INDEX_ERROR.getValue(),
                String.format("槽位索引异常{%s}-{%s}", tweakCube.getTrenches().size(), req.getTrenchIndex()));

        Trench trench = tweakCube.getTrenches().get(req.getTrenchIndex() - 1);

        Asserts.isTrue(trench.getLastChangeTime() + tweakCubeConst.getTweakCubeTrenchRemoveCD() < TimeDateUtil.getCurrentTimeInt(),
                ErrorCode.TWEAK_CUBE_TRENCH_IN_CD.getValue(),
                String.format("cd中{%s}-{%s}", trench.getLastChangeTime(), TimeDateUtil.getCurrentTimeInt()));

        Asserts.isTrue(trench.getHeroId() == 0,
                ErrorCode.TWEAK_CUBE_TRENCH_HAD_HERO.getValue(),
                String.format("槽位已经有英雄{%s}-{%s}", req.getTrenchIndex(), trench.getHeroId()));

        Hero hero = heroService.getHero(playerContext.getId(), req.getHeroId());
        Asserts.isTrue(Objects.nonNull(hero),
                ErrorCode.HERO_NOT_EXIST.getValue(),
                String.format("没找到英雄{%s}", trench.getHeroId()));

        tweakCube.addToTrench(req.getTrenchIndex() - 1, req.getHeroId());
        tweakCubeService.update(tweakCube);

        playerContext.write(CmdCode._75502, TweakCubePB.builderAddToTrench(req.getTrenchIndex(), trench));
        playerContext.write(CmdCode._75506, TweakCubePB.builderUpdateTweakCubeLv(req.getHeroId(), tweakCubeService.getTweakCubeLvAndStage(hero)));

        heroService.computeStrength(hero, GameEvent.TWEAK_CUBE_TRENCH);
    }

    @CMD(id = CmdCode._75503)
    public void trenchRemoveHero(PlayerContext playerContext, TweakCubeGMsg.GReqTrenchRemoveHero req) {
        TweakCube tweakCube = tweakCubeService.get(playerContext.getId());

        Asserts.isTrue(tweakCube.getTrenches().size() >= req.getTrenchIndex() && req.getTrenchIndex() >= 1,
                ErrorCode.TWEAK_CUBE_TRENCH_INDEX_ERROR.getValue(),
                String.format("槽位索引异常{%s}-{%s}", tweakCube.getTrenches().size(), req.getTrenchIndex()));

        Trench trench = tweakCube.getTrenches().get(req.getTrenchIndex() - 1);

        Asserts.isTrue(trench.getHeroId() > 0,
                ErrorCode.TWEAK_CUBE_TRENCH_HAD_HERO.getValue(),
                String.format("槽位已经有英雄{%s}-{%s}", req.getTrenchIndex(), trench.getHeroId()));

        long removeId = tweakCubeService.removeHeroFromTrench(playerContext.getId(), req.getTrenchIndex() - 1, true);

        tweakCubeService.update(tweakCube);

        playerContext.write(CmdCode._75503, TweakCubePB.builderRemoveFromTrench(req.getTrenchIndex(), trench));
        playerContext.write(CmdCode._75506, TweakCubePB.builderUpdateTweakCubeLv(removeId, new int[]{0, 0}));

    }

    @CMD(id = CmdCode._75504)
    public void openTrench(PlayerContext playerContext, TweakCubeGMsg.GReqTrenchOpen req) {
        TweakCube tweakCube = tweakCubeService.get(playerContext.getId());

        Asserts.isTrue(tweakCube.getTrenches().size() < tweakCubeTrenchOpenSysCache.getAll().size(),
                ErrorCode.TWEAK_CUBE_TRENCH_MAX.getValue(),
                String.format("槽位数量最大{%s}-{%s}", tweakCube.getTrenches().size(), tweakCubeTrenchOpenSysCache.getAll().size()));
        CTweakCubeTrenchOpen config = tweakCubeTrenchOpenSysCache.getOrThrow(tweakCube.getTrenches().size() + 1);
        Asserts.isTrue(thingService.enough(playerContext.getId(), config.getCost()),
                ErrorCode.ITEM_NUM_LOW.getValue(),
                String.format("道具数量不足{%s}", GsonUtils.toJson(config.getCost())));

        thingService.cost(playerContext.getId(), config.getCost(), GameEvent.TWEAK_CUBE_TRENCH_OPEN_COST);

        Trench trench = new Trench();
        tweakCube.getTrenches().add(trench);
        tweakCubeService.update(tweakCube);

        playerContext.write(CmdCode._75504, TweakCubePB.builderOpenTrench(tweakCube.getTrenches().size(), trench));
    }

    @CMD(id = CmdCode._75505)
    public void clearCd(PlayerContext playerContext, TweakCubeGMsg.GReqTrenchClearCd req) {
        TweakCube tweakCube = tweakCubeService.get(playerContext.getId());

        Asserts.isTrue(tweakCube.getTrenches().size() >= req.getTrenchIndex() && 0 < req.getTrenchIndex(),
                ErrorCode.TWEAK_CUBE_TRENCH_INDEX_ERROR.getValue(),
                String.format("槽位数量最大{%s}", req.getTrenchIndex()));

        Trench trench = tweakCube.getTrenches().get(req.getTrenchIndex() - 1);

        Asserts.isTrue(trench.getLastChangeTime() + tweakCubeConst.getTweakCubeTrenchRemoveCD() > TimeDateUtil.getCurrentTimeInt(),
                ErrorCode.TWEAK_CUBE_TRENCH_MAX.getValue(),
                String.format("槽位cd{%s}-{%s}", trench.getLastChangeTime(), TimeDateUtil.getCurrentTimeInt()));

        Asserts.isTrue(thingService.enough(playerContext.getId(), tweakCubeConst.getTweakCubeClearCdCost()),
                ErrorCode.ITEM_NUM_LOW.getValue(),
                String.format("道具数量不足{%s}", GsonUtils.toJson(tweakCubeConst.getTweakCubeClearCdCost())));

        thingService.cost(playerContext.getId(), tweakCubeConst.getTweakCubeClearCdCost(), GameEvent.TWEAK_CUBE_TRENCH_OPEN_COST);

        trench.setLastChangeTime(0);
        tweakCubeService.update(tweakCube);

        playerContext.write(CmdCode._75505, TweakCubePB.builderTrenchClearCd(req.getTrenchIndex(), trench));
    }


}
