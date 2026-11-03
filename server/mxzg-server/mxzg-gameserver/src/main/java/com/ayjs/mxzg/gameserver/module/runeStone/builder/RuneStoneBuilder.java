package com.ayjs.mxzg.gameserver.module.runeStone.builder;

import com.ayjs.mxzg.gameserver.module.runeStone.domain.RuneStone;
import com.ayjs.mxzg.gameserver.module.runeStone.struct.RuneStoneExtraGrid;
import com.ayjs.mxzg.protocol.RuneStoneGMsg;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/7/31
 **/
public class RuneStoneBuilder {

    public static RuneStoneGMsg.GResRuneStoneList builder(List<RuneStone> runeStones) {
        RuneStoneGMsg.GResRuneStoneList.Builder builder = RuneStoneGMsg.GResRuneStoneList.newBuilder();
        runeStones.forEach(runeStone -> builder.addRuneStone(builder(runeStone)));
        return builder.build();
    }

    public static RuneStoneGMsg.PSRuneStone builder(RuneStone runeStone) {
        RuneStoneGMsg.PSRuneStone.Builder builder = RuneStoneGMsg.PSRuneStone.newBuilder();
        builder.setId(runeStone.getId());
        builder.setIdx(runeStone.getIdx());
        builder.setLock(runeStone.isLock());
        runeStone.getExtraGrid().values().forEach(grid -> builder.addAptitude(builderAptitude(grid)));
        builder.setHeroId(runeStone.getHeroId());
        builder.setPlace(runeStone.getPlace());
        return builder.build();
    }

    public static RuneStoneGMsg.PSRuneStoneAptitude builderAptitude(RuneStoneExtraGrid grid) {
        RuneStoneGMsg.PSRuneStoneAptitude.Builder builder = RuneStoneGMsg.PSRuneStoneAptitude.newBuilder();
        builder.setPlace(grid.getPlace());
        builder.setIdx(grid.getExtraAptitude().getIdx());
        builder.setValue(grid.getExtraAptitude().getValue());
        return builder.build();
    }

    public static RuneStoneGMsg.GResRuneStoneAdd builderAdd(List<RuneStone> runeStones) {
        RuneStoneGMsg.GResRuneStoneAdd.Builder builder = RuneStoneGMsg.GResRuneStoneAdd.newBuilder();
        runeStones.forEach(runeStone -> builder.addRuneStone(builder(runeStone)));
        return builder.build();
    }

    public static RuneStoneGMsg.GResRuneStoneDelete builderDelete(List<RuneStone> runeStones) {
        RuneStoneGMsg.GResRuneStoneDelete.Builder builder = RuneStoneGMsg.GResRuneStoneDelete.newBuilder();
        runeStones.forEach(runeStone -> builder.addId(runeStone.getIdx()));
        return builder.build();
    }
}
