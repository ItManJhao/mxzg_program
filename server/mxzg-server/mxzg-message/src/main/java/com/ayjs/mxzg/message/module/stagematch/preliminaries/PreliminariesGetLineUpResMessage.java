package com.ayjs.mxzg.message.module.stagematch.preliminaries;

import com.ayjs.rpc.RemoteMessage;
import lombok.Value;


@Value(staticConstructor = "of")
public class PreliminariesGetLineUpResMessage implements RemoteMessage {

    private byte[] lineUpData;

}
