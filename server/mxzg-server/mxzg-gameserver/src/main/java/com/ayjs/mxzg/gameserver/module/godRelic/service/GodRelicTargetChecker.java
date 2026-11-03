package com.ayjs.mxzg.gameserver.module.godRelic.service;

import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.config.struct.GodRelicTarget;
import com.ayjs.mxzg.config.struct.GodRelicTargetType;

import java.util.List;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2020/3/23
 **/
public interface GodRelicTargetChecker {

    GodRelicTargetType getType();

    boolean verify(GodRelicTarget godRelicTarget, List<BattleResult> object);

}
