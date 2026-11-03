package com.ayjs.mxzg.config.excel.constant;

import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;
import com.ayjs.mxzg.common.excel.ExcelDictionaryField;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.google.common.collect.ImmutableList;
import org.springframework.stereotype.Component;

import java.util.Map;

@Component
public class DreamLandConst extends ExcelDictionaryCache {

    /**
     * 每场战斗的间隔
     */
    @ExcelDictionaryField("infinite_battle_frequency")
    public static int BATTLE_FREQUENCY = 0;//120;
    /**
     * 自动选择增益buff的等待时间
     */
    @ExcelDictionaryField("infinite_buff_auto_time")
    public static int BUFF_AUTO_TIME = 0;//120;
    /**
     * 每日按照最大记录倒退层数作为起始关卡
     */
    @ExcelDictionaryField("infinite_reset_level")
    public static int RESET_LEVEL = 0;//10;
    /**
     * 永恒梦境，每日前多少关拿正常奖励stardard_reward，在此后续就拿after_reward
     */
    @ExcelDictionaryField("infinite_standard_reward_max")
    public static int STANDARD_REWARD_MAX = 0;//5;
    /**
     * 每多少关出现一次选buff效果
     */
    @ExcelDictionaryField("infinite_buff_each_level")
    public static int BUFF_EACH_LEVEL = 0;//5;
    /**
     * 申请好友助战，限制为己方最高战力英雄的战力万分比
     */
    @ExcelDictionaryField("infinite_help_battle_limit")
    public static int HELP_BATTLE_LIMIT = 0;//12000;
    /**
     * 派出助战的奖励
     */
    public static ImmutableList<ImmutableThing> HELP_REWARD;

    public static String LANGUAGE = 5755 + "";

    @Override
    public void loadSpecialDictionary(Map<String, ? extends IDictionaryStruct> map) {
        HELP_REWARD = ImmutableThingUtil.fromJson(map.get("infinite_help_reward").getValue());
    }
}
