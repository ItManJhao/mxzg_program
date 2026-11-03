package com.ayjs.mxzg.tools.client.stresstest;

import cn.hutool.core.util.RandomUtil;
import com.ayjs.mxzg.common.util.MessageUtils;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.protocol.ChatGMsg;
import com.ayjs.mxzg.protocol.LoginGMsg;
import com.ayjs.mxzg.tools.client.client.ClientCMD;
import com.ayjs.mxzg.tools.client.client.base.ClientRequestHandler;
import com.ayjs.mxzg.tools.client.client.base.ClientRequestHandlerRegistry;
import com.ayjs.mxzg.tools.client.client.network.ClientSession;
import com.ayjs.mxzg.tools.client.client.network.ConnectStatus;
import com.ayjs.mxzg.tools.client.stresstest.task.TaskEntity;
import com.ayjs.mxzg.tools.client.stresstest.task.TaskManager;
import com.google.protobuf.Message;
import lombok.extern.slf4j.Slf4j;
import org.springframework.util.StringUtils;

import java.util.Objects;
import java.util.concurrent.ScheduledFuture;

/**
 * 任务管理
 *
 * @author tangyangbo 2019/8/30 16:05
 */
@Slf4j
public class ClientTask implements Runnable {

    private ClientSession clientSession;
    /**
     * 开始时间
     */
    private long startTime;

    /**
     * 最后聊天请求时间
     */
    private long lastChatTime;

    public ClientTask(ClientSession clientSession) {
        this.clientSession = clientSession;
        long now = System.currentTimeMillis();
        this.startTime = now;
        this.lastChatTime = now;
    }

    @Override
    public void run() {
        try {
//            log.info("run, openId:{}", clientSession.getOpenid());
            if (clientSession.getChannel() == null || !clientSession.getChannel().isActive() || !clientSession.getChannel().isOpen()) {
                log.info("clientSession Channel is null or not active or not open :{}", clientSession.getOpenid());
//                clientSession.getChannel().close();
                ClientManager clientManager = ClientManager.getInstance();
                clientManager.removePlayers(clientSession.getId());
                ScheduledFuture taskScheduledFuture = clientManager.getTaskScheduledFuture(clientSession.getId());
                taskScheduledFuture.cancel(true);

                return;
            }
            if (clientSession.getConnectStatus() == ConnectStatus.CONNECT) {
                return;
            }

            if (clientSession.getConnectStatus() == ConnectStatus.LOGIN_GAME) {
                login();
            } else if (clientSession.getConnectStatus() == ConnectStatus.REGISTER_ROLE) {
                createPlayer();
            } else if (clientSession.getConnectStatus() == ConnectStatus.LOGIN_ROLE) {
                login();
            } else {
                long now = System.currentTimeMillis();
                if (now - clientSession.getLoginTime() < 2000) {
                    return;//登录2秒后发送协议
                }

                if (clientSession.getLevel() >= 2 && now - lastChatTime > StressTestConfig.getChatPerTime()) {
                    sendChat();
                    lastChatTime = now;
                }
                runTask();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void login() {
        if (Objects.isNull(clientSession)) {
            log.info("login error, not connect");
            return;
        }
        if (clientSession.getRid() > 0 && ConnectStatus.LOGIN_ROLE != clientSession.getConnectStatus()) {
            log.info("openid:{} is login. playerId:{}", clientSession.getOpenid(), clientSession.getRid());
            return;
        }
        if (clientSession.getRid() == 0 && ConnectStatus.LOGIN_GAME != clientSession.getConnectStatus()) {
            log.info("login error, not connect status:{}", clientSession.getConnectStatus());
            return;
        }

        int now = TimeDateUtil.getCurrentTimeInt();
        int interval = now - clientSession.getLastStateTime();
        if (interval < 1000) {//一秒钟只登录一次
            return;
        }
        clientSession.setLastStateTime(now);

        LoginGMsg.GReqLogin.Builder loginReqBuilder = LoginGMsg.GReqLogin.newBuilder();
        loginReqBuilder.setPlatform(clientSession.getPlatform());
        loginReqBuilder.setServerId(clientSession.getServerId());
        loginReqBuilder.setUserId(clientSession.getUserId());

        clientSession.writeAndFlush(ClientCMD.PLAYER_LOGIN_CMD, loginReqBuilder.build());
        log.info("userId:{} is send login request. ", clientSession.getUserId());
    }

    public void createPlayer() {

        int now = TimeDateUtil.getCurrentTimeInt();
        int interval = now - clientSession.getLastStateTime();
        if (interval < 1000) {//一秒钟只登录一次
            return;
        }

        if (clientSession.getRid() > 0) {
            //已经注册
            clientSession.setConnectStatus(ConnectStatus.LOGIN_ROLE);
            clientSession.setLastStateTime(0);
            return;
        }

        clientSession.setLastStateTime(now);

        LoginGMsg.GReqInit.Builder reqInitBuilder = LoginGMsg.GReqInit.newBuilder();
        log.error(clientSession.getRid() + ">>>>" + clientSession.getOpenid());
        reqInitBuilder.setNick("t" + clientSession.getOpenid());
        reqInitBuilder.setLang(1);
        reqInitBuilder.setPlatform(StressTestConfig.getDriveType());
        reqInitBuilder.setPlace(String.valueOf(StressTestConfig.getChannelSubId()));
        clientSession.writeAndFlush(ClientCMD.PLAYER_REG_CMD, reqInitBuilder.build());
        log.info("userId:{} is send createPlayer request. ", clientSession.getUserId());
    }

    public void sendChat() {
        ChatGMsg.GReqChat.Builder builder = ChatGMsg.GReqChat.newBuilder();
        builder.setType(1);
        builder.setRid(0);
        builder.setMsg(StressTestConfig.chatContext.get(RandomUtil.randomInt(StressTestConfig.chatContext.size())));
        clientSession.writeAndFlush(ClientCMD.SEND_CHAT, builder.build());
    }

    public void runTask() {
//        log.info("{} run task", clientSession.getOpenid());
        try {
            if (clientSession.getSendIndex() >= TaskManager.getTaskLength()) {
//                log.info("task completed.{}", clientSession.getOpenid());
//                ClientManager clientManager = ClientManager.getInstance();
//                ScheduledFuture taskScheduledFuture = clientManager.getTaskScheduledFuture(clientSession.getId());
//                boolean cancel = taskScheduledFuture.cancel(true);
//                log.debug("openid:{} ScheduledFuture is cancelled:{} is done:{} cancel result:{}",
//                        clientSession.getOpenid(),
//                        taskScheduledFuture.isCancelled(),
//                        taskScheduledFuture.isDone(),
//                        cancel);
                return;
            }
            TaskEntity taskEntity = TaskManager.getTasks().get(clientSession.getSendIndex());
            if (StringUtils.isEmpty(taskEntity)) {
                return;
            }
            long intervalTime = taskEntity.getRequestTime() - TaskManager.getStartTime();
            long now = System.currentTimeMillis();
            if (now - startTime < intervalTime) {
//                log.debug("now:{}, startTime:{}, {}, end intervalTime:{}",
//                        DateTimeUtil.date(now), DateTimeUtil.date(startTime), (now - startTime), intervalTime);
                return;
            }

            Message.Builder messageBuilder = taskEntity.getMessageBuilder();
            if (Objects.nonNull(messageBuilder)) {

                ClientRequestHandler reqHandler = ClientRequestHandlerRegistry.getHandler(taskEntity.getCmdId());
                reqHandler.handler(clientSession, messageBuilder);

                clientSession.writeAndFlush(taskEntity.getCmdId(), messageBuilder.build());
                log.info("{} send {} message, context:{}",
                        clientSession.getOpenid(), taskEntity.getCmdId(), MessageUtils.formatMessage(messageBuilder.build()));
            }
            clientSession.setSendIndex(clientSession.getSendIndex() + 1);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


}
