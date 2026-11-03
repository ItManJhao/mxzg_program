/**
 *
 */
package com.ayjs.mxzg.gameserver.infrastructure.netty;

import com.ayjs.mxzg.common.base.SpringProxy;
import com.ayjs.mxzg.common.excel.ConfigNotFoundException;
import com.ayjs.mxzg.common.exception.ErrorCodeException;
import com.ayjs.mxzg.common.handler.HandlerExecutor;
import com.ayjs.mxzg.common.handler.ProtocolDispatcher;
import com.ayjs.mxzg.common.netty.GameMessage;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.MessageUtils;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.LoginGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.google.protobuf.Message;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.MDC;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

/**
 * @author YY
 *
 */
@Slf4j
public class PlayerActor implements IPlayerActor {

    @Override
    public void process(PlayerContext playerContext, GameMessage message) {
        log.debug("process:{}", GJsonUtils.toJson(message));
        MDC.put("rid", "rid=" + playerContext.getId());
        HandlerExecutor executor = ProtocolDispatcher.getExecutor(message.getCmd());
        if (executor == null) {
            log.info("没有找到协议号[" + message.getCmd() + "]对应的处理函数");
            return;
        }
        long startTime = TimeDateUtil.getCurrentTime();
        try {
            if (executor.isNeedLogin() && !playerContext.isLogin()) {
                log.error("玩家在没有完成登录操作下调用协议[" + message.getCmd() + "]");
                return;
            }
            if (!"".equals(executor.getEntry()) && playerContext.getId() > 0 && playerContext.isLogin()) {
                SpringProxy.getBean(RoleService.class).canEntry(playerContext.getId(), executor.getEntry());
            }

            Object object = executor.getMessage().getParserForType().parseFrom(message.getMsg());
            if (log.isDebugEnabled()) {
                log.debug("收到协议:{},长度:{},消息内容{}", message.getCmd(),
                        message.getMsg().length, MessageUtils.formatMessage((Message) object, false));
            }
            // -------测试 记录请求数据  start -------
//            if (log.isDebugEnabled()) {
//                recordMessage(message.getCmd(), MessageUtils.formatMessage((Message) object, false));
//            }
            // -------测试 记录请求数据  end   -------


            executor.getMethod().invoke(executor.getInvoker(), playerContext, object);

        } catch (Exception e) {
            int errorCode = 0;
            List<String> params = null;
            if (e instanceof ErrorCodeException) {
                ErrorCodeException errorCodeException = (ErrorCodeException) e;
                errorCode = errorCodeException.getErrorCode();
                printException(playerContext, errorCodeException);
            } else if (e.getCause() instanceof ErrorCodeException) {
                ErrorCodeException errorCodeException = (ErrorCodeException) e.getCause();
                errorCode = errorCodeException.getErrorCode();
                printException(playerContext, errorCodeException);
            } else if (e instanceof ConfigNotFoundException) {
                ConfigNotFoundException configNotFoundException = (ConfigNotFoundException) e;
                errorCode = ErrorCode.CONFIG_NOT_EXISTS.getValue();
                printException(playerContext, configNotFoundException);
            } else if (e.getCause() instanceof ConfigNotFoundException) {
                ConfigNotFoundException configNotFoundException = (ConfigNotFoundException) e.getCause();
                errorCode = ErrorCode.CONFIG_NOT_EXISTS.getValue();
                printException(playerContext, configNotFoundException);
            } else {
                log.error(e.getMessage(), e);
                errorCode = ErrorCode.OPERATION_FAILED.getValue();
                log.error("handler invoke error cmd:{},rid,{}", message.getCmd(), playerContext.getId());
            }
            LoginGMsg.GResError errorRes = PbUtil.builderError(errorCode, params);
            playerContext.write(CmdCode._1005, errorRes);
        } finally {
            long endTime = TimeDateUtil.getCurrentTime();
            if (endTime - startTime > 30) {
                log.warn("协议[{}]处理慢，耗时[{}]毫秒", message.getCmd(), endTime - startTime);
            }
            MDC.clear();
        }
    }

    private void printException(PlayerContext playerContext, ConfigNotFoundException configNotFoundException) {
        int errorCode = ErrorCode.CONFIG_NOT_EXISTS.getValue();
        String[] params = configNotFoundException.getParams();

        StringBuilder builder = new StringBuilder();
        StackTraceElement[] elements = configNotFoundException.getStackTrace();
        for (StackTraceElement ele : elements) {
            if (ele.toString().contains("com.ayjs.mxzg")) {
                builder.append("\n").append(ele.toString());
            }
        }
        log.error("error code:{}, params:{}, msg:{}, stackInfo:{}", errorCode,
                Arrays.toString(params), configNotFoundException.getMessage(), builder.toString());
    }

    private void printException(PlayerContext playerContext, ErrorCodeException errorCodeException) {
        int errorCode = errorCodeException.getErrorCode();
        String[] params = errorCodeException.getParams();

        StringBuilder builder = new StringBuilder();
        StackTraceElement[] elements = errorCodeException.getStackTrace();
        for (StackTraceElement ele : elements) {
            if (ele.toString().contains("com.ayjs.mxzg")) {
                builder.append("\n").append(ele.toString());
            }
        }
        log.error("error code:{}, params:{}, msg:{}, stackInfo:{}", errorCode,
                Arrays.toString(params), errorCodeException.getMessage(), builder.toString());
    }

    /**
     * 测试--协议数据写入本地文件
     */
    private void recordMessage(int cmd, String messageContext) {
        String message = String.format("%s=%s=%s", cmd, System.currentTimeMillis(), messageContext);
        FileWriter output = null;
        BufferedWriter writer = null;
        try {
            output = new FileWriter("d:/message.data", true);
            writer = new BufferedWriter(output);
            writer.append(message);
            writer.newLine();
            writer.flush();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (null != writer) {
                try {
                    writer.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (null != output) {
                try {
                    output.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

}
