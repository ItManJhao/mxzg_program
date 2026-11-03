package com.ayjs.mxzg.gameserver.module.push.service;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.LanguageSysCache;
import com.ayjs.mxzg.config.excel.cache.OpenConditionSysCache;
import com.ayjs.mxzg.config.excel.cache.PushNotificationSysCache;
import com.ayjs.mxzg.config.excel.entity.CLanguage;
import com.ayjs.mxzg.config.excel.entity.COpenCondition;
import com.ayjs.mxzg.config.excel.entity.CPushNotification;
import com.ayjs.mxzg.config.struct.Language;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.module.battle.domain.RoleMission;
import com.ayjs.mxzg.gameserver.module.battle.event.IdleAwardReceiveEvent;
import com.ayjs.mxzg.gameserver.module.battle.service.RoleMissionService;
import com.ayjs.mxzg.gameserver.module.push.struct.PushInfo;
import com.ayjs.mxzg.gameserver.module.push.struct.PushNotificationInfo;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.role.service.RoleVipService;
import com.ayjs.mxzg.template.language.LanguageHelper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Observer
@Service
public class PushNotificationService implements Lifecycle {
    @Autowired
    private RoleService roleService;
    @Autowired
    private RoleVipService roleVipService;
    @Autowired
    private RoleMissionService roleMissionService;
    @Autowired
    private PushNotificationSysCache pushNotificationSysCache;
    @Autowired
    private OpenConditionSysCache openConditionSysCache;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private LanguageSysCache languageSysCache;
    @Autowired
    private LanguageHelper languageHelper;
    @Autowired
    private PushService pushService;


    /**
     * 推送map key:rid  value:推送实体
     */
    private Map<Long, PushNotificationInfo> pushNotificationMap = new ConcurrentHashMap<Long, PushNotificationInfo>();

    /**
     * key:延时时间  value：推送集合
     */
    private Map<Integer, List<PushNotificationInfo>> pushNotificationMap_delay = new ConcurrentHashMap<Integer, List<PushNotificationInfo>>();

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf("Push Notification Service");
    }

    @Override
    public void start() throws Exception {
        //只发送日服
        if (serverConfig.getServerLang() != Language.JPN.getCode()) {
            return;
        }
        //挂机推送信息初始化
        List<RoleMission> roleMissionList = roleMissionService.getAllRoleMission();
        for (RoleMission roleMission : roleMissionList) {
            long rid = roleMission.getRid();
            int startTime = roleMission.getStartTime();
            if (startTime <= 0) {
                startTime = DateTimeUtil.currentSecond();
            }
            addPushNotification(rid, startTime);
        }
        //从小到大排序
        for (Map.Entry<Integer, List<PushNotificationInfo>> entry : pushNotificationMap_delay.entrySet()) {
            List<PushNotificationInfo> list = entry.getValue();
            if (!list.isEmpty()) {
                Collections.sort(list, pushNotificationComparator);
            }
        }
    }

    @Override
    public void stop() throws Exception {
    }

    /**
     * 推送数据比较器,从小到大排序
     */
    private static Comparator<PushNotificationInfo> pushNotificationComparator = new Comparator<PushNotificationInfo>() {
        @Override
        public int compare(PushNotificationInfo o1, PushNotificationInfo o2) {
            if (o1.getStartTime() < o2.getStartTime()) {
                return -1;
            } else if (o1.getStartTime() > o2.getStartTime()) {
                return 1;
            }
            return 0;
        }
    };

    //增加延时推送对象
    private void addPushNotification(long rid, int startTime) {
        //只发送日服
        if (serverConfig.getServerLang() != Language.JPN.getCode()) {
            return;
        }
        int maxLaytime = roleVipService.getIdleMaxTime(rid);//延迟推送时间，秒
        int layTime = DateTimeUtil.currentSecond() - startTime;//当前延时
        boolean isSend = false;//默认没有发送
        if (layTime > maxLaytime) {//发送过后，状态已经发送,不加入发送缓存
            isSend = true;
            return;
        }
        PushNotificationInfo pushNotificationNew = new PushNotificationInfo(rid, startTime, isSend, maxLaytime);
        PushNotificationInfo pushNotificationOld = pushNotificationMap.put(rid, pushNotificationNew);
        if (pushNotificationOld != null) {
            //删除掉原来的对象
            List<PushNotificationInfo> listOld = pushNotificationMap_delay.get(pushNotificationOld.getDelayTime());
            listOld.remove(pushNotificationOld);
        }
        //添加新的对象
        List<PushNotificationInfo> list = pushNotificationMap_delay.get(maxLaytime);
        if (list == null) {
            //创建
            list = new LinkedList();
            pushNotificationMap_delay.put(maxLaytime, list);
        }
        list.add(pushNotificationNew);//再讲数据放入对应集合末尾
    }

//    public void removePushNotification(long rid) {
//        PushNotificationInfo pushNotification = pushNotificationMap.get(rid);
//        if (pushNotification == null) {
//            return;
//        }
//        pushNotificationMap.remove(rid);
//        pushNotificationList.remove(pushNotification);
//    }

    //玩家领取挂机事件
    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(IdleAwardReceiveEvent event) {
        try {
            long rid = event.getRid();
            int startTime = DateTimeUtil.currentSecond();
            addPushNotification(rid, startTime);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

//    /**
//     * vip升级
//     *
//     * @param event
//     */
//    @Subscribe(async = Subscribe.AsyncType.Async)
//    public void goddessVipLevelUpEvent(GoddessVipLevelUpEvent event) {
//
//    }

    public void checkAndSendPush() {
        //只发送日服
        if (serverConfig.getServerLang() != Language.JPN.getCode()) {
            return;
        }
        fixedPush();//定点推送
        opreaOffLine();//离线挂机延时推送
    }

    private static int yanshi_pushId = 1;//离线挂机推送模板

    //离线挂机奖励推送
    private void opreaOffLine() {
        try {
            CPushNotification cPushNotification = pushNotificationSysCache.getById(yanshi_pushId);//挂机推送配置
            //根据操作时间从小到大排序集合，所以下标越小数据延时越长
            Map<Integer, Map<Long, String>> tokenByPlatformId = new HashMap<>();//临时token集合（根据平台类型区分，ios、安卓）
            Map<Integer, List<PushNotificationInfo>> pushNotificationMap_delay_ = new ConcurrentHashMap<>(pushNotificationMap_delay);
            for (Map.Entry<Integer, List<PushNotificationInfo>> entry : pushNotificationMap_delay_.entrySet()) {
                List<PushNotificationInfo> list = new LinkedList<>(entry.getValue());
                if (list.isEmpty()) {
                    continue;
                }
                int maxLaytime = entry.getKey();//延迟推送时间，秒
                for (PushNotificationInfo pushNotificationInfo : list) {
                    long rid = pushNotificationInfo.getRid();
                    Role role = roleService.getOrThrow(rid);
                    if (!checkRoleLvAndOpenIsOk(role, cPushNotification)) {
                        continue;
                    }
                    if (pushNotificationInfo.isSend()) {//已经发送
                        continue;
                    }
                    int startTime = pushNotificationInfo.getStartTime();
                    int layTime = DateTimeUtil.currentSecond() - startTime;//当前延时
                    if (layTime < maxLaytime) {//不满足推送条件
                        break;
                    }
                    pushNotificationInfo.setSend(true);//设置已经发送
                    addTokenByPlatformId(role, tokenByPlatformId);
                }
            }
            //推送文本
            sendPushInfo(tokenByPlatformId, cPushNotification);
        } catch (Exception e) {
            log.error("oprea Off Line exception", e);
            e.printStackTrace();
        }
    }

    //根据平台（ios，安卓）添加token
    private void addTokenByPlatformId(Role role, Map<Integer, Map<Long, String>> tokenByPlatformId) {
        int platformId = role.getPlatform();
        Map<Long, String> tokens = tokenByPlatformId.get(platformId);
        if (tokens == null) {
            tokens = new HashMap<>();
            tokenByPlatformId.put(platformId, tokens);
        }
        tokens.put(role.getId(), role.getPushToken());
    }

    //定点推送
    private void fixedPush() {
        try {
            List<CPushNotification> pushTList = pushNotificationSysCache.getCPushNotifications_fixed();
            List<CPushNotification> pushOk = new ArrayList<>();
//            String nowHM = DateTimeUtil.date("HH:mm");//当前几点几分
            //先判断当前时间要推送的文本模板
            for (CPushNotification cPushNotification : pushTList) {
                if (cPushNotification.getPush_open() != 1) {//系统推送关闭
                    continue;
                }
                //判断时间
                if (!cPushNotification.checkTime_fixed()) {
                    continue;
                }
                pushOk.add(cPushNotification);
            }
            //没有文本处理
            if (pushOk.isEmpty()) {
                return;
            }
            List<Role> roles = roleService.getAllRole();
            for (CPushNotification cPushNotification : pushOk) {
                Map<Integer, Map<Long, String>> tokenByPlatformId = new HashMap<>();//临时token集合（根据平台类型区分，ios、安卓）
                //再将模板统一发送给玩家
                for (Role role : roles) {
                    if (!checkRoleLvAndOpenIsOk(role, cPushNotification)) {
                        continue;
                    }
                    addTokenByPlatformId(role, tokenByPlatformId);
                }
                //推送文本
                sendPushInfo(tokenByPlatformId, cPushNotification);
                log.info("fixed Push cPushNotification:{} role size:{}", GJsonUtils.toJson(cPushNotification), tokenByPlatformId.size());
            }
        } catch (Exception e) {
            log.error("fixedPush exception", e);
            e.printStackTrace();
        }
    }

    //判断角色等级和角色推送开关，以及系统推送开关
    private boolean checkRoleLvAndOpenIsOk(Role role, CPushNotification cPushNotification) {
        if (cPushNotification.getPush_open() != 1) {//系统推送关闭
            return false;
        }
        COpenCondition condition = openConditionSysCache.getCondition(cPushNotification.getOpencondition_key());
        int roleLv_limit = condition.getCondition_value();
        if (roleLv_limit <= 0) {
            roleLv_limit = 1;
        }
        if (role.getLevel() < roleLv_limit) {//角色等级不够
            return false;
        }
        Set<Integer> pushOffIds = role.getPushOffIds();
        if (pushOffIds.contains(cPushNotification.getIdx())) {//已经关闭
            return false;
        }
        return true;
    }

    //推送给分发器
    private void sendPushInfo(Map<Integer, Map<Long, String>> tokenByPlatformId, CPushNotification cPushNotification) {
        if (tokenByPlatformId.isEmpty()) {
            return;
        }
        CLanguage titleCLanguage = languageSysCache.getByKey(cPushNotification.getPush_name());//标题
        CLanguage contentCLanguage = languageSysCache.getByKey(cPushNotification.getContext());//内容
        String title = languageHelper.getLanguageBy(titleCLanguage);
        String content = languageHelper.getLanguageBy(contentCLanguage);

        sendPushInfo(tokenByPlatformId, title, content);

    }

    /**
     * 根据不同平台，ios、安卓分发推送
     *
     * @param tokenByPlatformId
     * @param title
     * @param content
     */
    private void sendPushInfo(Map<Integer, Map<Long, String>> tokenByPlatformId, String title, String content) {
        if (CollectionUtil.isEmpty(tokenByPlatformId) || StringUtils.isBlank(title) || StringUtils.isBlank(content)) {
            return;
        }
        //根据不同平台，ios、安卓分发推送
        for (Map.Entry<Integer, Map<Long, String>> entry : tokenByPlatformId.entrySet()) {
            Map<Long, String> entryValue = entry.getValue();
            if (CollectionUtil.isEmpty(entryValue)) {
                continue;
            }
            int platFormId = entry.getKey();
            PushInfo pushInfo = new PushInfo();
            pushInfo.setPlatform(platFormId);
            pushInfo.setTokens(entryValue);
            pushInfo.setTitle(title);
            pushInfo.setContent(content);
            pushInfo.setExeTime(DateTimeUtil.currentSecond());
            pushService.addPushInfo(pushInfo);
        }
    }

    public void sendPushInfo(long rid, String title, String content) {
        Map<Integer, Map<Long, String>> tokenByPlatformIdMap = new HashMap<>(1);
        Role role = roleService.getOrThrow(rid);
        Map<Long, String> tokenMap = new HashMap<>(1);
        tokenMap.put(role.getId(), role.getNick());
        tokenByPlatformIdMap.put(role.getPlatform(), tokenMap);
        sendPushInfo(tokenByPlatformIdMap, title, content);
    }

}
