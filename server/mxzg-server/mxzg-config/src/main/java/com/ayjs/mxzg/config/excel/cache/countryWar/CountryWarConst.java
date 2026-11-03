package com.ayjs.mxzg.config.excel.cache.countryWar;

import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import lombok.Getter;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2021/4/21
 **/
@Component
public class CountryWarConst extends ExcelDictionaryCache {

    @Getter
    private int offlineDay = 3;
    @Getter
    private int minLv = 80;

    @Getter
    private int moveAddInterval = 300;
    @Getter
    private int attackAddInterval = 300;
    @Getter
    private List<ImmutableThing> lotteryCost;
    @Getter
    private int cityRewardMaxCount;
    @Getter
    private int logMaxNum;
    @Getter
    private int attackItemMax;
    @Getter
    private int moveItemMax;
    @Getter
    private int attackItemInit;
    @Getter
    private int moveItemInit;
    @Getter
    private List<ImmutableThing> attackSuccReward;
    @Getter
    private List<ImmutableThing> attackFailReward;
    @Getter
    private List<ImmutableThing> matchFailReward;
    @Getter
    private int openDays;

    @Override
    protected void loadSpecialDictionary(Map<String, ? extends IDictionaryStruct> map) {
        //战力计算最大离线天数
        offlineDay = Integer.valueOf(map.get("country_war_offline_day").getValue());
        //战力计算最低等级
        minLv = Integer.valueOf(map.get("country_war_min_lv").getValue());
        //城池奖励最大领取次数
        cityRewardMaxCount = Integer.valueOf(map.get("country_war_city_reward_max_count").getValue());
        //日志条数
        logMaxNum = Integer.valueOf(map.get("country_war_log_max_num").getValue());
        //攻击令增加间隔
        moveAddInterval = Integer.valueOf(map.get("country_war_move_add_interval").getValue());
        //迁移令增加间隔
        moveAddInterval = Integer.valueOf(map.get("country_war_attack_add_interval").getValue());
        //抽奖消耗
        lotteryCost = ImmutableThingUtil.fromJson(map.get("country_war_lottery_cost").getValue());
        //最大攻击令数
        attackItemMax = Integer.valueOf(map.get("country_war_attack_item_max").getValue());
        //最大迁移令数
        moveItemMax = Integer.valueOf(map.get("country_war_move_item_max").getValue());
        //赛季开始赠送攻击令数
        attackItemInit = Integer.valueOf(map.get("country_war_attack_item_init").getValue());
        //赛季开始赠送迁移令数
        moveItemInit = Integer.valueOf(map.get("country_war_move_item_init").getValue());

        //攻城胜利奖励
        attackSuccReward = ImmutableThingUtil.fromJson(map.get("country_war_attack_succ_reward").getValue());
        //攻城失败奖励
        attackFailReward = ImmutableThingUtil.fromJson(map.get("country_war_attack_fail_reward").getValue());
        //匹配失败奖励
        matchFailReward = ImmutableThingUtil.fromJson(map.get("country_war_match_fail_reward").getValue());
        //开服天数
        openDays = Integer.valueOf(map.get("country_war_open_day").getValue());

    }
}
