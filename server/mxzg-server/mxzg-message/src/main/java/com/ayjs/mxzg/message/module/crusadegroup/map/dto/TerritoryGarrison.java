package com.ayjs.mxzg.message.module.crusadegroup.map.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

/**
 * 领地驻军信息
 */
@Getter
@Setter
public class TerritoryGarrison {

    // 部队id
    private int id;

    // 驻军列表
    private List<Garrison> garrisons = new ArrayList<>();

    // 战力
    private int fighting;

    // 是否是boss
    private boolean boss;
}
