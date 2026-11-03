package com.ayjs.mxzg.config.struct;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.ThreadUtil;
import com.google.common.collect.ImmutableList;
import com.google.common.reflect.TypeToken;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 物品工具类
 */
@Slf4j
public class ImmutableThingUtil {

    public static ImmutableList<ImmutableThing> fromJson(String json) {
        if (StringUtils.isBlank(json) || json.length() <= 3) {
            return ImmutableList.of();
        }
        ImmutableList<ImmutableThing> things = GJsonUtils.fromJson(json, new TypeToken<ImmutableList<ImmutableThing>>() {
        });
        try {
            if (getAllItemNums(things) <= 0) {
                log.info("things json number less than 0 :{}, stack:{}", json, ThreadUtil.getCurrentPackageStackTraceToStr());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return things;
    }

    /**
     * 获取列表所有物品的数量总量
     *
     * @param things
     * @return
     */
    public static long getAllItemNums(List<ImmutableThing> things) {
        if (CollectionUtil.isEmpty(things)) {
            return 0;
        }
        return things.stream().mapToLong(ImmutableThing::getItem_num).sum();
    }

    /**
     * 按类型合并奖励列表
     */
    public static List<ImmutableThing> mergeThing(List<ImmutableThing> things) {
        Map<Integer, ImmutableThing> map = new HashMap<>();
        for (ImmutableThing thing : things) {
            ImmutableThing oldThing = map.get(thing.getThingId());
            if (oldThing == null) {
                map.put(thing.getThingId(),
                        ImmutableThing.of(thing.getItem_type(), thing.getItem_num(), thing.getChance()));
            } else {
                map.put(thing.getThingId(), ImmutableThing.of(thing.getItem_type(),
                        oldThing.getItem_num() + thing.getItem_num(), thing.getChance()));
            }
        }
        return new ArrayList<>(map.values());
    }


    public static List<ImmutableThing> multiplyThing(List<ImmutableThing> things, int multiply) {
        List<ImmutableThing> resultList = new ArrayList<>();
        for (ImmutableThing oldThing : things) {
            ImmutableThing thing = ImmutableThing.of(oldThing.getItem_type(), oldThing.getItem_num() * multiply, oldThing.getChance());
            resultList.add(thing);
        }
        return resultList;
    }

    /***
     * 乘以小数，向上取整
     * @param things
     * @param multiply
     * @return
     */
    public static List<ImmutableThing> multiplyThing(List<ImmutableThing> things, float multiply) {
        List<ImmutableThing> resultList = new ArrayList<>();
        for (ImmutableThing oldThing : things) {
            ImmutableThing thing = ImmutableThing.of(oldThing.getItem_type(), (long) Math.ceil(oldThing.getItem_num() * multiply), oldThing.getChance());
            resultList.add(thing);
        }
        return resultList;
    }

}
