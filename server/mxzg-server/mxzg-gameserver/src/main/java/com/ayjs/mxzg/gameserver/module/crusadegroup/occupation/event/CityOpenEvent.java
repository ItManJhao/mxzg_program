package com.ayjs.mxzg.gameserver.module.crusadegroup.occupation.event;

import lombok.Value;

/**
 * 开垦领土(开垦[1]座[2]级以上的城邦，抛出此事件都要去获取当前玩家已经开垦的土地计算条件、数量)
 */
@Value(staticConstructor = "of")
public class CityOpenEvent {

    private long rid;//玩家id

    private int buildingLevel;//建筑等级 crusadegroupbuild表的 building_level

    private int cityNum;//开垦个数
}
