package com.ayjs.mxzg.message.module.stagematch.gm;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;

/**
 * 清空对手列表
 */
public class CleanOpponentMessage implements LargeCrossMessage {

    public static CleanOpponentMessage getInstance(){
        return new CleanOpponentMessage();
    }

}
