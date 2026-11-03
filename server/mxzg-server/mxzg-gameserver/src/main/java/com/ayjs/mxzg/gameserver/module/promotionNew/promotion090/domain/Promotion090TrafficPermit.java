package com.ayjs.mxzg.gameserver.module.promotionNew.promotion090.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.BaseLoopingPromotion;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.TrafficPermitTaskProgress;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Getter
@Setter
@Entity
@Table(name = "promotion090_traffic_permit", comment = "通信证2")
public class Promotion090TrafficPermit extends BaseLoopingPromotion {

    @Column(name = "buy_privilege", comment = "是否购买特权,0为未购买，1为已购买")
    private int buyPrivilege;

    @Column(name = "remind_status", comment = "活动弹窗状态，1为已提示。0为未提示", defaultValue = "0")
    private int remind;

    @Column(name = "level", comment = "战令等级")
    private int level;

    @Column(name = "exp", comment = "经验值")
    private int exp;

    @Column(name = "reset_time", comment = "上一次重制时间")
    private int resetTime;

    @Column(name = "day_turns", comment = "当前每日任务轮次")
    private int dayTurns;

    @Column(name = "week_turns", comment = "当前每周任务轮次")
    private int weekTurns;

    @Column(name = "day_task", comment = "每日任务")
    private Map<Integer, TrafficPermitTaskProgress> dayTask = new HashMap<>();

    @Column(name = "week_task", comment = "每周任务")
    private Map<Integer, TrafficPermitTaskProgress> weekTask = new HashMap<>();

    @Column(name = "ultimate_task", comment = "终极任务")
    private Map<Integer, TrafficPermitTaskProgress> ultimateTask = new HashMap<>();

    @Column(name = "finish_reward", comment = "已领取的等级普通奖励")
    private List<Integer> finishList = new ArrayList<>();

    @Column(name = "privilege_reward", comment = "已领取的等级特权奖励")
    private List<Integer> privilegeList = new ArrayList<>();

    @Column(name = "login_record", comment = "登录记录")
    private LocalDate loginRecord = LocalDate.of(2021, 1, 11);
}
