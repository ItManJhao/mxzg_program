package com.ayjs.mxzg.gameserver.module.hades.converter;

import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.hades.domain.Hades;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.HadesGMsg;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2021/1/6
 **/
@Component
public class HadesPBBuilder {

    public HadesGMsg.GResHadesInfo builderInfo(Hades hades, HadesGMsg.HadesType type) {
        HadesGMsg.GResHadesInfo.Builder builder = HadesGMsg.GResHadesInfo.newBuilder();
        builder.setPassFloor(hades.getFloorByType(type.getNumber()));
        builder.setSweepCount(hades.getSweepCount(type.getNumber()));
        builder.setType(type);
        return builder.build();
    }

    public HadesGMsg.GResHadesChallenge builderChallenge(BattleResult battleResult, List<ImmutableThing> list, HadesGMsg.HadesType type, int floor) {
        HadesGMsg.GResHadesChallenge.Builder builder = HadesGMsg.GResHadesChallenge.newBuilder();
        builder.addAllPassReward(PbUtil.buildReward(list));
        builder.setReport(battleResult.getReport());
        builder.setPassFloor(floor);
        builder.setType(type);
        return builder.build();
    }

    public HadesGMsg.GResHadesSweep builderSweep(HadesGMsg.HadesType type, int sweepCount) {
        HadesGMsg.GResHadesSweep.Builder builder = HadesGMsg.GResHadesSweep.newBuilder();
        builder.setSweepCount(sweepCount);
        builder.setType(type);
        return builder.build();
    }
}
