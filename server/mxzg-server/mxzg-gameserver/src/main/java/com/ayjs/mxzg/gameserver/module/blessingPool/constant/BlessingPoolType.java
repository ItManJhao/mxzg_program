package com.ayjs.mxzg.gameserver.module.blessingPool.constant;

import com.ayjs.mxzg.common.collect.MoreCollectors;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.template.constant.ErrorCode;

import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * 许愿池类型
 */
public enum BlessingPoolType {
    /**
     * 普通
     */
    Normal(1, "普通","47631"),
    /**
     * 高级
     */
    Advance(2, "高级","41107"),
    ;

    private final int value;
    private String name;
    private String langKey;

    BlessingPoolType(int value, String name, String langKey) {
        this.value = value;
        this.name = name;
        this.langKey = langKey;
    }

    public int getValue() {
        return value;
    }

    public String getName() {
        return name;
    }

    public String getLangKey(){
        return langKey;
    }

    private static final Map<Integer, BlessingPoolType> ENUMS = Stream.of(values()).collect(
            MoreCollectors.toImmutableMapAndThen(Collectors.toMap(BlessingPoolType::getValue, Function.identity())));

    public static BlessingPoolType of(int value) {
        BlessingPoolType BlessingPoolType = ENUMS.get(value);
        Asserts.notNull(BlessingPoolType, ErrorCode.BLESSING_POOL_TYPE_ERROR.getValue(),
                () -> String.format("Invalid value for BlessingPoolType: %s", value));
        return BlessingPoolType;
    }
}
