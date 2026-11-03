package com.ayjs.mxzg.gameserver.log.dungeon.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.Map;

/**
 * 庇护所战斗队伍保存日志
 * @author hyx
 */
@Getter
@Setter
@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "dungeon_hero_line_log", comment = "庇护所保存战斗队伍日志")
public class DungeonHeroLineLog extends AbstractOperateLog {

    @Column(name = "hero_ids",comment = "保存的英雄id集")
    private Map<Integer, Long> mapIds = new HashMap<>();

    @Column(name = "hero_types",comment = "保存的英雄类型")
    private  Map<Integer, Integer> mapTypes = new HashMap<>();

    @ShardingId
    @Column(name = "time", comment = "日志时间", readOnly = true)
    private int time;
}
