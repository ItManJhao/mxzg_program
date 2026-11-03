package com.ayjs.mxzg.gameserver.module.buygold.constant;

import com.google.common.collect.ImmutableMap;

import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * 点金类型
 */
public enum BuyGoldType {
    /**
     * 免费
     */
    Free(1),
    /**
     * 小量
     */
    Lower(2),
    /**
     * 大量
     */
    Advanced(3);

    private int value;

    private static final Map<Integer, BuyGoldType> ENUMS = Stream.of(values()).collect(
            Collectors.collectingAndThen(Collectors.toMap(BuyGoldType::getValue, Function.identity()),
                    ImmutableMap::copyOf));

    BuyGoldType(int value) {
        this.value = value;
    }

    public int getValue() {
        return this.value;
    }

    public static BuyGoldType of(int value) {
        return ENUMS.get(value);
    }

}
