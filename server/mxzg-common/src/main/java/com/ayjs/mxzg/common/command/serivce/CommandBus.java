package com.ayjs.mxzg.common.command.serivce;

import com.ayjs.mxzg.common.command.Command;

/**
 * 指令总线接口
 * @author meiyc
 *
 */
public interface CommandBus {

	/**
	 * 指令调用返回指令对象
	 * @param command
	 * @return
	 */
	<T extends Command> T invoke(final T command);
	
	/**
	 * 根据指令类型调用指令，并返回指定类型的结果
	 * @param commandType
	 * @param returnType
	 * @param args
	 * @return
	 */
	<T extends Command, V> V invoke(Class<T> commandType, Class<V> returnType, Object... args);
	
}
