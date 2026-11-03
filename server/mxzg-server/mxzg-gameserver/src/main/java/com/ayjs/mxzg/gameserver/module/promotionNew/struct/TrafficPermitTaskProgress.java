package com.ayjs.mxzg.gameserver.module.promotionNew.struct;

import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.Map;

/**
 * 通行证任务
 * @author hyx
 *
 */
@Getter
@Setter
public class TrafficPermitTaskProgress {

    private int status = 0;//任务奖励领取状态 1为已领取

    private int progress = 0;//任务进度

}
