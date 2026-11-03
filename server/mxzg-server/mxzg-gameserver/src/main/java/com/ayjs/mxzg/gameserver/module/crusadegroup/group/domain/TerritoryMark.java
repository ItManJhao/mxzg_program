package com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain;

import lombok.Getter;
import lombok.Value;

@Getter
@Value(staticConstructor = "valueOf")
public class TerritoryMark {

    private int territoryId;

    private String name;
}
