package com.ayjs.mxzg.common.netty;

/**
 * 包体过长异常
 */
public class PacketTooLongException extends RuntimeException {

    public PacketTooLongException(String message){
        super(message);
    }
}
