package com.ayjs.mxzg.gameserver;

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

import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.Semaphore;
import java.util.concurrent.atomic.AtomicLong;

@Slf4j
public class PushNotificationTest {

    private static ApnsClient apnsClient = null;

    private static final Semaphore semaphore = new Semaphore(10000);

    public static void main(String[] args) {
        PushNotificationTest iosPush = new PushNotificationTest();
        List<String> deviceTokens = new ArrayList<>();
        deviceTokens.add("36855c6865dd14bd227abb877769b957b03c4e31b7228c0f5fdb88c01d6f90bb");
        iosPush.push(deviceTokens,"测试push","契约召唤推送！");
    }

    public void push(final List<String> deviceTokens, String alertTitle, String alertBody) {

        long startTime = System.currentTimeMillis();

        if (apnsClient == null) {
            try {
                EventLoopGroup eventLoopGroup = new NioEventLoopGroup(4);
                apnsClient = new ApnsClientBuilder().setApnsServer(ApnsClientBuilder.DEVELOPMENT_APNS_HOST)
                        .setClientCredentials(new File("D:\\project\\mxzg\\devApns_zhjp.p12"), "123")
                        .setConcurrentConnections(4).setEventLoopGroup(eventLoopGroup).build();
            } catch (Exception e) {
                log.error("ios get pushy apns client failed!");
                e.printStackTrace();
            }
        }

        long total = deviceTokens.size();

        final AtomicLong successCnt = new AtomicLong(0);

        long startPushTime = System.currentTimeMillis();

        for (String deviceToken : deviceTokens) {
            ApnsPayloadBuilder payloadBuilder = new ApnsPayloadBuilder();
            payloadBuilder.setAlertBody(alertBody);
            payloadBuilder.setAlertTitle(alertTitle);

            String payload = payloadBuilder.buildWithDefaultMaximumLength();
            final String token = TokenUtil.sanitizeTokenString(deviceToken);
            SimpleApnsPushNotification pushNotification = new SimpleApnsPushNotification(token, "com.kokoro.zhjp.ios", payload);

            try {
                semaphore.acquire();
            } catch (InterruptedException e) {
                log.error("ios push get semaphore failed, deviceToken:{}", deviceToken);
                e.printStackTrace();
            }
            PushNotificationFuture<SimpleApnsPushNotification, PushNotificationResponse<SimpleApnsPushNotification>> future = apnsClient.sendNotification(pushNotification);


            future.addListener((GenericFutureListener<Future<PushNotificationResponse>>) pushNotificationResponseFuture -> {
                if (future.isSuccess()) {
                    final PushNotificationResponse<SimpleApnsPushNotification> response = future.getNow();
                    if (response.isAccepted()) {
                        successCnt.incrementAndGet();
                    } else {
                        Date invalidTime = response.getTokenInvalidationTimestamp();
                        log.error("Notification rejected by the APNs gateway: " + response.getRejectionReason());
                        if (invalidTime != null) {
                            log.error("\t…and the token is invalid as of " + response.getTokenInvalidationTimestamp());
                        }
                    }
                } else {
                    log.error("send notification device token={} is failed {} ", token, future.cause().getMessage());
                }

            });
            semaphore.release();
        }

        long endPushTime = System.currentTimeMillis();

        log.info("test pushMessage success. [共推送" + total + "个][成功" + (successCnt.get()) + "个],totalcost = "
                + (endPushTime - startTime) + ", pushCost = " + (endPushTime - startPushTime));
    }
}
