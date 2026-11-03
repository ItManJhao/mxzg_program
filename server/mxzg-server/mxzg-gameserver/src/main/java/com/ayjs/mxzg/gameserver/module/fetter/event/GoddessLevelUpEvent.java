package com.ayjs.mxzg.gameserver.module.fetter.event;

import lombok.Value;

/**
 * 女神升级事件
 *
 * @Author: CWJ
 * @Date: 2019/10/27
 **/
@Value(staticConstructor = "of")
public class GoddessLevelUpEvent {
    private long rid;
    //配置表id
    private int configId;
    //新的女神等级
    private int newLevel;
    //增加等级
    private int addLv;
}
