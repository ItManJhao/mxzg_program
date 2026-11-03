package com.ayjs.mxzg.config.excel.constant;

import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;
import com.ayjs.mxzg.common.excel.ExcelDictionaryField;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.google.common.collect.ImmutableList;
import org.springframework.stereotype.Component;

import java.util.Map;

@Component
public class PinnacleConst extends ExcelDictionaryCache {

    /**
     * 点赞奖励
     */
    public static ImmutableList<ImmutableThing> PINNACLE_LIKE_REWARD;
    /**
     * 发弹幕消耗
     */
    public static ImmutableList<ImmutableThing> BIU_COST;
    /**
     * 跨服淘汰赛小组数
     */
    public static final int CROSS_GROUP_COUNT = 16;
    /**
     * 每个小组多少人
     */
    public static final int GROUP_SIZE = 8;
    /**
     * 跨服选拔赛入选人数
     */
    public static final int TRIALS_CROSS_PLAYER = 128;
    /**
     * 冠军赛竞猜币赔率参数
     */
    public static float[] GUESS_COUNT_FACTER = new float[] {1.5f, 0.5f, 1.0f, 100.0f, 100.0f, 1.50f, 2.00f, 3.5f};
    /**
     * 冠军赛竞猜最大投注额
     */
    @ExcelDictionaryField("topmatch_max_guess")
    public static int MAX_GUESS	= 1000;
    /**
     * 巅峰赛每天点赞次数上限
     */
    @ExcelDictionaryField("topmatch_max_like")
    public static int PINNACLE_MAX_LIKE = 3;
    /**
     * 跨服冠军赛在结束的时候，竞猜币兑换的道具类型
     */
    @ExcelDictionaryField("topmatch_guess_reward_type")
    public static int PINNACLE_GUESS_REWARD_TYPE = 901901;
    /**
     * 跨服冠军赛兑换道具的比率（万分比）
     */
    @ExcelDictionaryField("topmatch_guess_reward_rate")
    public static int PINNACLE_GUESS_REWARD_RATE = 10000;

    @Override
    protected void loadSpecialDictionary(Map<String, ? extends IDictionaryStruct> map) {
        PINNACLE_LIKE_REWARD = ImmutableThingUtil.fromJson(map.get("topmatch_like_reward").getValue());
        BIU_COST = ImmutableThingUtil.fromJson(map.get("topmatch_barrage_cost").getValue());
    }

}
