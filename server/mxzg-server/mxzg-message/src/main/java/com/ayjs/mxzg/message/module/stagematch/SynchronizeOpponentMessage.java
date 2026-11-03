package com.ayjs.mxzg.message.module.stagematch;

import com.ayjs.mxzg.message.cross.RemoteServerMessage;
import com.ayjs.mxzg.message.module.stagematch.dto.OpponentDto;
import lombok.Getter;
import lombok.Setter;

/**
 * 同步信息
 */
@Getter
@Setter
public class SynchronizeOpponentMessage implements RemoteServerMessage {
    /**
     * 赛季
     */
    private int serverId;

    /**
     * 同步基础信息
     */
    private OpponentDto opponentDto;

    public static SynchronizeOpponentMessage createOf(OpponentDto opponentDto){
        SynchronizeOpponentMessage message = new SynchronizeOpponentMessage();
        message.setServerId(opponentDto.getServerId());
        message.setOpponentDto(opponentDto);
        return message;
    }


    @Override
    public int serverId() {
        return serverId;
    }
}
