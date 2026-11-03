package com.ayjs.mxzg.gameserver.module.fetter.event;

import lombok.Value;

/**
 *
 * 女神升级操作
 * @Author: CWJ
 * @Date: 2019/12/26
 **/
@Value(staticConstructor = "of")
public class GoddessLevelUpOperatorEvent {

    private long rid;

    /**女神类型*/
    private int configId;

}
