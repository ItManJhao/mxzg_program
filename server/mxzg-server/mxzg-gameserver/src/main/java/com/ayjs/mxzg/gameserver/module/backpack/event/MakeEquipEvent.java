package com.ayjs.mxzg.gameserver.module.backpack.event;

import lombok.Value;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 单种装备合成
 */
@Value(staticConstructor = "of")
public class MakeEquipEvent {
    /**
     * 角色id
     */
    private long rid;
    /**
     * 合成数量
     */
    public int times;

    /**
     * 装备类型集
     */
    private Map<Integer,Integer> equipTypeMap;
}
