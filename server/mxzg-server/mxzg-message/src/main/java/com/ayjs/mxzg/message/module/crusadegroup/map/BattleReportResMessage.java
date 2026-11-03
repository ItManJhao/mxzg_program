package com.ayjs.mxzg.message.module.crusadegroup.map;

import com.ayjs.mxzg.message.largecross.CrusadeGroupMessage;
import lombok.Value;

/**
 * 战报返回
 */
@Value(staticConstructor = "valueOf")
public class BattleReportResMessage implements CrusadeGroupMessage {

    private byte[] report;    //战报

}
