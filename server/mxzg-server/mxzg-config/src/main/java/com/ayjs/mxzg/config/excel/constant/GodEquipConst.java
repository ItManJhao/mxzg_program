package com.ayjs.mxzg.config.excel.constant;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;
import com.ayjs.mxzg.common.excel.ExcelDictionaryField;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.google.common.collect.ImmutableList;

/**
 * 神装
 *
 * @author hyx
 */
@Component
public class GodEquipConst extends ExcelDictionaryCache {

    /***
     * 神装探宝保底必出
     */
    @ExcelDictionaryField("god_equipment_lottery_guarantee")
    public static int godEquipmentLotteryGuarantee = 30;//120;

    /**
     * 神装探宝个人记录最大数量
     */
    @ExcelDictionaryField("god_equipment_lottery_record_person")
    public static int godEquipmentLotteryRecordPerson = 20;//120;

    /**
     * 神装探宝全服记录最大数量
     */
    @ExcelDictionaryField("god_equipment_lottery_record_sever")
    public static int godEquipmentLotteryRecordSever = 30;//120;

    /***
     * 单次探宝道具消耗
     */
    public static ImmutableList<ImmutableThing> godEquipmentLotteryOneItem;

    /***
     * 单次探宝钻石消耗
     */
    public static ImmutableList<ImmutableThing> godEquipmentLotteryOneGem;

    /***
     * 10次探宝道具消耗
     */
    public static ImmutableList<ImmutableThing> godEquipmentLotteryTenItem;
    /***
     * 10探宝钻石消耗
     */
    public static ImmutableList<ImmutableThing> godEquipmentLotteryTenGem;

    /**
     * 获取锁属性时的消耗
     */
    public static Map<Integer, List<ImmutableThing>> lockCost = new HashMap<>();
    /**
     * 神装系统开启个人等级条件（与世界等级开启条件关系为“并且”）
     */
    @ExcelDictionaryField("god_equipment_main_level")
    public static int MAIN_LEVEL = 50;
    /**
     * 神装系统开启世界等级条件（与个人等级开启条件关系为“并且”）
     */
    @ExcelDictionaryField("god_equipment_world_level")
    public static int WORLD_LEVEL = 50;
    /**
     * 神装系统英雄开启星级（需要功能开启后才判断英雄星级）
     */
    @ExcelDictionaryField("god_equipment_hero_star")
    public static int HERO_STAR = 6;
    
    @Override
    public void loadSpecialDictionary(Map<String, ? extends IDictionaryStruct> map) {
        godEquipmentLotteryOneItem = ImmutableThingUtil.fromJson(map.get("god_equipment_lottery_one_item").getValue());
        godEquipmentLotteryOneGem = ImmutableThingUtil.fromJson(map.get("god_equipment_lottery_one_gem").getValue());
        godEquipmentLotteryTenItem = ImmutableThingUtil.fromJson(map.get("god_equipment_lottery_ten_item").getValue());
        godEquipmentLotteryTenGem = ImmutableThingUtil.fromJson(map.get("god_equipment_lottery_ten_gem").getValue());

        /*ImmutableList<ImmutableThing> godEquipmentWashLockOneCost = ImmutableThingUtil.fromJson(map.get("god_equipment_wash_lock_one_cost").getValue());
        ImmutableList<ImmutableThing> godEquipmentWashLockTWOCost = ImmutableThingUtil.fromJson(map.get("god_equipment_wash_lock_two_cost").getValue());*/
        lockCost.put(1, ImmutableThingUtil.fromJson(map.get("god_equipment_wash_lock_one_cost").getValue()));
        lockCost.put(2, ImmutableThingUtil.fromJson(map.get("god_equipment_wash_lock_two_cost").getValue()));
    }


}
