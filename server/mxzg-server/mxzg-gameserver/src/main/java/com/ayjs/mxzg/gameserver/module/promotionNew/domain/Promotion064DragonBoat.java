package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.dragon.domain.Dragon;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.DragonBoatGridInfo;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 龙舟活动
 *
 * @author hyx
 */
@Entity
@Table(name = "promotion064_dragon_boat", comment = "龙舟活动")
@Getter
@Setter
public class Promotion064DragonBoat extends BaseLoopingPromotion {

    @Column(name = "daily_time", comment = "重制时间")
    private int dailyTime;

    @Column(name = "task_list", comment = "任务列表,<idx,progress>")
    private Map<Integer, Long> taskList = new HashMap<>();

    @Column(name = "task_rewards", comment = "已领取的任务奖励")
    private List<Integer> taskRewards = new ArrayList<>();

    @Column(name = "box_rewards", comment = "已领取的宝箱奖励")
    private List<Integer> boxRewards = new ArrayList<>();

    @Column(name = "card_turns", comment = "当前翻牌轮次")
    private int cardTurns;

    @Column(name = "num", comment = "当前轮翻牌次数，用于检测目标奖励触发")
    private int num;

    @Column(name = "target_idx", comment = "选择的目标奖励")
    private int targetIdx;

    @Column(name = "target_status", comment = "目标奖励是否已获得")
    private int targetStatus;

    @Column(name = "grids", comment = "翻牌界面网格数据,<网格位置，奖励配置idx>")
    private Map<Integer, Integer> grids = new HashMap<>();

    @Column(name = "card_num", comment = "当前轮奖励出现次数")
    private Map<Integer, Integer> cardNum = new HashMap<>();

    @Column(name = "buy_list", comment = "商品购买列表")
    private Map<Integer, Integer> buyList = new HashMap<>();

}
