package com.ayjs.mxzg.gameserver.log.dungeon.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;


/**
 * 庇护所战斗日志
 * @author hyx
 */
@Getter
@Setter
@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "dungeon_log", comment = "庇护所战斗日志")
public class DungeonLog extends AbstractOperateLog {

    @Column(name = "stage",comment = "当前挑战层")
    private int stage;

    @Column(name = "monster_level",comment = "挑战的怪物标识")
    private int monsterLevel;

    @Column(name = "isWin",comment = "1为胜，0为负")
    private int isWin;

    @ShardingId
    @Column(name = "time", comment = "日志时间", readOnly = true)
    private int battle_time;
}
