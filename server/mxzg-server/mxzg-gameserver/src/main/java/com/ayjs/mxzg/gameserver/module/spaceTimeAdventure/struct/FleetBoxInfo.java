package com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.struct;

import lombok.Getter;
import lombok.Setter;
import lombok.Value;

/**
 * 时空冒险物资箱
 * @author hyx
 */
@Getter
@Setter
@Value(staticConstructor = "of")
public class FleetBoxInfo {

    private int boxId;

    /**
     * 获得时间
     */
    private int time;



}
