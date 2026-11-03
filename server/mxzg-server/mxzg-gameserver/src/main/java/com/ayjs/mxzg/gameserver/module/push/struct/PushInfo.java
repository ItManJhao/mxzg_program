package com.ayjs.mxzg.gameserver.module.push.struct;

import lombok.Getter;
import lombok.Setter;

import java.util.Map;
import java.util.Set;

/**
 * 推送的消息
 */
@Getter
@Setter
public class PushInfo {

    /**
     * 目标tokens key:rid  value:token
     */
    public Map<Long,String> tokens;
    /**
     * 标题
     */
    public String title;
    /**
     * 内容
     */
    public String content;
    /**
     * 触发时间
     */
    public int exeTime;
    /**
     * 重发次数
     */
    public int tryCnt;
    /**
     * 客户端类型：1，安卓,2，IOS
     */
    public int platform;
}
