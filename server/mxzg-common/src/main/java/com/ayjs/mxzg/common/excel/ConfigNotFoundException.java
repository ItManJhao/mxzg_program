package com.ayjs.mxzg.common.excel;

import lombok.Getter;

/**
 *
 */
public class ConfigNotFoundException extends RuntimeException {

    private static final long serialVersionUID = -4314269554019810170L;

    /**
     * 参数，错误语音需要填充的参数
     */
    @Getter
    private final String[] params;

    public ConfigNotFoundException(String message, String... params) {
    	super(message);
        this.params = params;
    }
}
