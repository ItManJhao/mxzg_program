package com.ayjs.mxzg.cross.module.crossservice.event;

import lombok.Value;

import java.util.List;

/**
 * 游戏服连上跨服事件
 */
@Value(staticConstructor = "of")
public class Game2CrossConnectedEvent {

    /**
     * 分服服务器id
     */
    List<Integer> serverIds;
    /**
     * 分服ip
     */
    String host;
}
