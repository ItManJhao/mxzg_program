package com.ayjs.mxzg.common.command.serivce;

import com.ayjs.mxzg.common.command.Command;
import com.ayjs.mxzg.common.command.invoker.CommandInvoker;
import com.ayjs.mxzg.common.command.invoker.CommandInvokerHolder;
import com.ayjs.mxzg.common.convert.ConvertUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

import java.util.List;

@Service
public class CommandBusImpl implements CommandBus {

	@Autowired
	private CommandInvokerHolder invokerHolder;
	
	@Override
	public <T extends Command> T invoke(T command) {
		List<CommandInvoker> invokers = invokerHolder.get(command.getClass());
		for (CommandInvoker invoker : invokers) {
			invoker.invoke(command);
			command.peek();
		}
		command.mergeResult();
		return command;
	}

	@Override
	public <T extends Command, V> V invoke(Class<T> commandType, Class<V> returnType, Object... args) {
		List<CommandInvoker> invokers = invokerHolder.get(commandType);
		Assert.isTrue(invokers.size() == 1, "指令类型的接收者数量不等于1");
		Object result = invokers.get(0).invoke(args);
		return ConvertUtils.convertTo(result, returnType);
	}

}
