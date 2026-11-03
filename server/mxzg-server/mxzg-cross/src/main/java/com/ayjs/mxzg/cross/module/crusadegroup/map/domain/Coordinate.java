package com.ayjs.mxzg.cross.module.crusadegroup.map.domain;

import lombok.Value;

/**
 * 坐标信息
 */
@Value(staticConstructor = "valueOf")
public class Coordinate {

    private int x;
    private int y;
}
