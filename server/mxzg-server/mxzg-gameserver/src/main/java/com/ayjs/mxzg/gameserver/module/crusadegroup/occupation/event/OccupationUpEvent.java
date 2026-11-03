package com.ayjs.mxzg.gameserver.module.crusadegroup.occupation.event;

import lombok.Value;

/**
 * 職級進階
 */
@Value(staticConstructor = "valueOf")
public class OccupationUpEvent {

    long rid;
    /**
     * 爵位id,职级
     */
    int knighthoodId;

}
