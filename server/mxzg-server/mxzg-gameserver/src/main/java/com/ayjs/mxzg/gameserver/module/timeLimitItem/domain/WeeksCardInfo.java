package com.ayjs.mxzg.gameserver.module.timeLimitItem.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

/**
 * 周卡
 *
 * @author hyx
 */
@Getter
@Setter
@Table(name = "weeks_card_info", comment = "玩家周卡数据", indexes = { @Index(name = "rid", columnList = { "rid" }) }, cache = {
        @Cache(columns = "rid") })
public class WeeksCardInfo extends AbstractEntity {

    @Id
    @LongIdGenerate
    @Column(name = "id")
    private long id;
    @Column(name = "rid", comment = "角色ID", readOnly = true)
    private long rid;
    @Column(name = "item_type", comment = "激活的周卡道具id")
    private int itemType;
    @Column(name = "active_time", comment = "激活时间")
    private int activeTime;
    @Column(name = "end_time", comment = "过期时间")
    private int endTime;
    @Column(name = "daily_time", comment = "上一次奖励发送时间")
    private int dailyTime;
    @Column(name = "reward_count", comment = "奖励发送次数")
    private int rewardCount;
}
