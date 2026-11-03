package com.ayjs.mxzg.gameserver.module.role.event;

import lombok.Value;

import java.util.List;

@Value(staticConstructor = "of")
public class GMCommandEvent {
    /**
     * 玩家id
     */
    private long rid;
    /**
     * GM命名
     */
    private String command;
    /**
     * 参数
     */
    private List<String> params;
}
