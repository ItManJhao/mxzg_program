package com.ayjs.mxzg.tools.client.client;

import com.ayjs.mxzg.common.netty.GameMessage;
import com.ayjs.mxzg.common.netty.LittleIODecoder;
import com.ayjs.mxzg.common.netty.LittleIOEncoder;
import com.ayjs.mxzg.common.util.NamesThreadFactory;
import com.ayjs.mxzg.protocol.LoginGMsg;
import com.ayjs.mxzg.tools.client.client.network.ClientHandler;
import com.ayjs.mxzg.tools.client.client.network.ClientSession;
import com.ayjs.mxzg.tools.client.client.network.ConnectStatus;
import com.google.protobuf.Message;
import io.netty.bootstrap.Bootstrap;
import io.netty.channel.Channel;
import io.netty.channel.ChannelFuture;
import io.netty.channel.ChannelInitializer;
import io.netty.channel.ChannelPipeline;
import io.netty.channel.EventLoopGroup;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.SocketChannel;
import io.netty.channel.socket.nio.NioSocketChannel;
import io.netty.util.AttributeKey;
import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.Objects;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * 客户端业务
 *
 * @author tangyangbo 2019/8/8 17:32
 */
@Slf4j
public class ClientService {

    private static ClientService clientService = new ClientService();
    @Getter
    @Setter
    private ClientSession client;

    private URI uri;


    private ScheduledExecutorService executeHeartBeatExecutor =
            Executors.newSingleThreadScheduledExecutor(new NamesThreadFactory("HEARTBEAT-EXECUTOR-EXECUTOR"));

    public static ClientService getInstance() {
        return clientService;
    }

    public URI getUrl(String host, int port) {
        try {
            if (uri == null) {
                uri = new URI(String.format("ws://%s:%s/server", host, port));
            }
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }
        return uri;
    }

    public void connect(String host, int port, long userId, int platform, int serverId) {
        if (Objects.nonNull(client)) {
            if (!ConnectStatus.CONNECT.equals(client.getConnectStatus())) {
                log.info("loginStatus:{}", client.getConnectStatus());
                return;
            }
        }

        Bootstrap bootstrap = new Bootstrap();
        EventLoopGroup group = new NioEventLoopGroup();
        bootstrap.group(group);
        bootstrap.channel(NioSocketChannel.class);
        bootstrap.handler(new ChannelInitializer<SocketChannel>() {
            @Override
            protected void initChannel(SocketChannel ch) {
                ChannelPipeline pipeline = ch.pipeline();
                pipeline.addLast(new LittleIODecoder());
                pipeline.addLast(new LittleIOEncoder());
                //自定义的游戏协议处理器
                pipeline.addLast("handler", new ClientHandler());
            }
        });
        bootstrap.remoteAddress(host, port);
        ChannelFuture future = bootstrap.connect();
        try {
            Thread.sleep(500);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        if (future.isSuccess()) {
            ClientSession client = new ClientSession("" + userId, serverId);
            client.setPlatform(platform);
            client.setUserId(userId);
            client.setChannel(future.channel());
            AttributeKey<ClientSession> key = AttributeKey.valueOf(ClientCMD.CLIENT_KEY);
            future.channel().attr(key).set(client);
            setClient(client);
            log.info("socket connected.");
        } else {
            log.error("socket connect failure");
        }
        executeHeartBeatExecutor.scheduleAtFixedRate(() -> {
            sendHeartBeat();
        }, 10000, 20000, TimeUnit.MILLISECONDS);
    }


    public void login() {
        if (Objects.isNull(client)) {
            log.info("login error, not connect");
            return;
        }
        if (client.getRid() > 0) {
            log.info("openid:{} is login. playerId:{}", client.getOpenid(), client.getRid());
            return;
        }
//        if (client.getRid() > 0 && ConnectStatus.LOGIN_ROLE == client.getConnectStatus()) {
//            log.info("openid:{} is login. playerId:{}", client.getOpenid(), client.getRid());
//            return;
//        }
//        if (client.getRid() == 0 && ConnectStatus.LOGIN_GAME == client.getConnectStatus()) {
//            log.info("login error, not connect status:{}", client.getConnectStatus());
//            return;
//        }
        LoginGMsg.GReqLogin.Builder loginReqBuilder = LoginGMsg.GReqLogin.newBuilder();
        loginReqBuilder.setPlatform(client.getPlatform());
        loginReqBuilder.setServerId(client.getServerId());
        loginReqBuilder.setUserId(client.getUserId());

        writeAndFlush(ClientCMD.PLAYER_LOGIN_CMD, loginReqBuilder.build());
        log.info("userId:{} is send login request. ", client.getUserId());
    }

    public void createPlayer(long userId, int platform, int serverId) {
        LoginGMsg.GReqInit.Builder reqInitBuilder = LoginGMsg.GReqInit.newBuilder();
        reqInitBuilder.setNick("" + userId);
        reqInitBuilder.setLang(1);
        reqInitBuilder.setPlatform(platform);
        writeAndFlush(ClientCMD.PLAYER_REG_CMD, reqInitBuilder.build());
    }

    public void sendHeartBeat() {
        LoginGMsg.GReqHeartBeat.Builder builder = LoginGMsg.GReqHeartBeat.newBuilder();
        writeAndFlush(ClientCMD.HEART_BEAT, builder.build());
    }


    public boolean writeAndFlush(int messageId, Message protoMessage) {
        Channel channel = client.getChannel();
        if (Objects.isNull(channel) || !channel.isActive()) {
            log.error("client.getChannel() is null or not active");
            return false;
        }
        GameMessage message = new GameMessage();
        message.setCmd(messageId);
        message.setMsg(protoMessage.toByteArray());
        channel.writeAndFlush(message);
        return true;
    }
}
