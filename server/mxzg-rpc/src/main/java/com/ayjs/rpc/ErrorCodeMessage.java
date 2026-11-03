package com.ayjs.rpc;

import lombok.Value;

/**
 * 错误码消息
 */
@Value(staticConstructor = "of")
public class ErrorCodeMessage implements ErrorResultMessage {

    /** 角色id */
    private long rId;

    /** 错误码 */
    private int errorCode;

    private String[] params;

}
