package com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.struct;

import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.Map;


/**
 * 敌人信息
 * @author
 */
@Getter
@Setter
public class FleetEnemyInfo {

    private String nick;

    private int serverId;

    private Map<Integer, BattlerVo> enemyMap = new HashMap<>();
}
