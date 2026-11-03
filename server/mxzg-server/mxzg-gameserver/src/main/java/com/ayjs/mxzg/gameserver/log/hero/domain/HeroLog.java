/**
 *
 */
package com.ayjs.mxzg.gameserver.log.hero.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.log.base.AbstractThingLog;

import lombok.Getter;
import lombok.Setter;

/**
 * @author YY
 *
 */
@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "hero_log", comment = "英雄日志")
@Setter
@Getter
public class HeroLog extends AbstractThingLog {
    @Column(name = "hero_id", comment = "英雄唯一ID")
    private long heroId;
    @Column(name = "type", comment = "英雄类型")
    private int type;
    @Column(name = "level", comment = "等级")
    private int level;
    @Column(name = "star", comment = "星级")
    private int star;
    @Column(name = "stage", comment = "阶数")
    private int stage;
}
