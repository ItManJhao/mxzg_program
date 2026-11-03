package com.ayjs.mxzg.message.module.stagematch.preliminaries;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import lombok.Value;


@Value(staticConstructor = "of")
public class PreliminariesLikeNumAddReqMessage implements LargeCrossMessage {

    private int rank;
}
