package com.ayjs.mxzg.gameserver.module.planewar.event;

import lombok.Value;

/**
 * 通关事件，只在第一次通关时，才抛出
 *
 * @Author: CWJ
 * @Date: 2020/9/17
 **/
@Value(staticConstructor = "of")
public class PlaneWarPassEvent {
    private long rid;
    private int level;
    private int element;
}
