package com.ayjs.mxzg.message.module.stagematch;

import com.ayjs.mxzg.message.cross.RemoteServerMessage;
import com.ayjs.rpc.RemoteMessage;
import com.ayjs.rpc.annotation.RemoteMethod;
import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2020/7/9
 **/
@Value(staticConstructor = "of")
public class SeasonDetailResMessage implements RemoteMessage {

    private byte[] data;

}
