package com.ayjs.mxzg.gameserver.module.role.service;


import cn.hutool.http.HttpUtil;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.util.ConcurrentHashSet;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.common.util.NamesThreadFactory;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.module.role.event.LogoutEvent;
import com.ayjs.mxzg.gameserver.web.support.WebResult;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

/**
 * 上传数据服务（1377实名认证上传数据）
 */
@Slf4j
@Observer
@Service
public class RoleInfoSendToExternalService implements Lifecycle {
    /**
     * 发送类型
     */
    public enum SendType {
        Login(1), // 登录
        Logout(2); // 登出
        private int type;

        SendType(int type) {
            this.type = type;
        }

        public int getType() {
            return type;
        }
    }

    @Autowired
    private ServerConfig serverConfig;

    /**
     * 是否对外发送数据（1377实名认证上传数据）
     */
    @Value("${platform.1377.send.roleInfo.switch:false}")
    private boolean platform1377SendRoleInfoSwitch;
    /**
     * 发送数据超时时间
     */
    private int timeout = 3000;
    /**
     * 发送数据uri
     */
    private final static String REPORT_URI = "/cli/SendGameData/onlineData";


    public ConcurrentHashSet<Long> loginRoles = new ConcurrentHashSet<>();
    public ConcurrentHashSet<Long> logoutRoles = new ConcurrentHashSet<>();
    // 失败次数
    public ConcurrentHashMap<Long, Integer> roleTimes = new ConcurrentHashMap<>();

    private final ScheduledExecutorService executor = new ScheduledThreadPoolExecutor(1, new NamesThreadFactory("ROLE INFO SEND TO EXTERNAL"));

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf("ROLE INFO SEND TO EXTERNAL");
    }

    @Override
    public void start() throws Exception {
        if (isSend()) {
            executor.scheduleWithFixedDelay(() -> exeSend(), 30000, 10000, TimeUnit.MILLISECONDS);
            log.info("RoleInfoSendToExternalService is running");
        } else {
            log.info("RoleInfoSendToExternalService 1377 ExternalState:{} "
                    , platform1377SendRoleInfoSwitch);
        }
    }

    @Override
    public void stop() throws Exception {
        if (isSend()) {
            exeSend();
        }
    }

    public void exeSend() {
        try {
            if (!CollectionUtils.isEmpty(loginRoles)) {
                exeSendLoginType(loginRoles, SendType.Login);
            }
            if (!CollectionUtils.isEmpty(logoutRoles)) {
                exeSendLoginType(logoutRoles, SendType.Logout);
            }
        } catch (Exception e) {
            log.error("exe send failed!", e);
            e.printStackTrace();
        }
    }

    public void exeSendLoginType(ConcurrentHashSet<Long> listUid, SendType sendType) {
        try {
            Iterator<Long> it = listUid.iterator();
            while (it.hasNext()) {
                long uid = it.next();
                // 重试三次的不发
                if (roleTimes.get(uid) <= 2) {
                    roleTimes.computeIfPresent(uid, (k, v) -> v + 1);
                    sendData(uid, sendType);
                } else {
                    roleTimes.remove(uid);
                    it.remove();
                }
            }
        } catch (Exception e) {
            log.error("exeSendLoginType send failed!", e);
            e.printStackTrace();
        }
    }

    /**
     * 判断是否需要发送(只有1377版发送这个数据)
     *
     * @return
     */
    public boolean isSend() {
        if (platform1377SendRoleInfoSwitch) {
            return true;
        } else {
            return false;
        }
    }

    public boolean sendData(long uid, SendType type) {
        if (!isSend()) {
            return true;
        }

        try {
            Map<String, Object> param = new HashMap<>();
            param.put("uid", uid);
            param.put("type", type.getType());

            if (log.isDebugEnabled()) {
                log.debug("before externalUri:{}, param:{}", serverConfig.getManagementUrl() + REPORT_URI, GJsonUtils.toJson(param));
            }
            String result = HttpUtil.post(serverConfig.getManagementUrl() + REPORT_URI, param, timeout);
            log.debug("end externalUri result:{}", result);
            WebResult webResult = JsonUtil.parseJson(result, WebResult.class);
            if (webResult.getCode() != 1) {
                return false;
            }
        } catch (Exception e) {
            log.error("sendData failed!", e);
            e.printStackTrace();
            return false;
        }
        return true;
    }

//    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
//    private void onEvent(LoginEvent event) {
//        if (isSend()) {
//            if (!sendData(event.getUserId(), SendType.Login)) {
//                loginRoles.add(event.getUserId());
//                roleTimes.put(event.getUserId(), 1);
//            } else {
//                roleTimes.remove(event.getUserId());
//            }
//
//        }
//    }

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void onEvent(LogoutEvent event) {
        if (isSend()) {
            if (!sendData(event.getUserId(), SendType.Logout)) {
                logoutRoles.add(event.getUserId());
                roleTimes.put(event.getUserId(), 1);
            } else {
                roleTimes.remove(event.getUserId());
            }
        }
    }
}

