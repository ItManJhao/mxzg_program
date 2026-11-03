/**
 *
 */
package com.ayjs.mxzg.gameserver.module.recharge.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.cache.BuyGemSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.recharge.domain.Recharge;
import com.ayjs.mxzg.gameserver.module.recharge.domain.RoleRecharge;
import com.ayjs.mxzg.gameserver.module.recharge.service.RechargeService;
import com.ayjs.mxzg.gameserver.module.recharge.service.RoleRechargeService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.server.struct.RechargeLimit;
import com.ayjs.mxzg.protocol.RechargeGMsg;
import com.ayjs.mxzg.protocol.RechargeGMsg.GReqRechargeOrder;
import com.ayjs.mxzg.protocol.RechargeGMsg.GReqShopRechargeCheck;
import com.ayjs.mxzg.protocol.RechargeGMsg.GResRechargeOrder;
import com.ayjs.mxzg.protocol.RechargeGMsg.GResShopRechargeCheck;
import com.ayjs.mxzg.template.constant.ErrorCode;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.Objects;

/**
 * @author YY
 *
 */
@Slf4j
@Controller
public class RechargeHandler extends ProtocolHandler {

    @Autowired
    private BuyGemSysCache buyGemSysCache;
    @Autowired
    private RechargeService rechargeService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private RoleRechargeService roleRechargeService;
    @Autowired
    private ServerConfig serverConfig;


    @CMD(id = CmdCode._30001)
    public void getRechargeOrder(PlayerContext playerContext, GReqRechargeOrder msg) {
        CBuyGem cBuyGem = buyGemSysCache.getOrThrow(msg.getProductIdx());
        Asserts.notNull(cBuyGem, ErrorCode.BUY_GEM_NOT_FOUND.getValue(), msg.getProductIdx() + "");

        Role role = roleService.getOrThrow(playerContext.getId());

        //根据buyGem的类型分发到各种模块进行是否能够购买商品的判断，比如限购的判断
        Asserts.isTrue(rechargeService.isCanBuy(role.getId(), cBuyGem), ErrorCode.RECHARGE_CANT_BUY.getValue(), "");

        Recharge recharge = roleRechargeService.createRecharge(role, cBuyGem, msg.getCliExtraInfo());

//        rechargeService.addRecharge(recharge);

        GResRechargeOrder.Builder builder = GResRechargeOrder.newBuilder();
        builder.setOrderId(String.valueOf(recharge.getId()));
        builder.setExtraInfo(recharge.getExtraInfo());
        builder.setProductIdx(cBuyGem.getIdx());

        if (serverConfig.isServerDebug()) {
            builder.setProductCode(cBuyGem.getTest_code());
        } else {
            builder.setProductCode(cBuyGem.getPlatformCode(role.getPlatform()));
        }
        playerContext.write(CmdCode._30001, builder.build());
    }

    @CMD(id = CmdCode._30002)
    public void shopRechargeCheck(PlayerContext playerContext, GReqShopRechargeCheck msg) {
        RoleRecharge roleRecharge = roleRechargeService.getRoleRecharge(playerContext.getId());

        GResShopRechargeCheck.Builder builder = GResShopRechargeCheck.newBuilder();
        builder.setTotalCharge(roleRecharge.getTotalRecharge());
        builder.addAllList(roleRecharge.getUntellRecharge());
        builder.addAllBuyIdx(roleRecharge.getChargedInfo());
        playerContext.write(CmdCode._30002, builder.build());

        roleRecharge.getUntellRecharge().clear();
        roleRechargeService.update(roleRecharge);
    }

    @CMD(id = CmdCode._30003)
    public void rechargeLimit(PlayerContext playerContext, RechargeGMsg.GReqRechargeLimitInfo msg) {
        RechargeLimit rechargeLimit = rechargeService.getRechargeLimit();
        if (Objects.isNull(rechargeLimit)) {
            log.debug("rechargeLimit is null");
            playerContext.write(CmdCode._30003, RechargeGMsg.GResRechargeLimitInfo.getDefaultInstance());
            return;
        }
        playerContext.write(CmdCode._30003, rechargeService.getGResRechargeLimitInfo(playerContext.getId(), rechargeLimit));
    }
}
