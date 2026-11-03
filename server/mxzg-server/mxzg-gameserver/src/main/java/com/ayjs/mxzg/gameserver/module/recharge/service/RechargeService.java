/**
 *
 */
package com.ayjs.mxzg.gameserver.module.recharge.service;

import com.ayjs.mxzg.common.base.IRegister;
import com.ayjs.mxzg.common.exception.ErrorCodeException;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.config.excel.cache.AreaSysCache;
import com.ayjs.mxzg.config.excel.cache.BuyGemSysCache;
import com.ayjs.mxzg.config.excel.entity.CArea;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ItemType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.constant.RechargeLimitArea;
import com.ayjs.mxzg.gameserver.module.recharge.dao.RechargeDao;
import com.ayjs.mxzg.gameserver.module.recharge.domain.Recharge;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.server.constant.ServerParamType;
import com.ayjs.mxzg.gameserver.module.server.domain.ServerParam;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.gameserver.module.server.struct.RechargeLimit;
import com.ayjs.mxzg.gameserver.web.constant.RechargeLevelInfo;
import com.ayjs.mxzg.protocol.RechargeGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

/**
 * @author YY
 *
 */
@Slf4j
@Service
public class RechargeService implements IRegister<IRechargeBuyingService> {

    @Autowired
    private BuyGemSysCache buyGemSysCache;
    @Autowired
    private RechargeDao rechargeDao;
    @Autowired
    private RoleRechargeService roleRechargeService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private ServerParamService serverParamService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private AreaSysCache areaSysCache;

    private Map<BuyGemType, IRechargeBuyingService> rechargeBuyingServices = new ConcurrentHashMap<>();

    @Override
    public void registerBean(IRechargeBuyingService bean) {
        if (rechargeBuyingServices.containsKey(bean.buyGemType())) {
            throw new RuntimeException("重复的充值处理被注册BuyGemType." + bean.buyGemType());
        }
        rechargeBuyingServices.put(bean.buyGemType(), bean);
    }

    public Recharge getRecharge(long id) {
        return rechargeDao.get(id);
    }

    public Recharge getByPlatformOrderId(String platformOrderId) {
        if (StringUtils.isBlank(platformOrderId)) {
            return null;
        }
        return rechargeDao.getByPlatformOrderId(platformOrderId);
    }

    public void addRecharge(Recharge recharge) {
        rechargeDao.add(recharge);
    }

    public void updateRecharge(Recharge recharge) {
        rechargeDao.update(recharge);
    }

    /**
     * 是否可以购买该商品
     *
     * @param rid
     * @param cBuyGem
     * @return
     */
    public boolean isCanBuy(long rid, CBuyGem cBuyGem) {
        BuyGemType buyGemType = BuyGemType.valueOf(cBuyGem.getKind());
        if (buyGemType == null) {
            throw new ErrorCodeException(ErrorCode.RECHARGE_TYPE_NOT_FOUND.getValue(), "Kind:" + cBuyGem.getKind());
        }
        IRechargeBuyingService service = rechargeBuyingServices.get(buyGemType);
        if (service == null) {
            return true;
        }
        return service.canBuy(rid, cBuyGem.getIdx());
    }

    /**
     * 商品购买成功
     *
     * @param rid
     * @param productId
     * @param isGm
     * @return
     */
    public boolean buyGoodsSuccess(long rid, int productId, int payMoney, boolean isGm) {
        CBuyGem cBuyGem = buyGemSysCache.getOrThrow(productId);
        BuyGemType buyGemType = BuyGemType.valueOf(cBuyGem.getKind());
        if (buyGemType == null) {
            return false;
        }
        IRechargeBuyingService service = rechargeBuyingServices.get(buyGemType);
        if (service == null) {
            return false;
        }
        service.buyGoodsSuccess(rid, cBuyGem, isGm);
        //不管什么类型的充值，都需要记录充值信息
        roleRechargeService.recharge(rid, payMoney, cBuyGem.getIdx(), 0);
        return true;
    }

    public boolean bugGameCoin(long rid, int gameCoin, int extraCameCoin, int payMoney) {

        thingService.add(rid, ImmutableThing.of(ItemType.IT_GEM, gameCoin + extraCameCoin), GameEvent.RECHARGE);
        roleRechargeService.recharge(rid, payMoney, 0, gameCoin);
        return true;
    }

    /**
     * 获取充值等级限制数据
     *
     * @return
     */
    public RechargeLimit getRechargeLimit() {
        ServerParam serverParam = serverParamService.getOrCreate(ServerParamType.RECHARGE_LEVEL_INFO, RechargeLimit::new);
        RechargeLimit rechargeLimit = null;
        if (Objects.nonNull(serverParam)) {
            try {
                rechargeLimit = serverParam.parseJson(RechargeLimit.class);
            } catch (Exception e) {
                log.info("ServerParamType.RECHARGE_LEVEL_INFO parseJson exception:", e);
            }
        }
        return rechargeLimit;
    }

    /**
     * 修改充值限制数据
     *
     * @param rechargeLimit
     */
    public void updateRechargeLimit(RechargeLimit rechargeLimit) {
        ServerParam serverParam = serverParamService.getOrCreate(ServerParamType.RECHARGE_LEVEL_INFO, () -> rechargeLimit);
        serverParam.saveJson(rechargeLimit);
        serverParamService.update(serverParam);
    }

    /**
     * 获取充值等级限制响应消息
     *
     * @param rid
     * @return
     */
    public RechargeGMsg.GResRechargeLimitInfo getGResRechargeLimitInfo(long rid, RechargeLimit rechargeLimit) {

        RechargeGMsg.GResRechargeLimitInfo.Builder builder = RechargeGMsg.GResRechargeLimitInfo.newBuilder();

        Role role = roleService.getOrThrow(rid);
        if (Objects.nonNull(rechargeLimit)) {
            builder.setLimitTotalCharge(rechargeLimit.getTotalRecharge());
            CArea createArea = areaSysCache.getById(role.getCreateAreaId());
            if (Objects.nonNull(createArea)) {
                if (isContainsArea(rechargeLimit.getAreas(), createArea.getProvince(), createArea.getCity())) {
                    builder.setLimitArea(true);
                }
            }
            CArea loginArea = areaSysCache.getById(role.getLoginAreaId());
            if (Objects.nonNull(loginArea)) {
                if (isContainsArea(rechargeLimit.getLoginAreas(), loginArea.getProvince(), loginArea.getCity())) {
                    builder.setLimitArea(true);
                }
            }
            Set<RechargeLevelInfo> levelInfos = rechargeLimit.getLevelInfos();
            if (CollectionUtils.isNotEmpty(levelInfos)) {
                levelInfos.forEach(info -> {
                    if (info.getIsOpen() > 0) {
                        RechargeGMsg.RechargeLevelInfo.Builder infoBuilder = RechargeGMsg.RechargeLevelInfo.newBuilder();
                        infoBuilder.setClientType(info.getClientType());
                        infoBuilder.setLevel(info.getLevel());
                        builder.addData(infoBuilder);
                    }
                });
            }
            log.debug("rechargeLimit:{} CreateAreaId:{} LoginAreaId:{},createArea city:{} loginArea city:{}",
                    GJsonUtils.toJson(rechargeLimit), role.getCreateAreaId(), role.getLoginAreaId(),
                    createArea.getCity(), loginArea.getCity());
        }
        return builder.build();
    }

    /**
     * 判断是否在区域内
     * 特殊处理：广东省屏蔽时不包含广州市，深圳市
     *
     * @return
     */
    public boolean isContainsArea(Set<String> areas, String province, String cityName) {
        if (CollectionUtils.isEmpty(areas) || StringUtils.isBlank(province) || StringUtils.isBlank(cityName)) {
            return false;
        }
        if (areas.contains(cityName) && RechargeLimitArea.limitAreas.contains(cityName)) {
            return true;
        }
        if (areas.contains(province) && !RechargeLimitArea.limitAreas.contains(cityName)) {
            return true;
        }
        if (areas.contains(cityName)) {
            return true;
        }
        return false;
    }

}
