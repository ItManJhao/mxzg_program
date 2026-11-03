package com.ayjs.mxzg.gameserver.module.dungeon.domain;

import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.gameserver.module.dungeon.struct.DungeonEarnings;
import com.ayjs.mxzg.gameserver.module.dungeon.struct.DungeonShopItem;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * dungeon_info
 */
@Entity
@Table(name = "dungeon_info", comment = "庇护所个人信息")
@Getter
@Setter
public class DungeonInfo extends AbstractEntity {

    @Id
    @Column(name = "rid")
    private long rid;

    @Column(name = "stage", comment = "已通关庇护所层数，用于制作排行榜")
    private int stage;

    @Column(name = "rank_time", comment = "排行榜时间")
    private int rankTime;

    @Column(name = "now_stage", comment = "当前挑战塔层")
    private int nowStage;

    /***
     * {@link com.ayjs.mxzg.gameserver.module.dungeon.constant.DungeonEnum}
     */
    @Column(name = "grid_type", comment = "网格类型1 与网格类型2组成网格表现形式")
    private int gridType;

    @Column(name = "time", comment = "进入当前层的时间。用于制作排行榜")
    private int time;

    @Column(name = "win_times", comment = "庇护所怪物击杀数量")
    private int winTimes;

    @Column(name = "shop_list", comment = "庇护所商品集")
    private List<DungeonShopItem> shopItemList = new ArrayList<>();

    @Column(name = "earnings_list", comment = "当前层庇护所收益")
    private List<DungeonEarnings> earningsList = new ArrayList<>();

    @Column(name = "kill_reward", comment = "击杀奖励领取情况")
    private Map<Integer, Integer> killReward = new HashMap<>();

    @Column(name = "buff", comment = "庇护所BUFF列表 <buff类型，buff效果>")
    private Map<AttributeType, Long> buff = new HashMap<>();

    @Column(name = "battle_message", comment = "庇护所战斗队伍,英雄位置为key")
    private Map<Integer, BattlerVo> battleMap = new HashMap<>();

    @Column(name = "battle_fighting",comment = "庇护所英雄对应战力")
    private Map<Integer, Integer> fightingMap = new HashMap<>();

    @Column(name = "event_count",comment = "事件未出现次数")
    private Map<Integer,Integer> eventMap = new HashMap<>();
}
