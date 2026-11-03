package com.ayjs.mxzg.gameserver.module.promotionNew.promotion081.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.BaseLoopingPromotion;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.MissionInfo;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2020/9/22
 **/
@Entity
@Table(name = "promotion081", comment = "黑五活动，任务")
@Getter
@Setter
public class Promotion081 extends BaseLoopingPromotion {

    @Column(name = "mission_info_map", comment = "任务信息")
    private Map<Integer, MissionInfo> missionInfoMap = new HashMap<>();
    @Column(name = "mission_box_record", comment = "任务宝箱领奖记录")
    private List<Integer> missionBoxRecord = new ArrayList<>();
    @Column(name = "login_record", comment = "登录记录")
    private LocalDate loginRecord = getDefault();
    @Column(name = "buy_record", comment = "礼包购买记录")
    private Map<Integer, Integer> buyRecord = new HashMap<>();
    @Column(name = "mission_reward_count", comment = "领取数量")
    private int missionRewardCount;

    private LocalDate getDefault() {
        return LocalDate.of(2000, 1, 1);
    }
}
