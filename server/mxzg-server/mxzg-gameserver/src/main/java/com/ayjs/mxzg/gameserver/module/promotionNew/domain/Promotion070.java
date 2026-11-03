package com.ayjs.mxzg.gameserver.module.promotionNew.domain;


import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.MissionInfo;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Entity
@Table(name = "promotion070", comment = "梦境秘宝")
@Getter
@Setter
public class Promotion070 extends BaseLoopingPromotion {

    @Column(name = "select_info", comment = "奖励选择信息")
    private Map<Integer, List<Integer>> selectInfo = new HashMap();

    @Column(name = "mission_info_map", comment = "任务信息")
    private Map<Integer, MissionInfo> missionInfoMap = new HashMap<>();

    @Column(name = "mission_refresh", comment = "任务刷新日期")
    private LocalDate missionRefresh = getDefault();

    @Column(name = "count_reward", comment = "抽奖次数领奖记录")
    private List<Integer> countReward = new ArrayList<>();
    @Column(name = "open_count", comment = "抽奖次数")
    private int openCount;
    @Column(name = "open_record", comment = "开箱记录")
    private Map<Integer, Integer> openRecord = new HashMap<>();

    @Column(name = "login_record", comment = "登录次数判定时间")
    private LocalDate loginRecord = getDefault();

    @Column(name = "good_buy_count", comment = "商品购买次数")
    private int goodBuyCount;

    @Column(name = "mission_box_record", comment = "任务宝箱领奖记录")
    private List<Integer> missionBoxRecord = new ArrayList<>();


    public LocalDate getDefault() {
        return LocalDate.of(1920, 11, 2);
    }


}
