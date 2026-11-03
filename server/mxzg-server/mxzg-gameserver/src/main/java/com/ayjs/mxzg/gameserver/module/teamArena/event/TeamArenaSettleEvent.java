package com.ayjs.mxzg.gameserver.module.teamArena.event;

import lombok.Value;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2020/4/15
 **/
@Value(staticConstructor = "of")
public class TeamArenaSettleEvent {

    private Map<Integer, List<Long>> rank2Roles=new HashMap<>();
}
