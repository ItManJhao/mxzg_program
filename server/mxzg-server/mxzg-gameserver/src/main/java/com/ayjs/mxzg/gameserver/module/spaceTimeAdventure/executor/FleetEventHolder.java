package com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.executor;

import com.ayjs.mxzg.common.holder.AbstractHolder;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.constant.FleetEventType;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.domain.SpaceTimeInfo;
import org.springframework.stereotype.Component;


@Component
public class FleetEventHolder extends AbstractHolder<FleetEventType, IFleetEventHandler> {

    @Override
    protected FleetEventType convert(IFleetEventHandler bean) {
        return bean.thisType();
    }

    /**
     * 获取事件处理器
     *
     * @param type
     * @return
     */
    public IFleetEventHandler getHandler(FleetEventType type) {
        return super.getOrThrow(type);
    }

    /**
     * 执行事件
     *
     * @param spaceTimeInfo
     * @param condition
     */
    public void eventExecutor(FleetEventType type, SpaceTimeInfo spaceTimeInfo, int condition) {
        getHandler(type).executor(spaceTimeInfo, condition);
    }

}
