package com.ayjs.mxzg.message.module.crusadegroup;

import com.ayjs.mxzg.message.largecross.CrusadeGroupMessage;
import lombok.Builder;
import lombok.Getter;

import java.time.LocalDateTime;
import java.util.Set;

/**
 * 请求讨伐团信息
 */
@Getter
@Builder
public class CrusadeGroupResMessage implements CrusadeGroupMessage {

    private int stage;   //讨伐团阶段

    private int groupId;    // 讨伐团id

    private int groupMapId; // 讨伐团地图id

    private long head;   //团战id

    private Set<Long> commander;    //指挥官

    private LocalDateTime registrationStartTime;    //报名开启时间

    private LocalDateTime registrationEndTime;      //报名结束时间

    private LocalDateTime battleStartTime;      //战斗开始时间

    private LocalDateTime battleEndTime;        //战斗结束时间

    private int emblem;//团徽

    private String groupName = "";//名字

}
