package com.ayjs.mxzg.gameserver.module.push.service;


import cn.hutool.core.collection.CollectionUtil;
import cn.hutool.http.HttpUtil;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.NamesThreadFactory;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.struct.Language;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.module.push.struct.PushInfo;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.turo.pushy.apns.ApnsClient;
import com.turo.pushy.apns.ApnsClientBuilder;
import com.turo.pushy.apns.PushNotificationResponse;
import com.turo.pushy.apns.util.ApnsPayloadBuilder;
import com.turo.pushy.apns.util.SimpleApnsPushNotification;
import com.turo.pushy.apns.util.TokenUtil;
import com.turo.pushy.apns.util.concurrent.PushNotificationFuture;
import io.netty.channel.EventLoopGroup;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.util.concurrent.Future;
import io.netty.util.concurrent.GenericFutureListener;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.File;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

/**
 * 推送服务
 */
@Slf4j
@Service
public class PushService implements Lifecycle {

    @Value("${apns.p12.file:}")
    private String apnsP12File;
    @Value("${apns.p12.password:}")
    private String apnsP12password;
    @Value("${apns.app.package:}")
    private String apnsAppPackage;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private RoleService roleService;
    /**
     * 按照推送url
     */
    public static String JPN_ANDROID_PUSH_URL = "User/firebasePush";

    private static ApnsClient apnsClient = null;

    public ConcurrentLinkedQueue<PushInfo> queue = new ConcurrentLinkedQueue<>();

    private final ScheduledExecutorService executor = new ScheduledThreadPoolExecutor(1, new NamesThreadFactory("PUSH SERVICE"));

    private final EventLoopGroup eventLoopGroup = new NioEventLoopGroup(2);

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf("Push Service");
    }

    @Override
    public void start() throws Exception {
        if (serverConfig.getServerLang() == Language.JPN.getCode()) {
            executor.scheduleWithFixedDelay(()-> exePush(),1000,10000, TimeUnit.MILLISECONDS);
        }
    }

    @Override
    public void stop() throws Exception {
        if (serverConfig.getServerLang() == Language.JPN.getCode()) {
            exePush();
        }
    }

    public void addPushInfo(PushInfo pushInfo) {
        if (serverConfig.getServerLang() == Language.JPN.getCode()) {
            queue.offer(pushInfo);
        }
    }

    public synchronized void initAPNsClient(){
        if (apnsClient == null) {
            try {
                if (StringUtils.isBlank(apnsP12File)){
                    log.info("apns P12 File is null");
                    return;
                }
                if (StringUtils.isBlank(apnsP12password)){
                    log.info("apns P12 password is null");
                    return;
                }
                if (StringUtils.isBlank(apnsAppPackage)){
                    log.info("apns App Package is null");
                    return;
                }

                ApnsClientBuilder apnsClientBuilder = new ApnsClientBuilder();
                apnsClientBuilder.setClientCredentials(new File(apnsP12File), apnsP12password)
//                        .setClientCredentials(new File("D:\\project\\mxzg\\devApns_zhjp.p12"), "123")
                        .setConcurrentConnections(2).setEventLoopGroup(eventLoopGroup);
                if (serverConfig.isServerDebug()){
                    apnsClientBuilder.setApnsServer(ApnsClientBuilder.DEVELOPMENT_APNS_HOST);
                } else {
                    apnsClientBuilder.setApnsServer(ApnsClientBuilder.PRODUCTION_APNS_HOST);
                }

                apnsClient = apnsClientBuilder.build();
                log.info("apns Client success! apnsClient:{}",apnsClient);
            } catch (Exception e) {
                log.error("ios get pushy apns client failed!",e);
                e.printStackTrace();
                if (Objects.nonNull(apnsClient)) {
                    apnsClient.close();
                    apnsClient = null;
                }
            }
        }
    }

    public void exePush() {
        try {
            initAPNsClient();
            if (Objects.isNull(apnsClient)){
                return;
            }

            while (true) {
                PushInfo pushInfo = queue.poll();
                if (Objects.isNull(pushInfo)) {
                    break;
                }

                if(pushInfo.getPlatform() == 1){
                    androidPush(pushInfo);
                } else if (pushInfo.getPlatform() == 2) {
                    iosPush(pushInfo);
                } else {
                    log.error("pushInfo.getPlatform error:{}", pushInfo.getPlatform());
                }
            }
        } catch (Exception e){
            log.error("exe push failed!",e);
            e.printStackTrace();
        }
    }

    public void iosPush(PushInfo pushInfo){
        Map<Long,String> failedMap = new HashMap<>();
        for (Map.Entry<Long, String> entry : pushInfo.getTokens().entrySet()) {

            ApnsPayloadBuilder payloadBuilder = new ApnsPayloadBuilder();
            payloadBuilder.setAlertTitle(pushInfo.getTitle());
            payloadBuilder.setAlertBody(pushInfo.getContent());

            String payload = payloadBuilder.buildWithDefaultMaximumLength();
            final String sanitizeToken = TokenUtil.sanitizeTokenString(entry.getValue());
            SimpleApnsPushNotification pushNotification = new SimpleApnsPushNotification(sanitizeToken, apnsAppPackage, payload);
//                    SimpleApnsPushNotification pushNotification = new SimpleApnsPushNotification(sanitizeToken, "com.kokoro.zhjp.ios", payload);

            PushNotificationFuture<SimpleApnsPushNotification, PushNotificationResponse<SimpleApnsPushNotification>> future = apnsClient.sendNotification(pushNotification);


            future.addListener((GenericFutureListener<Future<PushNotificationResponse>>) pushNotificationResponseFuture -> {
                if (future.isSuccess()) {
                    final PushNotificationResponse<SimpleApnsPushNotification> response = future.getNow();
                    if (response.isAccepted()) {
                        log.debug("push success");
                    } else {
                        Date invalidTime = response.getTokenInvalidationTimestamp();
                        log.error("Notification rejected by the APNs gateway: " + response.getRejectionReason());
                        if (invalidTime != null) {
                            log.error("\t…and the token is invalid as of " + response.getTokenInvalidationTimestamp());
                        }
                    }
                } else {
                    failedMap.put(entry.getKey(), entry.getValue());
//                    failedTokens.add(token);
                    log.error("send notification device token={} is failed {} ", entry.getValue(), future.cause().getMessage());
                }
            });
        }
        // 失败的多试几次
        if (CollectionUtil.isNotEmpty(failedMap) && pushInfo.getTryCnt() < 3){
            pushInfo.setTokens(failedMap);
            pushInfo.setTryCnt(pushInfo.getTryCnt() + 1);
            addPushInfo(pushInfo);
        }
    }

    public void androidPush(PushInfo pushInfo) {
        Map<Long, String> tokens = pushInfo.getTokens();

        Map<String,Object> args = new HashMap<>();
        args.put("is_broadcast", 0);
        args.put("title", pushInfo.getTitle());
        args.put("content", pushInfo.getContent());
        args.put("time", DateTimeUtil.currentSecond());

        Set<Long> uidSet = new HashSet<>();
        for (Map.Entry<Long, String> entry : tokens.entrySet()) {
            Role role = roleService.getOrThrow(entry.getKey());
            uidSet.add(role.getUserId());

        }
        args.put("user_id", GJsonUtils.toJson(uidSet));

        String result = HttpUtil.post(serverConfig.getPlatformUri() + JPN_ANDROID_PUSH_URL, args, 10000);
        log.debug("android push result :{}" , result);
    }
}
