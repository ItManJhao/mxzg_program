package com.ayjs.mxzg.gameserver.module.operatorValue.event;

import com.ayjs.mxzg.gameserver.module.operatorValue.constant.OperatorType;
import lombok.Value;

/**
 * 七天目标计数值改变
 *
 * @Author: CWJ
 * @Date: 2019/11/7
 **/
@Value(staticConstructor = "of")
public class SevenDayTargetValueEvent {

    private long rid;
    private OperatorType operatorType;
    private int newValue;
    private int addValue;
}
