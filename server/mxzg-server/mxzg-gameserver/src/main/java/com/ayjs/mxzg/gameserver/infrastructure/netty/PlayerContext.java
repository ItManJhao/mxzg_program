/**
 *
 */
package com.ayjs.mxzg.gameserver.infrastructure.netty;

import com.ayjs.mxzg.common.akka.AkkaContext;
import com.ayjs.mxzg.common.netty.GameMessage;
import com.ayjs.mxzg.common.util.MessageUtils;
import com.ayjs.mxzg.common.util.StringUtil;
import com.ayjs.mxzg.common.util.SymbolConstants;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.protocol.LoginGMsg.GResError;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.google.protobuf.GeneratedMessage;
import io.netty.channel.Channel;
import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

import java.util.Arrays;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.ConcurrentHashMap;

/**
 * @author YY
 */
@Slf4j
public class PlayerContext {

    /**
     * 玩家的会话连接
     */
    private Channel channel;
    /**
     * 是否已经登录
     */
    private boolean isLogin = false;
    /**
     * 玩家的actor，用于保证对玩家处理都在单线程中
     */
    private final IPlayerActor actor;
    /**
     * 账号ID
     */
    private long userId;
    /**
     * 服务器ID
     */
    private int serverId;
    /**
     * 玩家ID
     */
    private long id;
    /**
     * 一秒内的协议请求
     */
    private Map<Integer, Integer> protocolCountMap = new ConcurrentHashMap<>();
    /**
     * 最后请求时间
     */
    private long lastRequestTime;

    /**
     * 最后请求聊天时间(秒)
     */
    @Getter
    @Setter
    private int lastReqChatTime;

    public PlayerContext(Channel channel) {
        this.channel = channel;
        this.actor = AkkaContext.createTypedActor(IPlayerActor.class, PlayerActor.class);
    }

    public boolean isLogin() {
        return isLogin;
    }

    public void setLogin(boolean isLogin) {
        this.isLogin = isLogin;
    }

    public IPlayerActor getActor() {
        return actor;
    }

    public void stopActor() {
        AkkaContext.stopTypedActor(actor);
    }

    /**
     * 连接是否还有效
     *
     * @return
     */
    public boolean isChannelAlive() {
        if (channel != null && channel.isActive() && channel.isWritable()) {
            return true;
        }
        return false;
    }

    public Map<Integer, Integer> getProtocolCountMap() {
        return protocolCountMap;
    }

    public void setProtocolCountMap(Map<Integer, Integer> protocolCountMap) {
        this.protocolCountMap = protocolCountMap;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getLastRequestTime() {
        return lastRequestTime;
    }

    public void setLastRequestTime(long lastRequestTime) {
        this.lastRequestTime = lastRequestTime;
    }

    public Channel getChannel() {
        return channel;
    }

    public void setChannel(Channel channel) {
        this.channel = channel;
    }

    public void closeChannel() {
        if (channel != null && channel.isActive()) {
            this.channel.close();
        }
    }

    public void write(int cmd, GeneratedMessage msg) {
        GameMessage message = new GameMessage();
        message.setCmd(cmd);
        message.setMsg(msg.toByteArray());
        write(message, msg);
    }

    public void write(GameMessage message, GeneratedMessage msg) {
        if (channel != null && channel.isActive() && channel.isWritable()) {
            channel.writeAndFlush(message);
            if (log.isDebugEnabled()) {
                log.debug("玩家ID:{},响应协议:{},长度{},消息内容{}",
                        this.getId(), message.getCmd(), message.getMsg().length, MessageUtils.formatMessage(msg, false));
            }
        }
    }

    /**
     * 发送错误提示
     * @param errorCode
     * @param params
     */
    public void writeError(ErrorCode errorCode, Object... params) {
        GResError.Builder builder = GResError.newBuilder();
        builder.setError(errorCode.getValue());
        if (params != null && params.length != 0) {
            for (Object obj : params) {
                builder.addParams(obj.toString());
            }
        }
        write(CmdCode._1005, builder.build());

        StackTraceElement[] element = new RuntimeException()
                .getStackTrace();
        String value = errorCode.getDesc();
        if (value != null) {
            for (Object param : params) {
                value = StringUtil.replaceString(value, "{}", param);
            }
        }
        if (element.length >= 4) {
            if (element[1].toString().contains(".handler")) {
                log.error("[{}={}={}] {}", errorCode.getValue(), value, Arrays.toString(params),
                        element[1].toString());
            } else {
                log.error("[{}={}={}] {}", errorCode.getValue(), value, Arrays.toString(params),
                        element[3].toString());
            }
        }
    }


    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public int getServerId() {
        return serverId;
    }

    public void setServerId(int serverId) {
        this.serverId = serverId;
    }

    public String getLocalAddress() {
        if (Objects.isNull(channel) || Objects.isNull(channel.localAddress())) {
            return SymbolConstants.EMPTY;
        }
        // channel.localAddress会得到ip+port，形如/192.168.0.1:12345
        String address = channel.localAddress().toString().replace(SymbolConstants.SLASH, SymbolConstants.EMPTY);
        return address.substring(0, address.indexOf(SymbolConstants.COLON));
    }

    public String getRemoteAddress() {
        if (Objects.isNull(channel) || Objects.isNull(channel.remoteAddress())) {
            return SymbolConstants.EMPTY;
        }
        // channel.remoteAddress会得到ip+port，形如/192.168.0.1:12345
        String address = "";
        try {
            address = channel.remoteAddress().toString().replace(SymbolConstants.SLASH, SymbolConstants.EMPTY);
        } catch (Exception e) {
            return SymbolConstants.EMPTY;
        }
        return address.substring(0, address.indexOf(SymbolConstants.COLON));
    }
}
