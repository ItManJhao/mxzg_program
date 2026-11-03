package com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.event;

import lombok.Value;

/**
 * 探索事件
 * @author hyx
 */
@Value(staticConstructor = "of")
public class SailingExploreEvent  {

    private long rid;

    private int routeId;

    private int eventId;

}
