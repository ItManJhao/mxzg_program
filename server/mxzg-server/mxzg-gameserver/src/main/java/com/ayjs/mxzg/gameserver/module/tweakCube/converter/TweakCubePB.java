package com.ayjs.mxzg.gameserver.module.tweakCube.converter;

import com.ayjs.mxzg.gameserver.module.tweakCube.domain.Trench;
import com.ayjs.mxzg.gameserver.module.tweakCube.domain.TweakCube;
import com.ayjs.mxzg.protocol.TweakCubeGMsg;
import com.google.common.collect.Maps;

import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2020/9/8
 **/
public class TweakCubePB {

    public static TweakCubeGMsg.GResTweakCube builder(TweakCube tweakCube) {
        TweakCubeGMsg.GResTweakCube.Builder builder = TweakCubeGMsg.GResTweakCube.newBuilder();
        builder.setOpenCount(tweakCube.getTrenches().size());
        builder.addAllRankHero(tweakCube.getHeroRanks());
        for (int i = 0; i < tweakCube.getTrenches().size(); i++) {
            builder.addTrench(builderTrench(i + 1, tweakCube.getTrenches().get(i)));
        }
        return builder.build();
    }

    /***
     * 这个需要比list的索引大1，客户端说从1开始
     * @param trenchIndex
     * @param trench
     * @return
     */
    public static TweakCubeGMsg.GResTrenchAddHero builderAddToTrench(int trenchIndex, Trench trench) {
        TweakCubeGMsg.GResTrenchAddHero.Builder builder = TweakCubeGMsg.GResTrenchAddHero.newBuilder();
        builder.setTrench(builderTrench(trenchIndex, trench));
        return builder.build();
    }

    public static TweakCubeGMsg.GResTrenchRemoveHero builderRemoveFromTrench(int trenchIndex, Trench trench) {
        TweakCubeGMsg.GResTrenchRemoveHero.Builder builder = TweakCubeGMsg.GResTrenchRemoveHero.newBuilder();
        builder.setTrench(builderTrench(trenchIndex, trench));
        return builder.build();
    }

    public static TweakCubeGMsg.GResTrenchOpen builderOpenTrench(int trenchIndex, Trench trench) {
        TweakCubeGMsg.GResTrenchOpen.Builder builder = TweakCubeGMsg.GResTrenchOpen.newBuilder();
        builder.setTrench(builderTrench(trenchIndex, trench));
        builder.setOpenCount(trenchIndex);
        return builder.build();
    }

    public static TweakCubeGMsg.GResTrenchClearCd builderTrenchClearCd(int trenchIndex, Trench trench) {
        TweakCubeGMsg.GResTrenchClearCd.Builder builder = TweakCubeGMsg.GResTrenchClearCd.newBuilder();
        builder.setTrench(builderTrench(trenchIndex, trench));
        return builder.build();
    }

    public static TweakCubeGMsg.PSTrench builderTrench(int index, Trench trench) {
        TweakCubeGMsg.PSTrench.Builder builder = TweakCubeGMsg.PSTrench.newBuilder();
        builder.setIndex(index);
        builder.setHeroId(trench.getHeroId());
        builder.setLastChangeTime(trench.getLastChangeTime());
        return builder.build();
    }

    public static TweakCubeGMsg.GResUpdateHeroTweakCube builderUpdateTweakCubeLv(long heroId, int[] lvAndStage) {
        Map<Long, int[]> map = Maps.newHashMap();
        map.put(heroId, lvAndStage);
        return builderUpdateTweakCubeLv(map);
    }

    public static TweakCubeGMsg.GResUpdateHeroTweakCube builderUpdateTweakCubeLv(Map<Long, int[]> heroTweakCubeMap) {
        TweakCubeGMsg.GResUpdateHeroTweakCube.Builder builder = TweakCubeGMsg.GResUpdateHeroTweakCube.newBuilder();
        heroTweakCubeMap.forEach((heroId, lv) -> {
            TweakCubeGMsg.PSHeroTweakCubeLv.Builder psBuilder = TweakCubeGMsg.PSHeroTweakCubeLv.newBuilder();
            psBuilder.setHeroId(heroId);
            psBuilder.setLv(lv[0]);
            psBuilder.setStage(lv[1]);
            builder.addUpdate(psBuilder);
        });
        return builder.build();
    }

}
