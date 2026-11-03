package com.ayjs.mxzg.gameserver.web.external;

import cn.hutool.crypto.SecureUtil;
import cn.hutool.http.HttpUtil;
import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.SymbolConstants;
import com.ayjs.mxzg.config.excel.cache.BuyGemSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.event.CreateRoleEvent;
import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;
import com.ayjs.mxzg.gameserver.module.role.event.RoleLvUpEvent;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.web.event.ReChargeCallbackEvent;
import com.google.common.collect.ImmutableMap;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.TreeMap;

/**
 * 给外部系统发送数据（上传登录充值数据给可以）
 */
@Slf4j
@Observer
@Component
public class ExternalDataSend {
    @Autowired
    private RoleService roleService;
    @Autowired
    private BuyGemSysCache buyGemSysCache;
    @Autowired
    private ServerConfig serverConfig;
    /**
     * 是否对外发送数据（海外数据上传数据给可以开关）
     */
    @Value("${external.state:false}")
    private boolean externalState;
    /**
     * 外部数据地址
     */
    @Value("${external.uri:https://apioverseas-report.hnguangyi.cn}")
    private String externalUri;
    /**
     * 发送数据超时时间
     */
    @Value("${external.timeout:10000}")
    private int externalTimeout;
    /**
     * 上传数据对应可以的渠道号
     */
    @Value("${external.agent_ios:mjyssIOS}")
    private String agentIos;
    /**
     * 上传数据对应可以的渠道号
     */
    @Value("${external.agent_android:qyzhhwAND}")
    private String agentAndroid;
    /**
     * 通讯秘钥
     */
    private final static String SECURE_KEY = "d0587b0f33759966cf674fb9cf96f253";

    private final static String LOGIN_URI = "/Api/Normal/Login";
    private final static String ROLE_INFO_URI = "/Api/Normal/Role";
    private final static String RECHARGE_URI = "/Api/Normal/Order";
//    // IOS渠道号
//    private final static String agentIos = "mjyssIOS";
//    // 安卓渠道号
//    private final static String agentAndroid = "qyzhhwAND";

    private final static String TEMP_GOODS_CODE = "99999";

    private static ImmutableMap<String, String> baseParam = null;

    static {
        Map<String, String> _baseParam = new HashMap<>();
        _baseParam.put("gid", "177");//游戏id
        _baseParam.put("idfa", "1");
        _baseParam.put("idfv", "1");
        _baseParam.put("oaid", "1");
        _baseParam.put("imei", "1");
        _baseParam.put("imei2", "1");
        baseParam = ImmutableMap.copyOf(_baseParam);
    }
    /**
     * 契约召唤
     * 游戏ID：177
     * 游戏密钥：7c9a1c54bb3583bb7af9054efbd9ba3c
     * 支付密钥：250110158623e07bfb422653704db6bc
     * agent：qyzhhwAND
     *
     * key: d0587b0f33759966cf674fb9cf96f253
     */
    /**
     * https://apioverseas-report.hnguangyi.cn/Api/Normal/Login
     *
     * @param event
     */
    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void onEvent(LoginEvent event) {
        if (!externalState){
            return;
        }
        Role role = roleService.getOrThrow(event.getRid());
        Map<String, Object> param = new TreeMap<>(baseParam);
        if (role.getPlatform() == 1){
            param.put("agent", agentAndroid);//渠道号
        } else {
            param.put("agent", agentIos);//渠道号
        }
        param.put("udid", event.getDeviceId());
        param.put("userCode", ConvertUtils.toString(event.getUserId()));
        param.put("userName", ConvertUtils.toString(role.getNick()));
        param.put("ip", event.getIp());
        param.put("systemId", "1");
        param.put("systemInfo", "1");
        param.put("mac", "1");
        param.put("serial", "1");
        param.put("screen", "1");
        param.put("net", "1");

        sendData(LOGIN_URI, param);
    }

    /**
     * https://apioverseas-report.hnguangyi.cn/Api/Normal/Role
     *
     * @param event
     */
    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void onEvent(CreateRoleEvent event) {
        if (!externalState){
            return;
        }
        Map<String, Object> param = new TreeMap<>(baseParam);
        Role role = roleService.getOrThrow(event.getRid());
        if (role.getPlatform() == 1){
            param.put("agent", agentAndroid);//渠道号
        } else {
            param.put("agent", agentIos);//渠道号
        }
        param.put("udid", event.getDeviceId());
        param.put("userCode", ConvertUtils.toString(event.getUserId()));
        param.put("userName", ConvertUtils.toString(event.getUserId()));
        param.put("sceneId", "createRole");
        param.put("roleId", ConvertUtils.toString(role.getId()));
        param.put("roleName", ConvertUtils.toString(role.getNick()));
        param.put("serverId", ConvertUtils.toString(role.getServerId()));
        param.put("serverName", ConvertUtils.toString(role.getServerId()));
        param.put("level", ConvertUtils.toString(role.getLevel()));
        param.put("currency", ConvertUtils.toString(role.getGem()));
        param.put("vip", ConvertUtils.toString(role.getGoddessVip()));
        param.put("balance", ConvertUtils.toString(role.getGold()));
        param.put("power", ConvertUtils.toString(role.getFighting()));
        param.put("ip", event.getIp());

        sendData(ROLE_INFO_URI, param);
    }

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void onEvent(RoleLvUpEvent event) {
        if (!externalState){
            return;
        }
        Map<String, Object> param = new TreeMap<>(baseParam);
        Role role = roleService.getOrThrow(event.getRid());
        if (role.getPlatform() == 1){
            param.put("agent", agentAndroid);//渠道号
        } else {
            param.put("agent", agentIos);//渠道号
        }
        param.put("udid", role.getDeviceId());
        param.put("userCode", ConvertUtils.toString(role.getUserId()));
        param.put("userName", ConvertUtils.toString(role.getUserId()));
        param.put("sceneId", "levelUp");
        param.put("roleId", ConvertUtils.toString(role.getId()));
        param.put("roleName", ConvertUtils.toString(role.getNick()));
        param.put("serverId", ConvertUtils.toString(role.getServerId()));
        param.put("serverName", ConvertUtils.toString(role.getServerId()));
        param.put("level", ConvertUtils.toString(role.getLevel()));
        param.put("currency", ConvertUtils.toString(role.getGem()));
        param.put("vip", ConvertUtils.toString(role.getGoddessVip()));
        param.put("balance", ConvertUtils.toString(role.getGold()));
        param.put("power", ConvertUtils.toString(role.getFighting()));
        param.put("ip", "1");

        sendData(ROLE_INFO_URI, param);
    }

    /**
     * https://apioverseas-report.hnguangyi.cn/Api/Normal/Order
     *
     * @param event
     */
    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void onEvent(ReChargeCallbackEvent event) {
        if (!externalState){
            return;
        }
        Map<String, Object> param = new TreeMap<>(baseParam);
        Role role = roleService.getOrThrow(event.getRecharge().getRid());
        if (role.getPlatform() == 1){
            param.put("agent", agentAndroid);//渠道号
        } else {
            param.put("agent", agentIos);//渠道号
        }
        param.put("udid", role.getDeviceId());
        param.put("userCode", ConvertUtils.toString(role.getUserId()));
        param.put("userName", ConvertUtils.toString(role.getUserId()));
        param.put("billNo", ConvertUtils.toString(event.getRecharge().getId()));
        param.put("amount", ConvertUtils.toString(event.getRecharge().getPayUsdCent() / 100.0D));
        param.put("roleId", ConvertUtils.toString(role.getId()));
        param.put("roleName", role.getNick());
        param.put("serverId", ConvertUtils.toString(role.getServerId()));
        param.put("serverName", ConvertUtils.toString(role.getServerId()));
        if (event.getRecharge().getProductId() > 0) {
            param.put("goodsCode", ConvertUtils.toString(event.getRecharge().getProductId()));
        } else {
            param.put("goodsCode", TEMP_GOODS_CODE);
        }

        CBuyGem buyGem = buyGemSysCache.getById(event.getRecharge().getProductId());
        String subject = ConvertUtils.toString(event.getRecharge().getProductId());
        if (Objects.nonNull(buyGem)) {
            subject += buyGem.getNote();
        }
        param.put("subject", subject);
        param.put("level", ConvertUtils.toString(role.getLevel()));
        param.put("vip", ConvertUtils.toString(role.getGoddessVip()));
        param.put("ip", "1");

        sendData(RECHARGE_URI, param);
    }

    /**
     * 发送数据
     *
     * @param uri
     * @param param
     */
    public void sendData(String uri, Map<String, Object> param) {
        if (!externalState){
            return;
        }
        // 只有港台发送这个数据
//        if (serverConfig.getServerPlatformId() != 400){
//            return;
//        }
        String sign = generateSign(param);
        param.put("sign", sign);
//        log.debug("before externalUri:{}, param:{}", externalUri + uri, GJsonUtils.toJson(param));
        String result = HttpUtil.post(externalUri + uri, param, externalTimeout);
        log.info("end externalUri:{}, param:{}, result:{}", externalUri + uri, GJsonUtils.toJson(param), result);
    }

    /**
     * 生成sign
     *
     * @param param
     * @return
     */
    public String generateSign(Map<String, Object> param) {
        StringBuilder str = new StringBuilder();
        for (Map.Entry<String, Object> entry : param.entrySet()) {
            str.append(entry.getKey()).append(SymbolConstants.EQUAL).append(entry.getValue()).append(SymbolConstants.AMPERSAND);
        }
        str.append("key").append(SymbolConstants.EQUAL).append(SECURE_KEY);
        return SecureUtil.md5(str.toString());
    }
}
