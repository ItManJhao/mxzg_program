package com.ayjs.rpc;

import lombok.Value;

/**
 * 缺省的消息结果
 * @author meiyc
 *
 */
@Value(staticConstructor = "of")
public class DefaultResultMessage implements ErrorResultMessage {

	/** 预期返回类型 */
	private Class<?> returnType;

}
