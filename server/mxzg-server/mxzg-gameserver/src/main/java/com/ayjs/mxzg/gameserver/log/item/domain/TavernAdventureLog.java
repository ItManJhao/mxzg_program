package com.ayjs.mxzg.gameserver.log.item.domain;

import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.log.base.AbstractThingLog;

/**
 * 酒馆冒险点数日志
 * @author hyx
 */
@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "tavern_adventure_log", comment = "酒馆冒险点数日志")
public class TavernAdventureLog extends AbstractThingLog {
}
