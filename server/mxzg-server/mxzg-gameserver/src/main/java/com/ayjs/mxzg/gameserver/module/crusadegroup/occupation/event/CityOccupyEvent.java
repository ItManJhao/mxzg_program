package com.ayjs.mxzg.gameserver.module.crusadegroup.occupation.event;

import lombok.Value;

/**
 * 占领领土（占领[1]个[2]级以上的城邦）
 */
@Value(staticConstructor = "of")
public class CityOccupyEvent {

    private long rid;//玩家id

    private int areaLevel;//地皮等级 crusadegroupbuild表的 area_level

    private int buildingLevel;//建筑等级  crusadegroupbuild表的 building_level

    private int cityNum;//占领个数
}
