package com.ayjs.mxzg.gameserver.module.reikiEquip.struct;

import com.ayjs.mxzg.common.collect.MoreCollectors;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.gameserver.module.shop.constant.ShopType;

import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * 傀儡羊对应星级
 *
 * @author hyx
 */
public enum ReplaceTypeEnum {

    SIX(901808, 6),

    NINE(901809, 9),

    TEN(901810, 10),

    ;

    ReplaceTypeEnum(int itemId, int star) {
        this.itemId = itemId;
        this.star = star;
    }

    private static final Map<Integer, ReplaceTypeEnum> ENUMS = Stream.of(values()).collect(
            MoreCollectors.toImmutableMapAndThen(Collectors.toMap(ReplaceTypeEnum::getItemId, Function.identity())));

    public static ReplaceTypeEnum of(int value) {
        ReplaceTypeEnum ReplaceTypeEnum = ENUMS.get(value);
        Asserts.notNull(ReplaceTypeEnum, () -> String.format("傀儡羊枚举不存在道具id: %s", value));
        return ReplaceTypeEnum;
    }

    /**
     * 道具id
     */
    private int itemId;

    /**
     * 星级
     */
    private int star;

    public int getItemId() {
        return itemId;
    }

    public int getStar() {
        return star;
    }

}
