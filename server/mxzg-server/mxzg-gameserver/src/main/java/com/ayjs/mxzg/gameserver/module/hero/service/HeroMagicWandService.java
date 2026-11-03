package com.ayjs.mxzg.gameserver.module.hero.service;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.config.excel.cache.*;
import com.ayjs.mxzg.config.excel.entity.CMagicWandAttr;
import com.ayjs.mxzg.config.excel.entity.CMagicWandRange;
import com.ayjs.mxzg.config.excel.entity.CMagicWandStrengthen;
import com.ayjs.mxzg.config.excel.entity.CMagicWandType;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.event.MagicWandCostEvent;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.hero.dao.HeroMagicWandDao;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroMagicWand;
import com.ayjs.mxzg.gameserver.module.hero.struct.MagicAttrData;
import com.ayjs.mxzg.protocol.HeroMagicWandGMsg.GResMagicWandBaginfo;
import com.ayjs.mxzg.protocol.HeroMagicWandGMsg.MagicWandAttr;
import com.ayjs.mxzg.protocol.HeroMagicWandGMsg.MagicWandData;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.google.common.collect.ImmutableList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

/**
 * @author Rondo
 * 2021-05-19 17:04:20
 */
@Service
public class HeroMagicWandService {

    @Autowired
    private HeroMagicWandDao heroMagicWandDao;
    @Autowired
    private MagicWandStrengthenSysCache magicWandStrengthenSysCache;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private ThingService thingService;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private MagicWandTypeSysCache magicWandTypeSysCache;
    @Autowired
    private MagicWandAttrSysCache magicWandAttrSysCache;
    @Autowired
    private MagicWandRangeSysCache magicWandRangeSysCache;
    @Autowired
    private EventBus eventBus;

    // 根据玩家id获取全部信息
    public List<HeroMagicWand> getAllMagicWands(long rid) {
        return heroMagicWandDao.list("rid", rid);
    }

    public HeroMagicWand getMagicWand(long rid, long magicWandId) {
        List<HeroMagicWand> magicWands = getAllMagicWands(rid);
        for (HeroMagicWand magicWand : magicWands) {
            if (magicWand.getId() == magicWandId) {
                return magicWand;
            }
        }
        return null;
    }

    public HeroMagicWand getMagicWandByHeroId(long rid, long heroId) {
        List<HeroMagicWand> magicWands = getAllMagicWands(rid);
        return magicWands.stream().filter(heroMagicWand -> heroMagicWand.getHeroId() == heroId).findFirst().orElse(null);
    }

    public void addHeroMagicWand(List<HeroMagicWand> list) {
        heroMagicWandDao.add(list);
    }

    public void update(List<HeroMagicWand> list) {
        heroMagicWandDao.update(list);
    }

    public void update(HeroMagicWand item) {
        heroMagicWandDao.update(item);
    }

    // 强化的时候尝试解锁新的随机属性
    public void tryToActiveRandomAttr(HeroMagicWand heroMagicWand) {
        Integer[] unlockLevelConfig = systemSysCache.getMagicWandStrengthenUnlockLevel();
        int strengthen = heroMagicWand.getStrengthen();
        int typeId = heroMagicWand.getTypeId();
        int random_attr_max = magicWandTypeSysCache.getById(typeId).getRandom_attr_max();

        // 根据当前的数据属性的条数来判断
        Map<Integer, MagicAttrData> random_attrs_map = heroMagicWand.getRandom_attrs();
        int random_attr_size = random_attrs_map.size();
        if (random_attr_max <= 1 || random_attr_size >= random_attr_max){
            return;
        }
        // 例如魔杖已经有两条属性，要激活第三条，那么就是system表里的第二个位置
        Integer active_need_level = unlockLevelConfig[random_attr_size - 1];
        if (strengthen >= active_need_level) {
            // 激活对应的随机属性
            MagicAttrData randomAttr = getRandomAttrAndValue(heroMagicWand.getRare());
            random_attrs_map.put(random_attr_size, randomAttr);
        }
    }

    // 根据品质随机出属性和数值 --> 强化解锁新属性的时候使用
    public MagicAttrData getRandomAttrAndValue(int rare) {
        // 先随机出属性类型
        AttributeType attrType = getRandomAttrType(rare);
        // 再随机出数值
        CMagicWandRange rangeConfig = magicWandRangeSysCache.getDataByAttrTypeAndRare(attrType.getValue(), rare);
        return new MagicAttrData(attrType, getNewRandomAttrVal(rangeConfig.getMin(), rangeConfig.getMax()));
    }

    public void setNewWashAttrTypeAndVal(HeroMagicWand heroMagicWand, boolean needReset) {
        Map<Integer, MagicAttrData> randomAttrs = heroMagicWand.getRandom_attrs();
        Map<Integer, MagicAttrData> washAttrs = heroMagicWand.getWash_attrs();
        int rare = heroMagicWand.getRare();
        if (washAttrs.isEmpty()) {
            for (MagicAttrData attrData : randomAttrs.values()) {
                Long oldValue = attrData.getValue();
                AttributeType oldAttributeType = attrData.getAttributeType();
                MagicAttrData rangeNewWashAttr = getRangeNewWashAttr(oldAttributeType, rare, oldValue);
                washAttrs.put(washAttrs.size(), rangeNewWashAttr);
            }
        } else {
            for (Map.Entry<Integer, MagicAttrData> itemAttr : washAttrs.entrySet()) {
                Long oldValue = itemAttr.getValue().getValue();
                AttributeType oldAttributeType = itemAttr.getValue().getAttributeType();
                MagicAttrData rangeNewWashAttr = getRangeNewWashAttr(oldAttributeType, rare, oldValue);
                washAttrs.put(itemAttr.getKey(), rangeNewWashAttr);
            }
            // 当洗练属性条数小于随机属性，重新添加
            supplementWashAttr(washAttrs, randomAttrs, rare);
        }
    }

    public void resetWashAttrVal(HeroMagicWand heroMagicWand) {
        Map<Integer, MagicAttrData> randomAttrs = heroMagicWand.getRandom_attrs();
        Map<Integer, MagicAttrData> washAttrs = heroMagicWand.getWash_attrs();
        int rare = heroMagicWand.getRare();
        for (Map.Entry<Integer, MagicAttrData> entry : washAttrs.entrySet()) {
            Long oldValue = entry.getValue().getValue();
            AttributeType oldAttributeType = entry.getValue().getAttributeType();
            CMagicWandRange rangeConfig = magicWandRangeSysCache.getDataByAttrTypeAndRare(oldAttributeType.getValue(), rare);
            // 超过最大值就随机更改属性
            int random_num = RandomUtil.rand(0, 100) + 1;
            if (oldValue >= rangeConfig.getMax() && random_num <= systemSysCache.getMagicWandBaptismResetProbability()) {
                oldAttributeType = getOtherMagicAttrData(oldAttributeType, rare).getAttributeType();
            }
            Long randomAttrValue = getRandomAttrValue(rangeConfig.getLow(), rangeConfig.getHigh());
            BigDecimal newAttrVal = new BigDecimal(oldValue).add(new BigDecimal(randomAttrValue));
            long resultVal = Math.min(rangeConfig.getMax(), newAttrVal.longValue());
            washAttrs.put(entry.getKey(), new MagicAttrData(oldAttributeType, resultVal));
        }
        // 当洗练属性条数小于随机属性，重新添加
        supplementWashAttr(washAttrs, randomAttrs, rare);
    }

    private void supplementWashAttr(Map<Integer, MagicAttrData> washAttrs, Map<Integer, MagicAttrData> randomAttrs, int rare) {
        while (washAttrs.size() < randomAttrs.size()) {
            MagicAttrData oldMagicData = randomAttrs.get(washAttrs.size());
            MagicAttrData newWashAttr = getOtherMagicAttrData(oldMagicData.getAttributeType(), rare);
            newWashAttr.setValue(new BigDecimal(oldMagicData.getValue()).add(new BigDecimal(newWashAttr.getValue())).longValue());
            washAttrs.put(washAttrs.size(), newWashAttr);
        }
    }

    private MagicAttrData getRangeNewWashAttr(AttributeType oldAttributeType, int rare, Long oldValue) {
        CMagicWandRange rangeConfig = magicWandRangeSysCache.getDataByAttrTypeAndRare(oldAttributeType.getValue(), rare);
        Long rangeValue = getRandomAttrValue(rangeConfig.getLow(), rangeConfig.getHigh());
        if (oldValue >= rangeConfig.getMax()) {
            oldAttributeType = getOtherMagicAttrData(oldAttributeType, rare).getAttributeType();
        }
        long resultVal = Math.min(rangeConfig.getMax(), new BigDecimal(oldValue).add(new BigDecimal(rangeValue)).longValue());
        return new MagicAttrData(oldAttributeType, resultVal);
    }

    // 随机出不同于当前的属性类型
    private MagicAttrData getOtherMagicAttrData(AttributeType attributeType, int rare) {
        AttributeType newAttrType = getRandomAttrType(rare);
        while(attributeType.getValue() == newAttrType.getValue()) { // 随机出不同于当前属性的属性值
            newAttrType = getRandomAttrType(rare);
        }
        CMagicWandRange rangeConfig = magicWandRangeSysCache.getDataByAttrTypeAndRare(newAttrType.getValue(), rare);
        Long randomAttrValue = getRandomAttrValue(rangeConfig.getLow(), rangeConfig.getHigh());
        return new MagicAttrData(newAttrType, randomAttrValue);
    }

    // 随机出属性类型
    public AttributeType getRandomAttrType(int rare) {
        List<CMagicWandAttr> attr_type_list = magicWandAttrSysCache.getDataByRare(rare);
        CMagicWandAttr randomAttr = DropUtil.randomDrop(attr_type_list);
        // 先随机出属性类型
        int attr_type = randomAttr.getAttr_type();
        return AttributeType.valueOf(attr_type);
    }

    // 新增属性获取新数值 --> 非波动值
    private Long getNewRandomAttrVal(int min, int max) {
        Asserts.isTrue(max >= min, "最大值不能比最小值小，请检查配置表");
        Random rand = new Random();
        int random_value = rand.nextInt(max - min + 1) + min;
        return (long)random_value;
    }

    // 根据配置表的最大增加值和最小增加值随机出 --> 增加值，波动值
    public Long getRandomAttrValue(int low, int high) {
        Asserts.isTrue(high >= low, "最大值不能比最小值小，请检查配置表");
        Random rand = new Random();
        int random_value = rand.nextInt(high - low + 1) + low;
        return (long)random_value;
    }




    // 验证类型
    public void cost(long rid, List<Long> ids, ImmutableList<ImmutableThing> typeIds, GameEvent gameEvent) {
        Map<Integer, Long> map = typeIds.asList().stream().collect(Collectors.toMap(ImmutableThing::getItem_type, ImmutableThing::getItem_num));
        for (Long id : ids) {
            int typeId = getMagicWand(rid, id).getTypeId();
            if (map.containsKey(typeId)) {
                Long value = map.get(typeId);
                if (--value <= 0) {
                    map.remove(typeId);
                } else {
                    map.put(typeId, value);
                }
            }
        }
        Asserts.isTrue(map.isEmpty(), ErrorCode.MAGIC_WAND_TYPE_ERROR.getDesc());
        cost(rid, ids, gameEvent);
    }

    // 验证数量
    public void prepareCost(long rid, List<Long> costIds) {
        // 验证是否可以删除
        for (Long costId : costIds) {
            HeroMagicWand magicWand = getMagicWand(rid, costId);
            Asserts.notNull(magicWand, ErrorCode.BAG_NOT_CONTAIN_THIS.getDesc());
            Asserts.isTrue(magicWand.getHeroId() == 0, ErrorCode.MAGIC_WAND_IS_WEARING.getDesc());
        }
    }

    /**
     * 此方法来代替thingService中消耗魔杖的cost接口
     * @param rid   玩家id
     * @param costIds   魔杖的唯一id数组，由于不可叠加，数量必定 = 1
     * @param gameEvent 事件
     */
    public void cost(long rid, List<Long> costIds, GameEvent gameEvent) {
        List<HeroMagicWand> updateMagicWands = new ArrayList<>();
        List<TempStruct> updateList = new ArrayList<>();
        prepareCost(rid, costIds);
        for (Long costId : costIds) {
            HeroMagicWand magicWand = getMagicWand(rid, costId);
            updateList.add(new TempStruct(magicWand.getTypeId(), magicWand.getStrengthen()));
            updateMagicWands.add(magicWand);
            heroMagicWandDao.remove(magicWand);
        }
        // 返回强化的材料
        returnStrengthenMaterial(rid, updateList);
        eventBus.post(MagicWandCostEvent.of(rid, updateMagicWands, gameEvent));
        // 通知背包
        sendUpdateBackPack(rid, updateMagicWands, 0);

    }

    // 返回强化洗练以及本身材料
    public void costAndReturn(long rid, List<Long> costIds, GameEvent gameEvent) {
        List<TempStruct> updateList = new ArrayList<>();
        List<HeroMagicWand> magicWands = new ArrayList<>();
        prepareCost(rid, costIds);
        for (Long costId : costIds) {
            HeroMagicWand magicWand = getMagicWand(rid, costId);
            updateList.add(new TempStruct(magicWand.getTypeId(), magicWand.getStrengthen()));
            magicWands.add(magicWand);
        }
        heroMagicWandDao.remove(magicWands);
        // 总材料返回
        List<ImmutableThing> allResult = new ArrayList<>();
        allResult.addAll(getStrengthMaterial(rid, updateList));
        allResult.addAll(getSelfMaterial(rid, updateList));
        allResult.addAll(getBaptismMaterial(rid, magicWands));
        thingService.add(rid, ImmutableThingUtil.mergeThing(allResult), gameEvent);
        eventBus.post(MagicWandCostEvent.of(rid, magicWands, gameEvent));
        // 通知背包
        sendUpdateBackPack(rid, magicWands, 0);

    }

    // 返回魔杖强化的材料
    private List<ImmutableThing> getStrengthMaterial(long rid, List<TempStruct> costMagics) {
        List<ImmutableThing> strengthList = new ArrayList<>();
        for (TempStruct magic : costMagics) {
            int strengthen = magic.getStrengthen();
            int typeId = magic.getTypeId();
            Map<Integer, CMagicWandStrengthen> typeData = magicWandStrengthenSysCache.getDataByType(typeId);
            for (Map.Entry<Integer, CMagicWandStrengthen> entry : typeData.entrySet()) {
                if (strengthen > entry.getKey()) {
                    strengthList.addAll(entry.getValue().getCost().asList());
                } else {
                    // map中的键是有序的，一旦超过对应等级就打破循环，效率
                    break;
                }
            }
        }
        return strengthList;
    }

    // 返回魔杖本身的材料
    private List<ImmutableThing> getSelfMaterial(long rid, List<TempStruct> costMagics) {
        List<ImmutableThing> selfList = new ArrayList<>();
        for (TempStruct magic : costMagics) {
            int strengthen = magic.getStrengthen();
            int typeId = magic.getTypeId();
            // 返回本身的材料
            CMagicWandType typeConfig = magicWandTypeSysCache.getById(typeId);
            selfList.addAll(typeConfig.getRecover_reward());
        }
        return selfList;
    }

    // 返回魔杖强化和本身的材料
    private void returnStrengthenMaterial(long rid, List<TempStruct> costMagics) {
        List<ImmutableThing> materialList = new ArrayList<>();
        // 返回每一个魔杖的强化材料
        materialList.addAll(getSelfMaterial(rid, costMagics));
        materialList.addAll(getStrengthMaterial(rid, costMagics));

        thingService.add(rid, ImmutableThingUtil.mergeThing(materialList), GameEvent.MAGIC_WAND_DECOMPOSE_RETURN);
    }

    // 返回魔杖强化材料
    public List<ImmutableThing> getBaptismMaterial(long rid, List<HeroMagicWand> delMagics) {
        List<ImmutableThing> rewards = new ArrayList<>();
        delMagics.forEach(heroMagicWand -> {
            int times = heroMagicWand.getWash_times();
            if (times <= 0) return;
            int typeId = heroMagicWand.getTypeId();
            // 每次洗练的消耗
            ImmutableList<ImmutableThing> cost = magicWandTypeSysCache.getById(typeId).getCost();
            if (cost.isEmpty()) return;
            // 总洗练的消耗
            List<ImmutableThing> things = ImmutableThingUtil.multiplyThing(cost, times);
            rewards.addAll(things);
        });
        return rewards;
    }


    /**
     *
     * @param rid 玩家id
     * @param addIds 要更新魔杖列表
     * @param sign 0删除，1增加
     * @param flag 标志位:在英雄身上的是否要发送给前端
     */
    public void sendUpdateBackPack(long rid, List<HeroMagicWand> addIds, int sign, boolean flag) {
        GResMagicWandBaginfo.Builder proto = GResMagicWandBaginfo.newBuilder();
        proto.addAllList(convert(addIds, flag));
        proto.setSign(sign);
        contextManager.write(rid, CmdCode._4608, proto.build());
    }

    public void sendUpdateBackPack(long rid, List<HeroMagicWand> addIds, int sign) {
        sendUpdateBackPack(rid, addIds, sign, true);
    }

    private List<MagicWandData> convert(List<HeroMagicWand> updateIds, boolean flag) {
        List<MagicWandData> magicWandDataList = new ArrayList<>();
        updateIds.forEach(heroMagicWand -> {
            if (heroMagicWand.getHeroId() != 0 && flag) return;     // 在英雄身上的不发给前端，另做处理
            MagicWandData.Builder itemInfo = convertItemInfo(heroMagicWand);
            magicWandDataList.add(itemInfo.build());
        });
        return magicWandDataList;
    }

    public List<MagicWandData> convert(List<HeroMagicWand> updateIds) {
        return convert(updateIds, true);
    }


    // 单个数据转化
    public MagicWandData.Builder convertItemInfo(HeroMagicWand heroMagicWand) {
        MagicWandData.Builder item = MagicWandData.newBuilder();
        if (heroMagicWand == null) return item;
        item.setMagicId(heroMagicWand.getId());
        item.setItemType(heroMagicWand.getTypeId());
        item.setMagicType(heroMagicWand.getType());
        item.setHeroId(heroMagicWand.getHeroId());
        item.setStrengthenLv(heroMagicWand.getStrengthen());
        item.addAllBaseAttrs(convertToPBList(heroMagicWand.getBase_attrs()));
        item.addAllRandomAttrs(convertToPBList(heroMagicWand.getRandom_attrs()));
        item.addAllWashAttrs(convertToPBList(heroMagicWand.getWash_attrs()));
        item.setMagicRare(heroMagicWand.getRare());
        item.setWashTimes(heroMagicWand.getWash_times());
        return item;
    }

    private List<MagicWandAttr> convertToPBList(Map<Integer, MagicAttrData> map) {
        List<MagicWandAttr> PbList = new ArrayList<>();
        if (map.isEmpty()) return PbList;
        for (MagicAttrData attrData : map.values()) {
            MagicWandAttr.Builder attrPB = MagicWandAttr.newBuilder();
            attrPB.setAttrId(attrData.getAttributeType().getValue());
            attrPB.setAttrValueOld(attrData.getValue());
            PbList.add(attrPB.build());
        }
        return PbList;
    }


    // 临时内部类
    static class TempStruct{
        int typeId;
        int strengthen;

        public int getTypeId() {
            return typeId;
        }

        public void setTypeId(int typeId) {
            this.typeId = typeId;
        }

        public int getStrengthen() {
            return strengthen;
        }

        public void setStrengthen(int strengthen) {
            this.strengthen = strengthen;
        }

        public TempStruct(int typeId, int strengthen) {
            this.typeId = typeId;
            this.strengthen = strengthen;
        }
    }
}
