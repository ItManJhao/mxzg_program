package com.ayjs.mxzg.gameserver.log.hero.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;

/**
 * @author Rondo
 */
@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "magic_wand_log", comment = "魔杖日志")
@Getter
@Setter
public class HeroMagicWandLog extends AbstractOperateLog {
    @Column(name = "magic_id", comment = "魔杖唯一id")
    private long magicId;
    @Column(name = "type", comment = "类型")
    private int type;
    @Column(name = "rare", comment = "品质")
    private int rare;
    @Column(name = "random_attr", comment = "随机属性")
    private String randomAttr;
    @Column(name = "base_attr", comment = "基础属性")
    private String baseAttr;
    @ShardingId
    @Column(name = "time", comment = "日志时间", readOnly = true)
    private int time;
    @Column(name = "event", comment = "流水事件")
    private int event;
    @Column(name = "event_desc", comment = "流水描述")
    private String eventDesc;
}
