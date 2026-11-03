package com.ayjs.mxzg.gameserver.module.backpack.service;

import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.backpack.service.processor.ThingType;
import com.ayjs.mxzg.template.constant.ErrorCode;

/**
 * 物品处理
 */
public interface ThingProcessor {
    /**
     * 资源类型
     */
    ThingType thingType();

    /**
     * 物品不足错误码
     */
    ErrorCode notEnoughCode();

    /**
     * 获取拥有的数量
     */
    long getCount(long rid, int thingType);

    /**
     * 物品是否足够
     */
    default boolean enough(long rid, ImmutableThing thing) {
        requireNotNegative(thing.getNum(), thing.getItem_type());
        long remainCount = getCount(rid, thing.getThingId()) - thing.getNum();
        return remainCountGeZero(remainCount);
    }

    /**
     * 增加之前
     */
    default ThingSet prepareAdd(long rid, ThingSet thingSet, GameEvent gameEvent) {
        requireValid(thingSet);
        return thingSet;
    }

    /**
     * 执行增加
     */
    Rewards add(long rid, ThingSet thingSet, GameEvent gameEvent);

    /**
     * 增加之后
     */
    default void afterExecuteAdd(long rid, Rewards rewards, GameEvent gameEvent) {
    }

    /**
     * 消耗之前
     */
    ThingSet prepareCost(long rid, ThingSet thingSet, GameEvent gameEvent);

    /**
     * 执行消耗
     */
    void cost(long rid, ThingSet thingSet, GameEvent gameEvent);

    /**
     * 消耗之后
     */
    default void afterExecuteCost(long rid, ThingSet thingSet, GameEvent gameEvent) {
    }

    static void requireNotNegative(long value, int thingType) {
        Asserts.isTrue(value >= 0L,
                () -> String.format("thing type:{} value {%s} cannot be negative", thingType, value));
    }

    /**
     * 计算实际获得值 超出丢弃
     *
     * @param upperLimit 上限
     * @param count      拥有数量
     * @param reward     获得数量
     */
    static long computeRealAdd(long upperLimit, long count, long reward) {
        long value = upperLimit - count;
        return value < 0L ? 0L : (Math.min(value, reward));
    }

    /**
     * 验证合法性
     */
    default void requireValid(ThingSet thingSet) {
        thingSet.asList().forEach(this::requireValid);
    }


    /**
     * 验证合法性
     */
    default void requireValid(ImmutableThing thing) {
        requireNotNegative(thing.getNum(), thing.getItem_type());
    }

    /**
     * 剩余数量是否大于等于0
     */
    static boolean remainCountGeZero(long remainCount) {
        return remainCount >= 0L;
    }

    /**
     * 要求剩余数量大于等于0
     */
    static void requireRemainCountGeZero(long remainCount, int thingType, ErrorCode errorCode) {
        Asserts.isTrue(remainCountGeZero(remainCount), errorCode.getValue(),
                () -> String.format("%s:%s, 还需要: %s", errorCode.getDesc(), thingType, -remainCount));
    }

    /**
     * 要求物品足够
     */
    default void requireEnough(long rid, ImmutableThing thing) {
        long remainCount = getCount(rid, thing.getThingId()) - thing.getNum();
        ThingProcessor.requireRemainCountGeZero(remainCount, thing.getItem_type(), notEnoughCode());
    }

    default long combine(ThingSet thingSet) {
        return thingSet.asList().stream().mapToLong(ImmutableThing::getItem_num).sum();
    }
}
