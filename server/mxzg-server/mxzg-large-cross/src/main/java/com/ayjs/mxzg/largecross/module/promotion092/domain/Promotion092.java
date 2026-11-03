package com.ayjs.mxzg.largecross.module.promotion092.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * @Author: CWJ
 * @Date: 2021/3/11
 **/
@Setter
@Getter
@Entity
@Table(name = "promotion_092", comment = "女神鲜花")
public class Promotion092 extends AbstractEntity {
    @Id
    @Column(name = "rid", comment = "玩家id")
    private long rid;

    @Column(name = "count", comment = "献花次数")
    private int count;

    @Column(name = "rank_time", comment = "上榜时间")
    private LocalDateTime rankTime = LocalDateTime.of(1970, 1, 1, 0, 0);

    @Column(name = "start_time", comment = "活动开启时间")
    private int startTime;

    @Column(name = "server_id", comment = "服务器")
    private int serverId;
}
