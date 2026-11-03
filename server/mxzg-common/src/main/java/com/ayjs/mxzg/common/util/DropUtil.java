/**
 *
 */
package com.ayjs.mxzg.common.util;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Objects;
import java.util.function.Function;

/**
 * @author YY
 *
 */
public class DropUtil {

    /**
     * 默认随机概率上限
     */
    public static final int UPPER_LIMIT = 1000000;

//    /**
//     * @author YY 掉落随机物接口
//     */
//    public static interface IDrop {
//        public int getId();
//
//        public int getRate();
//    }

    public static <T> T randomDrop(Collection<T> dropGroup, Function<T, Integer> idField, Function<T, Integer> rateField) {
        if (dropGroup.isEmpty()) {
            return null;
        }
        int totalRate = 0;
        for (T drop : dropGroup) {
            totalRate += rateField.apply(drop);
        }
        return randomOneDrop(dropGroup, totalRate, idField, rateField);
    }

    private static <T> T randomOneDrop(Collection<T> dropGroup, int totalRate, Function<T, Integer> idField, Function<T, Integer> rateField) {
        // 随机概率
        int randomRate = RandomUtil.getRandomInt(1, totalRate);
        // 当前几率和
        int rate = 0;
        for (T drop : dropGroup) {
            rate += rateField.apply(drop);
            if (randomRate <= rate) {
                if (idField.apply(drop) > 0) {
                    return drop;
                }
                break;
            }
        }
        return null;
    }

    /**
     * 单个独立概率随机
     */
    public static <T extends IDrop> List<T> independentProbability(Collection<T> things, int times, int upperLimit) {
        List<T> result = new ArrayList<>();
        if (Objects.isNull(things) || things.isEmpty() || times <= 0) {
            return result;
        }
        for (int i = 0; i < times; i++) {
            int rand = RandomUtil.rand(0, upperLimit);
            for (T thing : things) {
                if (thing.getRate() >= rand) {
                    result.add(thing);
                }
            }
        }
        return result;
    }

    /**
     * 单个独立概率随机
     */
    public static <T extends IDrop> List<T> independentProbability(Collection<T> things, int times) {
        return independentProbability(things, times, UPPER_LIMIT);
    }

    /**
     * 随机一个掉落物分组
     *
     * @param dropGroup
     * @return
     */
    public static <T extends IDrop> T randomDrop(Collection<T> dropGroup) {
        if (dropGroup.isEmpty()) {
            return null;
        }
        int totalRate = 0;
        for (T drop : dropGroup) {
            totalRate += drop.getRate();
        }
        return randomOneDrop(dropGroup, totalRate);
    }

    /**
     * 随机出一个物品
     *
     * @param dropGroup 随机列表
     * @param totalRate 总概率
     * @return
     */
    private static <T extends IDrop> T randomOneDrop(Collection<T> dropGroup, int totalRate) {
        // 随机概率
        int randomRate = RandomUtil.getRandomInt(1, totalRate);
        // 当前几率和
        int rate = 0;
        for (T drop : dropGroup) {
            rate += drop.getRate();
            if (randomRate <= rate) {
                if (drop.getDropId() > 0) {
                    return drop;
                }
                break;
            }
        }
        return null;
    }

    /**
     * 从随机列表中随机出count个不同的物品
     *
     * @param dropGroup
     * @param count
     * @return
     */
    @SuppressWarnings("unchecked")
    public static <T extends IDrop> List<T> randomDifDrop(Collection<T> dropGroup, int count) {
        if (CommonUtil.isCollectionEmpty(dropGroup)) {
            return null;
        }
        // if (count >= dropGroup.size()) {
        // return dropGroup;
        // }

        List<T> results = new ArrayList<>(count);
        // 统计概率
        int totalRate = 0;
        for (T drop : dropGroup) {
            totalRate += drop.getRate();
        }

        Object[] randomArray = dropGroup.toArray(new Object[dropGroup.size()]);
        for (int i = 0; i < count; i++) {
            int random = RandomUtil.getRandomInt(1, totalRate);
            // 当前几率和
            int value = 0;
            for (int j = 0; j < randomArray.length; j++) {
                T drop = (T) randomArray[j];
                if (drop == null) {
                    continue;
                }
                value += drop.getRate();
                if (random <= value) {
                    if (drop.getDropId() > 0) {
                        // 将随机得出的位置设置为null，并减去当次随机结果的概率
                        randomArray[j] = null;
                        totalRate = totalRate - drop.getRate();

                        results.add(drop);
                    }
                    break;
                }
            }
        }
        return results;
    }
}
