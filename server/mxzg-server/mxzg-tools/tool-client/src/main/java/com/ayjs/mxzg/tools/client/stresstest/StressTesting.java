package com.ayjs.mxzg.tools.client.stresstest;

import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.netty.LittleIODecoder;
import com.ayjs.mxzg.common.netty.LittleIOEncoder;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.tools.client.client.base.ClientRequestHandlerRegistry;
import com.ayjs.mxzg.tools.client.client.base.ClientResponseHandlerRegistry;
import com.ayjs.mxzg.tools.client.client.base.ProtocolRegistry;
import com.ayjs.mxzg.tools.client.client.network.ClientSession;
import com.ayjs.mxzg.tools.client.client.network.ConnectStatus;
import com.ayjs.mxzg.tools.client.stresstest.task.TaskManager;
import com.ayjs.mxzg.tools.client.util.TestPlatformHttpResult;
import com.ayjs.mxzg.tools.client.util.TestPlatformSupport;
import com.google.common.reflect.TypeToken;
import io.netty.bootstrap.Bootstrap;
import io.netty.channel.ChannelFuture;
import io.netty.channel.ChannelInitializer;
import io.netty.channel.ChannelPipeline;
import io.netty.channel.EventLoopGroup;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.SocketChannel;
import io.netty.channel.socket.nio.NioSocketChannel;
import io.netty.util.AttributeKey;
import lombok.extern.slf4j.Slf4j;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

/**
 * 压测程序
 *
 * @author tangyangbo 2019/8/27 20:22
 */
@Slf4j
public class StressTesting {

    public final static String CLIENT_KEY = "client-key";
    public final static String CONNECTOR_STR = "###";
    public final static String PASSWORD = "0";

    public static void main(String[] args) throws Exception {
        // 测试服配置信息
        String stressTestPath = null;
        if (args == null || args.length == 0) {
            stressTestPath = "stress-test.properties";
        } else {
            stressTestPath = args[0];
        }
        log.error(">>>>" + stressTestPath);
        StressTestConfig.init(stressTestPath);
        // 测试服配置信息
        StressTestConfig.initChatContext(StressTestConfig.getChatPath());
        // 初始化协议类和协议号的关系
        ProtocolRegistry.init();
        // 初始化响应解析器
        ClientResponseHandlerRegistry.init();
        // 初始化请求加工处理器
        ClientRequestHandlerRegistry.init();
        // 初始化录制的协议文件
        TaskManager.init(StressTestConfig.getMessageScript());

        ClientManager clientManager = ClientManager.getInstance();

        try {
            EventLoopGroup group = new NioEventLoopGroup();


            for (int n = 0; n < StressTestConfig.getTestNumbers(); n++) {

                String openid = getPrefix() + n;
                try {
                    // 请求平台
                    Map<String, Object> params = new HashMap<>();
                    params.put("action", "Platform.getUserServer");
                    params.put("open_id", openid);
                    params.put("c_id", StressTestConfig.getChannelId());
                    params.put("c_son_id", StressTestConfig.getChannelSubId());
                    params.put("device_type", StressTestConfig.getDriveType());
                    params.put("uuid", UUID.randomUUID());
                    params.put("is_test", 1);

                    TestPlatformHttpResult httpResult = TestPlatformSupport.sendToPlatform(params);
                    if (!httpResult.success()) {
                        log.error("openid:{}, request platform error:{}", openid, httpResult);
                        continue;
                    }
                    Map<String, String> resultMap = GJsonUtils.fromJson(httpResult.getData(), new TypeToken<Map<String, String>>() {
                    });
                    long uid = 0L;
                    if (resultMap.containsKey("uid")) {
                        uid = ConvertUtils.toLong(resultMap.get("uid"));
                    }
                    if (uid <= 0) {
                        log.error("request uid error:{}", GJsonUtils.toJson(resultMap));
                        continue;
                    }

                    Bootstrap bootstrap = new Bootstrap();
                    bootstrap.group(group);
                    bootstrap.channel(NioSocketChannel.class);
                    bootstrap.handler(new ChannelInitializer<SocketChannel>() {
                        @Override
                        protected void initChannel(SocketChannel ch) {
                            ChannelPipeline pipeline = ch.pipeline();
                            pipeline.addLast(new LittleIODecoder());
                            pipeline.addLast(new LittleIOEncoder());
                            //自定义的游戏协议处理器
                            pipeline.addLast("handler", new ClientStressTestHandler());
                        }
                    });
                    bootstrap.remoteAddress(StressTestConfig.getIp(), StressTestConfig.getPort());
                    ChannelFuture future = bootstrap.connect();
                    Thread.sleep(StressTestConfig.getConnectPerTime());
                    if (future.isSuccess()) {
                        ClientSession client = new ClientSession("" + uid, StressTestConfig.getServerId());
                        client.setUserId(uid);
                        client.setNickname(String.valueOf(uid));
                        client.setChannel(future.channel());
                        client.setServerId(StressTestConfig.getServerId());
                        client.setChatPerTime(StressTestConfig.getChatPerTime());
                        client.setChatContext(StressTestConfig.getChatContext());
                        // 已连接，未登陆
                        client.setConnectStatus(ConnectStatus.LOGIN_GAME);

                        AttributeKey<ClientSession> key = AttributeKey.valueOf(CLIENT_KEY);
                        future.channel().attr(key).set(client);
                        // 加入处理对列
                        client.setId(n);
                        clientManager.addPlayers(n, client);
                        clientManager.startClient(client, StressTestConfig.getRequestPerTime(), n);
                        log.error("Number:{} openid:{} connect success! {}", n, openid, LocalDateTime.now());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            Runtime.getRuntime().addShutdownHook(new Thread(() -> {
                Set<Integer> sessionIds = new HashSet<>(clientManager.getPlayers().keySet());
                sessionIds.forEach(sessId -> {
                    clientManager.removePlayers(sessId);
                });
            }));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static String getPrefix() {
        int now = (int) (System.currentTimeMillis() / 1000);
        try {
            InetAddress address = InetAddress.getLocalHost();
            return address.getHostAddress() + "-" + now;
        } catch (UnknownHostException e) {
            e.printStackTrace();
        }

        throw new RuntimeException();
    }

}
