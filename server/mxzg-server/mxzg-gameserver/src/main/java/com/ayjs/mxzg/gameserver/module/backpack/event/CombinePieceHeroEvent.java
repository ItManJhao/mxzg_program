package com.ayjs.mxzg.gameserver.module.backpack.event;

import lombok.Value;

/**
 * 碎片合成英雄
 */
@Value(staticConstructor = "of")
public class CombinePieceHeroEvent {
    /**
     * 角色id
     */
    private long rid;
    /**
     * 合成数量
     */
    private int times;
    /**
     * 得到4星英雄数量
     */
    private int star4Number;
    /**
     * 得到5星英雄数量
     */
    private int star5Number;
}
