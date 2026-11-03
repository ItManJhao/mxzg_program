package com.ayjs.mxzg.gameserver.web.api;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.BuyGemSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.recharge.constant.GiveState;
import com.ayjs.mxzg.gameserver.module.recharge.domain.Recharge;
import com.ayjs.mxzg.gameserver.module.recharge.event.VirtualRechargeEvent;
import com.ayjs.mxzg.gameserver.module.recharge.service.RechargeService;
import com.ayjs.mxzg.gameserver.module.recharge.service.RoleRechargeService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.gameserver.module.server.struct.RechargeLimit;
import com.ayjs.mxzg.gameserver.web.constant.RechargeLevelInfo;
import com.ayjs.mxzg.gameserver.web.constant.WebErrorCode;
import com.ayjs.mxzg.gameserver.web.event.ReChargeCallbackEvent;
import com.ayjs.mxzg.gameserver.web.event.RechargeLimitChangeEvent;
import com.ayjs.mxzg.gameserver.web.support.WebResult;
import com.ayjs.mxzg.gameserver.web.util.ApiUtil;
import com.google.common.reflect.TypeToken;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

/**
 * 充值回调接口
 */
@Slf4j
@RestController
@RequestMapping("/recharge")
public class RechargeApi {
    @Autowired
    RechargeService rechargeService;
    @Autowired
    RoleRechargeService roleRechargeService;
    @Autowired
    BuyGemSysCache buyGemSysCache;
    @Autowired
    ThingService thingService;
    @Autowired
    private ApiUtil apiUtil;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private RoleService roleService;
    @Autowired
    private ServerParamService serverParamService;

    /**
     * /recharge/chargeCallback
     * 平台通知后端发货
     *
     * @param orderId 数字，游戏的订单ID
     * @param money   数字，实际支付的金额，单位分
     * @param status  数字，充值的状态，1成功，2失败
     * @param payTime 数字，付款时间，单位秒
     * @param isTest  数字，是否测试订单，0正式订单，1测试订单
     * @param sign    签名
     * @param platformOrderId    平台订单id
     * @param extraData    所有参数json
     * @return
     */
    @RequestMapping(value = "/chargeCallback", method = RequestMethod.GET)
    public String chargeCallback(@RequestParam("orderId") long orderId, @RequestParam("money") long money,
                                 @RequestParam("status") int status, @RequestParam("payTime") int payTime, @RequestParam("isTest") int isTest,
                                 @RequestParam("sign") String sign, @RequestParam("platformOrderId") String platformOrderId,
                                 @RequestParam(value = "extraData", required = false) String extraData) {

        synchronized (String.valueOf(platformOrderId).intern()) {
            Recharge recharge = null;
            try {
                // 验证sign
                Map<String, String> signMap = new HashMap<>();
                signMap.put("action", "recharge.chargeCallback");
                signMap.put("orderId", orderId + "");
                signMap.put("platformOrderId  ", platformOrderId + "");
                signMap.put("money", money + "");
                signMap.put("status", status + "");
                signMap.put("isTest", isTest + "");
                signMap.put("payTime", payTime + "");
                String signStr = apiUtil.buildSignStr(signMap);
                String localSign = apiUtil.buildSign(signStr);
                log.info("充值回调orderId=" + orderId + ",money=" + money + ",status=" + status + ",payTime=" + payTime + ",isTest="
                        + isTest + ",sign=" + sign);

                int payType = 1;// 1-游戏内购 2-第三方支付
                Map<String, String> extraDataMap = null;
                try {
                    // 判断是否有扩展数据，判断是否贪玩第三方充值
                    if (!StringUtils.isBlank(extraData) && extraData.length() > 3) {
                        log.debug("extraData:{}", extraData);
                        extraDataMap = GJsonUtils.fromJson(extraData, new TypeToken<Map<String, String>>() {
                        });

                        payType = ConvertUtils.toInt(extraDataMap.getOrDefault("pay_type", "1"));
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

                if (payType == 1) {// 游戏内购
                    recharge = rechargeService.getRecharge(orderId);
                    // PayMoney内购没办法记录实际金额，下单的时候就已经记录好了
//                    if (Objects.nonNull(recharge)) {
//                        recharge.setPayMoney(money);
//                    }
                } else if (payType == 2) { // 第三方充值
                    if (CollectionUtil.isEmpty(extraDataMap)) {
                        log.error("第三方充值参数错误 platformOrderId:{}", platformOrderId);
                        return GJsonUtils.toJson(WebResult.of(WebErrorCode.FAIL.getCode(), "ORDER_NOT_FOUND"));
                    }
                    // 第三方充值,根据平台id查询订单
                    recharge = rechargeService.getByPlatformOrderId(platformOrderId);
                    if (Objects.isNull(recharge)) {// 还没订单
                        recharge = roleRechargeService.createThirdPartyRecharge(platformOrderId, extraDataMap);
                    }
                    // 第三方支付已经创建过订单，暂时没逻辑
                } else {
                    log.error("付费类型:{} ERROR_PAY_TYPE, orderId:{} platformOrderId:{}", +payType, orderId, platformOrderId);
                    return GJsonUtils.toJson(WebResult.of(WebErrorCode.FAIL.getCode(), "ERROR_PAY_TYPE"));
                }

                if (Objects.isNull(recharge)) {
                    log.error("充值订单" + orderId + " ORDER_NOT_FOUND");
                    return GJsonUtils.toJson(WebResult.of(WebErrorCode.FAIL.getCode(), "ORDER_NOT_FOUND"));
                }

                if (recharge.getGiveState() == GiveState.SUCCESS.getType() || recharge.getGiveState() == GiveState.SUCCESS_HALF.getType()) {
                    // 订单已经发货
                    log.error("充值订单" + orderId + " ORDER_GAVE");
                    WebResult webResult = WebResult.of(WebErrorCode.ORDER_GAVE.getCode(), "ORDER_GAVE");
                    webResult = putWebResultData(recharge, webResult);
                    return GJsonUtils.toJson(webResult);
                }
                recharge.setPlatformOrderId(platformOrderId);
                recharge.setCallback_time(TimeDateUtil.getCurrentTimeInt());
                recharge.setSign(sign);
                recharge.setLocalSign(localSign);
                recharge.setSignStr(signStr);

                if (sign == null || !localSign.equals(sign)) {
                    log.error("充值订单" + orderId + " ERROR_SIGN");
                    return GJsonUtils.toJson(WebResult.of(WebErrorCode.FAIL.getCode(), "ERROR_SIGN"));
                }

                recharge.setStatus(status);
                recharge.setIsTest(isTest);
                if (recharge.getStatus() != 1) {
                    //还没有成功支付的订单
                    log.error("充值订单" + orderId + " ORDER_UNPAY");
                    return GJsonUtils.toJson(WebResult.of(WebErrorCode.FAIL.getCode(), "ORDER_UNPAY"));
                }

                // 发货
//                if (!serverConfig.isServerDebug() && recharge.getPreMoney() != recharge.getPayMoney()) {
//                    //下单金额跟实付金额不一致
//                    log.error("充值订单" + orderId + " MONEY_NOT_MATCH");
//                    return GJsonUtils.toJson(WebResult.of(WebErrorCode.FAIL.getCode(), "MONEY_NOT_MATCH"));
//                }

                // 是内购，还是按游戏币购买
                boolean success = false;
                recharge.setGiveState(GiveState.FAIL.getType()); // 先预设为已发货，避免发货过程报错导致订单重复发货

                if (recharge.getProductType() == 0) {
                    // 根据充值商品的类型分发到各个商品处理函数中，比如买钻石、买月卡、买礼包等等
                    success = rechargeService.buyGoodsSuccess(recharge.getRid(), recharge.getProductId(), (int) recharge.getPayMoney(), false);

                } else if (recharge.getProductType() == 1) {
                    // 第三方充值直接购买游戏币
                    success = rechargeService.bugGameCoin(recharge.getRid(), recharge.getGameCoin(), recharge.getExtraCameCoin(), (int) recharge.getPayMoney());
                }

                if (success) {
                    recharge.setGiveState(GiveState.SUCCESS.getType());
                    recharge.setGiveTime(TimeDateUtil.getCurrentTimeInt());

                    // 补上实际支付金额（参数是贪玩平台，若其他平台需要另外再算）
                    // ---2020-12-04 修改换成用平台传来的数值
//                    if (CollectionUtil.isNotEmpty(extraDataMap)) {
//                        double payUsd = 0.0d;
//                        try {
//                            payUsd = ConvertUtils.toDouble(extraDataMap.getOrDefault("pay_usd", ""));
//                            long payUsdCent = (long) (payUsd * 100);
//                            recharge.setPayUsdCent(payUsdCent);
//                        } catch (Exception e) {
//                            log.error("pay_usd convert error extraDataMap:{}", GJsonUtils.toJson(extraDataMap));
//                        }
//                    } else {
//                        recharge.setPayUsdCent(recharge.getPayMoney());
//                    }
                    recharge.setPayUsdCent(money);

                    WebResult webResult = WebResult.of(WebErrorCode.SUCCESS.getCode(), "SUCCESS");
                    webResult = putWebResultData(recharge, webResult);

                    eventBus.post(ReChargeCallbackEvent.of(recharge, extraDataMap));
                    return GJsonUtils.toJson(webResult);

                } else {
                    recharge.setGiveState(GiveState.FAIL.getType());
                    log.error("充值订单" + orderId + " FAIL");
                    return GJsonUtils.toJson(WebResult.of(WebErrorCode.FAIL.getCode(), "FAIL"));
                }

            } catch (Exception e) {
                log.error("充值订单" + orderId + " FAIL_EXCEPTION", e);
                if (Objects.nonNull(recharge)) {
                    recharge.setGiveState(GiveState.FAIL.getType());
                }
                return GJsonUtils.toJson(WebResult.of(WebErrorCode.FAIL.getCode(), "FAIL_EXCEPTION"));
            } finally {
                if (Objects.nonNull(recharge)) {
                    rechargeService.updateRecharge(recharge);
                }
            }
        }
    }

    /**
     * 设置充值等级
     * /recharge/rechargeLevel
     *
     * @param data {"clientType":1,"level":10,"isOpen":1}
     *             client_type:1:安卓，2:IOS，3:H5
     *             level:角色等级
     *             is_open:0关闭，1生效
     * @return
     */
    @RequestMapping(value = "/rechargeLevel", method = {RequestMethod.GET, RequestMethod.POST})
    public String rechargeLevel(@RequestParam(name = "data") String data) {
        if (StringUtils.isBlank(data)) {
            return GJsonUtils.toJson(WebResult.of(WebErrorCode.FAIL.getCode(), "data is null"));
        }

        RechargeLimit rechargeLimit = rechargeService.getRechargeLimit();
        if (Objects.isNull(rechargeLimit)) {
            rechargeLimit = new RechargeLimit();
            rechargeLimit.setAreas(new HashSet<>());
            rechargeLimit.setLoginAreas(new HashSet<>());
            rechargeLimit.setLevelInfos(new HashSet<>());
        }

        Set<RechargeLevelInfo> rechargeLevelInfos = GJsonUtils.fromJson(data, new TypeToken<Set<RechargeLevelInfo>>() {
        });
        rechargeLimit.setLevelInfos(rechargeLevelInfos);
        rechargeService.updateRechargeLimit(rechargeLimit);
        eventBus.post(RechargeLimitChangeEvent.of(rechargeLimit.getTotalRecharge(), rechargeLimit.getAreas(),
                rechargeLimit.getLoginAreas(), rechargeLevelInfos));
        return GJsonUtils.toJson(WebResult.of(WebErrorCode.SUCCESS.getCode(), "SUCCESS"));
    }

    /**
     * 后台GM充值
     * /recharge/virtualRecharge
     *
     * @param rid       玩家ID
     * @param productId 商品ID
     * @return
     */
    @RequestMapping(value = "/virtualRecharge", method = RequestMethod.GET)
    public String virtualRecharge(@RequestParam(name = "rid") long rid, @RequestParam(name = "productId") int productId) {
        CBuyGem cBuyGem = buyGemSysCache.getOrThrow(productId);
        if (cBuyGem == null) {
            return GJsonUtils.toJson(WebResult.of(WebErrorCode.FAIL.getCode(), "PRODUCT_NOT_EXIST"));
        }

        log.info("后台GM操作，玩家{}进行购买商品{}", rid, productId);
        //根据buyGem的类型分发到各种模块进行是否能够购买商品的判断，比如限购的判断
        if (!rechargeService.isCanBuy(rid, cBuyGem)) {
            log.info("后台GM操作，玩家{}无法再购买限购商品{}", rid, productId);
            return GJsonUtils.toJson(WebResult.of(WebErrorCode.FAIL.getCode(), "PRODUCT_LIMIT"));
        }
        boolean flag = rechargeService.buyGoodsSuccess(rid, productId, cBuyGem.getRmb(), true);
        log.info("后台GM操作，玩家{}购买商品{}，{}", rid, productId, flag);

        eventBus.post(VirtualRechargeEvent.of(rid, productId, flag ? 1 : 0, 0));

        return GJsonUtils.toJson(WebResult.of(WebErrorCode.SUCCESS.getCode(), "SUCCESS"));
    }


    public static String giftKey = "qw445oeuo578nkd9hsand45s42s";

    /**
     * 7.可购礼包列表接口
     * /recharge/tanwanDirectBuyGemList
     *
     * @param roleid 角色ID
     * @return
     */
    @RequestMapping(value = "/tanwanDirectBuyGemList", method = RequestMethod.GET)
    public String tanwanDirectBuyGemList(@RequestParam(name = "roleid") long roleid) {
        WebResponeResult result = new WebResponeResult();

        if (!roleService.isRole(roleid)) {
            result.setCode(0);
            result.setMessage("ROLEID_ERROR");
            return GJsonUtils.toJson(result);
        }
        Role role = roleService.getOrThrow(roleid);

        CanBuyGemList gemResponse = new CanBuyGemList();
        gemResponse.setCanbuy_product_id(new ArrayList<>());

        for (CBuyGem cBuyGem : buyGemSysCache.getAll()) {
            try {
                if (role.getLevel() < cBuyGem.getLevel()){
                    continue;
                }
                if (rechargeService.isCanBuy(roleid, cBuyGem)) {
                    gemResponse.getCanbuy_product_id().add(cBuyGem.getIdx() + "");
                }
            } catch (Exception e) {
                log.error("tan wan DirectBuyGemList error:", e);
            }
        }

        result.setCode(1);
        result.setMessage("success");
        result.setData(gemResponse);
        return GJsonUtils.toJson(result);
    }

    /**
     * 8.可购礼包判断接口
     * /recharge/tanwanCanDirectBuyGem
     *
     * @param roleid     角色ID
     * @param product_id 商品ID
     * @return
     */
    @RequestMapping(value = "/tanwanCanDirectBuyGem", method = RequestMethod.GET)
    public String tanwanCanDirectBuyGem(@RequestParam(name = "roleid") long roleid,
                                        @RequestParam(name = "product_id") String product_id) {

        WebResponeResult result = new WebResponeResult();

        if (!roleService.isRole(roleid)) {
            result.setCode(0);
            result.setMessage("ROLEID_ERROR");
            return GJsonUtils.toJson(result);
        }

        int idx = Integer.parseInt(product_id);
        CBuyGem cBuyGem = buyGemSysCache.getById(idx);
        if (cBuyGem == null) {
            result.setCode(0);
            result.setMessage("PRODUCTID_ERROR");
            return GJsonUtils.toJson(result);
        }
        CanBuyGem canBuyGem = new CanBuyGem();
        canBuyGem.setCanBuy("N");
        try {
            if (rechargeService.isCanBuy(roleid, cBuyGem)) {
                result.setCode(1);
                result.setMessage("success");
                canBuyGem.setCanBuy("Y");
            }
        } catch (Exception e) {
            log.error("tan wan CanDirectBuyGem error:", e);
        }
        result.setData(canBuyGem);
        return GJsonUtils.toJson(result);
    }

    public WebResult putWebResultData(Recharge recharge,WebResult webResult){
        Map<String, String> data = webResult.getData();
        data.put("cp_order_id", "" + recharge.getId());
        data.put("level", "" + recharge.getRoleLv());
        data.put("vip", "0");
        data.put("money", String.valueOf(recharge.getPayMoney() / 100.0F));
        return webResult;
    }

    public static class WebResponeResult {
        private int code;
        private String message;
        private Object data;

        public int getCode() {
            return code;
        }

        public void setCode(int code) {
            this.code = code;
        }

        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }

        public Object getData() {
            return data;
        }

        public void setData(Object data) {
            this.data = data;
        }
    }

    public static class CanBuyGemList {
        private List<String> canbuy_product_id;

        public List<String> getCanbuy_product_id() {
            return canbuy_product_id;
        }

        public void setCanbuy_product_id(List<String> canbuy_product_id) {
            this.canbuy_product_id = canbuy_product_id;
        }
    }

    public static class CanBuyGem {
        private String canBuy;

        public String getCanBuy() {
            return canBuy;
        }

        public void setCanBuy(String canBuy) {
            this.canBuy = canBuy;
        }
    }

}
