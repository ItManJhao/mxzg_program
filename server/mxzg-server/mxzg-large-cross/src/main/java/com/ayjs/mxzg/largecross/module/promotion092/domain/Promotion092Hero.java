package com.ayjs.mxzg.largecross.module.promotion092.domain;

/**
 * @Author: CWJ
 * @Date: 2021/3/12
 **/

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
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
@Table(name = "promotion_092_hero", comment = "女神鲜花英雄数据", indexes = {@Index(name = "start_time", columnList = {"start_time"})},
        cache = {@Cache(columns = "start_time")})
public class Promotion092Hero extends AbstractEntity {
    @Id
    @LongIdGenerate(incrementDigit = 6)
    @Column(name = "id", comment = "标识")
    private long id;

    @Column(name = "start_time", comment = "活动开启时间", readOnly = true)
    private int startTime;

    @Column(name = "hero_type", comment = "英雄类型")
    private int heroType;

    @Column(name = "count", comment = "英雄积分")
    private int score;

    @Column(name = "rank_time", comment = "上榜时间")
    private LocalDateTime rankTime = LocalDateTime.of(1970, 1, 1, 0, 0);

    @Column(name = "server_id", comment = "服务器")
    private int serverId;
}
