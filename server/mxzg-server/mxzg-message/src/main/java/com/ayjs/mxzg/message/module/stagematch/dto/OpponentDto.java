package com.ayjs.mxzg.message.module.stagematch.dto;

import lombok.Getter;
import lombok.Setter;

/**
 * 对手信息
 */
@Getter
@Setter
public class OpponentDto {

    private long rid;       //角色id
    private int serverId;   //服务器id
    private String name;    //昵称
    private int rank;       //排名
    private int stageId;   //段位
    private int lastStageId;  //上一段位
    private int integral;   //积分
    private int eliteIntegral;  //精英积分
    private String battlerVo;  //战斗vo
    private int fighting;       //战斗力
    private int image_id;       //形象id

}
