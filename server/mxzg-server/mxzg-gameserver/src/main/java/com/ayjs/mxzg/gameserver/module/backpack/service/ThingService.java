/**
 *
 */
package com.ayjs.mxzg.gameserver.module.backpack.service;

import cn.hutool.core.util.StrUtil;
import com.ayjs.mxzg.common.base.IRegister;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.InternerPool;
import com.ayjs.mxzg.config.excel.cache.ItemSysCache;
import com.ayjs.mxzg.config.excel.entity.CItem;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.config.struct.ThingBonus;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.event.ThingAddEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.ThingCostEvent;
import com.ayjs.mxzg.gameserver.module.backpack.service.processor.ItemProcessor;
import com.ayjs.mxzg.gameserver.module.backpack.service.processor.ThingType;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PrivilegeEffectType;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.mxzg.template.constant.GameConstant;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.EnumMap;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

import static java.util.stream.Collectors.toList;

/**
 * 物品服务
 *
 */
@Service
public class ThingService implements IRegister<ThingProcessor> {

    // 通用物品类型处理
    private final EnumMap<ThingType, ThingProcessor> processorMap = new EnumMap<>(ThingType.class);

    /**
     * 加锁KEY前缀
     */
    private static final String PREFIX = "THING";

    @Autowired
    private EventBus eventBus;
    @Autowired
    private ItemSysCache itemSysCache;
    @Autowired
    private ItemProcessor itemProcessor;

    @Override
    public void registerBean(ThingProcessor bean) {
        Asserts.isNull(processorMap.putIfAbsent(bean.thingType(), bean), String.format("%s duplicated", bean.thingType()));
    }

    public ThingProcessor getProcessor(ThingType thingType) {
        ThingProcessor thingProcessor = processorMap.get(thingType);
        Asserts.notNull(thingProcessor, () -> String.format("%s unregistered", thingType));
        return thingProcessor;
    }

    public ThingProcessor getProcessor(int thingType) {
        CItem cItem = itemSysCache.getOrThrow(thingType);
        return getProcessor(ThingType.of(cItem.getType()));
    }

    public long getCount(long rid, int thingType) {
        return getProcessor(thingType).getCount(rid, thingType);
    }

    /**
     * 要求物品足够
     *
     * @param rid   玩家id
     * @param thing 需要物品
     */
    public void requireEnough(long rid, ImmutableThing thing) {
        ThingProcessor processor = getProcessor(thing.getThingId());
        processor.requireEnough(rid, thing);
    }

    /**
     * 物品是否足够
     */
    public boolean enough(long rid, ImmutableThing thing) {
        ThingProcessor processor = getProcessor(thing.getThingId());
        return processor.enough(rid, thing);
    }

    /**
     * 物品是否足够
     */
    public boolean enough(long playerId, List<ImmutableThing> things) {
        return things.stream().allMatch(n -> enough(playerId, n));
    }

    /**
     * 奖励内容数量求和
     *
     * @param things
     * @return
     */
    public int combine(List<ImmutableThing> things) {
        Map<ThingProcessor, ThingSet> grouping = groupingByProcessor(ThingSet.of(things));
        return grouping.entrySet().stream().map(k -> k.getKey().combine(k.getValue())).reduce(Long::sum).orElse(0L).intValue();
    }

    /**
     * 消耗
     *
     * @param rid      玩家id
     * @param thingSet 物品集
     * @param event    事件
     * @return 变更物品集
     */
    public ThingSet cost(long rid, ThingSet thingSet, GameEvent event) {

        long allItemNums = ImmutableThingUtil.getAllItemNums(thingSet.asList());

        Asserts.isTrue(allItemNums > 0, ErrorCode.BAG_COST_ERROR.getValue(),
                () -> StrUtil.format("cost thingSet item number less than 0:{},event:{}",
                        GJsonUtils.toJson(thingSet.asList()), event.getRemark()));

        Map<ThingProcessor, ThingSet> grouping = groupingByProcessor(thingSet);
        Map<ThingProcessor, ThingSet> results = new HashMap<>(grouping.size());
        ThingSet.Builder builder = ThingSet.builder();

        synchronized (InternerPool.intern(PREFIX, rid)) {
            grouping.forEach((processor, set) -> {
                processor.requireValid(set);
                ThingSet result = processor.prepareCost(rid, set, event);
                results.put(processor, result);
                builder.addAll(result.asList());
            });

            results.forEach((processor, result) -> {
                processor.cost(rid, result, event);
                processor.afterExecuteCost(rid, result, event);
            });
            ThingSet update = builder.build();
            if (!update.asList().isEmpty()) {
                eventBus.post(ThingCostEvent.of(rid, update, event));
            }
            return update;
        }
    }

    public ThingSet cost(long rid, ImmutableThing thing, GameEvent gameEvent) {
        return cost(rid, ThingSet.builder().add(thing).build(), gameEvent);
    }

    public ThingSet cost(long rid, List<ImmutableThing> things, GameEvent gameEvent) {
        return cost(rid, ThingSet.of(things), gameEvent);
    }

    /**
     * 获得
     *
     * @param rid
     * @param thingSet   物品集合
     * @param event      事件来源
     * @param noticeType 通知类型
     * @return
     */
    private Rewards add(long rid, ThingSet thingSet, GameEvent event, NoticeType noticeType) {

        long allItemNums = ImmutableThingUtil.getAllItemNums(thingSet.asList());

        Asserts.isTrue(allItemNums > 0, ErrorCode.BAG_COST_ERROR.getValue(),
                () -> StrUtil.format("add thingSet item number less than 0:{},event:{}",
                        GJsonUtils.toJson(thingSet.asList()), event.getRemark()));

        Map<ThingProcessor, ThingSet> grouping = groupingByProcessor(thingSet);
        Map<ThingProcessor, ThingSet> results = new HashMap<>(grouping.size());

        Rewards.Builder builder = Rewards.builder();
        synchronized (InternerPool.intern(PREFIX, rid)) {
            grouping.forEach((processor, set) -> {
                ThingSet result = processor.prepareAdd(rid, set, event);
                results.put(processor, result);
            });

            results.forEach((processor, result) -> {
                Rewards rewards = processor.add(rid, result, event);
                builder.addRewards(rewards);
                processor.afterExecuteAdd(rid, rewards, event);
            });
            Rewards rewards = builder.build();
            if (!rewards.isEmpty()) {
                eventBus.post(ThingAddEvent.of(rid, rewards, event, noticeType));
            }
            return rewards;
        }
    }

    public Rewards add(long rid, List<ImmutableThing> rewards, GameEvent gameEvent, NoticeType noticeType) {
        return add(rid, ThingSet.of(rewards), gameEvent, noticeType);
    }

    public Rewards add(long rid, ImmutableThing reward, GameEvent gameEvent) {
        return add(rid, reward, gameEvent, NoticeType.NORMAL);
    }

    public Rewards add(long rid, ImmutableThing reward, GameEvent gameEvent, NoticeType noticeType) {
        return add(rid, ThingSet.builder().add(reward).build(), gameEvent, noticeType);
    }

    public Rewards add(long rid, List<ImmutableThing> rewards, GameEvent gameEvent) {
        return add(rid, ThingSet.of(rewards), gameEvent, NoticeType.NORMAL);
    }

    private ThingProcessor getProcessor(ImmutableThing values) {
        return getProcessor(values.getThingId());
    }

    private Map<ThingProcessor, ThingSet> groupingByProcessor(ThingSet goodsSet) {
        return goodsSet.asList().stream().collect(Collectors.groupingBy(this::getProcessor,
                Collectors.collectingAndThen(toList(), ThingSet::of)));
    }


    /**
     * 添加加成奖励
     * @param rewardList
     * @param baseRewardMap
     * @param bonusList
     */
    public static void addBonus(List<ImmutableThing> rewardList, Map<Integer, ImmutableThing> baseRewardMap, List<ThingBonus> bonusList) {
//        for (ThingBonus thingBonus : bonusList) {
//            ImmutableThing thing = baseRewardMap.get(thingBonus.getItem_type());
//            if (thing == null) {
//                continue;
//            }
//            rewardList.add(ImmutableThing.of(thing.getItem_type(),
//                    (long) (thing.getItem_num() * 1.0d * thingBonus.getBonus() / GameConstant.WAN)));
//        }
        addBonus(rewardList, baseRewardMap, bonusList, null);
    }

    /**
     * 添加加成奖励
     *
     * @param rewardList
     * @param baseRewardMap
     * @param bonusList
     */
    public static void addBonus(List<ImmutableThing> rewardList, Map<Integer, ImmutableThing> baseRewardMap,
                                List<ThingBonus> bonusList, PrivilegeEffectType effectType) {
        for (ThingBonus thingBonus : bonusList) {
            // 判断是不是目标加成效果
            if (StringUtils.isNotBlank(thingBonus.getEffect()) && Objects.nonNull(effectType)) {
                if (!effectType.name().equals(thingBonus.getEffect())) {
                    continue;
                }
            }
            ImmutableThing thing = baseRewardMap.get(thingBonus.getItem_type());
            if (thing == null) {
                continue;
            }
            rewardList.add(ImmutableThing.of(thing.getItem_type(),
                    (long) (thing.getItem_num() * 1.0d * thingBonus.getBonus() / GameConstant.WAN)));
        }
    }
    
    /**
     * 使用替代道具获取消耗结果
     * @param rid
     * @param oriCostList
     * @param subCostList
     * @return
     */
    public List<ImmutableThing> costWithSubstitute(long rid, List<ImmutableThing> oriCostList, List<ImmutableThing> subCostList) {
    	if(oriCostList.size() != 1) {
    		return oriCostList;
    	}
    	List<ImmutableThing> resultCosts = new ArrayList<>();
    	
    	ImmutableThing oriCost = oriCostList.get(0);
    	//玩家持有的数量
    	long hasCount = itemProcessor.getCount(rid, oriCost.getItem_type());
    	//需要补足的数量
    	long fixCount = oriCost.getItem_num() - hasCount;
    	//补充N份替代消耗
    	List<ImmutableThing> subCost = ImmutableThingUtil.multiplyThing(subCostList, fixCount);
    	resultCosts.addAll(subCost);
    	if(hasCount > 0) {
    		ImmutableThing costItem = ImmutableThing.of(oriCost.getItem_type(), hasCount);
    		resultCosts.add(costItem);
    	}
    	return resultCosts;
    }
}
