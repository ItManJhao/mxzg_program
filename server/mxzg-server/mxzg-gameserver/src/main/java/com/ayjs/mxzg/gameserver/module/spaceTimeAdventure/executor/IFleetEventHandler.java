package com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.executor;

import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.constant.FleetEventType;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.domain.SpaceTimeInfo;

/**
 * 航行事件执行处理器
 * @author hyx
 */
public interface IFleetEventHandler {

    /**
     * 事件类型
     * @return
     */
    FleetEventType thisType();

    /**
     * 执行事件
     * @param spaceTimeInfo
     * @param condition
     */
    void executor(SpaceTimeInfo spaceTimeInfo,int condition);

}
