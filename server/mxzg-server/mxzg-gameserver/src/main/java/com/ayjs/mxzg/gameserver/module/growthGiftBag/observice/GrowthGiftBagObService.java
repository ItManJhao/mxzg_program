package com.ayjs.mxzg.gameserver.module.growthGiftBag.observice;


import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.growthGiftBag.service.GrowthGiftService;
import com.ayjs.mxzg.gameserver.module.recharge.domain.RoleRecharge;
import com.ayjs.mxzg.gameserver.module.recharge.event.RechargeEvent;
import com.ayjs.mxzg.gameserver.module.recharge.service.RoleRechargeService;
import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;
import com.ayjs.mxzg.protocol.PromotionGMsg;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * 成长礼包充值事件监听
 */
@Observer
@Slf4j
public class GrowthGiftBagObService {

    @Autowired
    private RoleRechargeService roleRechargeService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private GrowthGiftService growthGiftService;

    /**
     * 成长礼包充值额度更新
     */
    @Subscribe
    public void growthGiftBagChargeEvent(RechargeEvent event) {
        //有充值变动时，更新前端成长礼包界面显示充值额度
        PromotionGMsg.GResGrowthGiftCharge.Builder builder = PromotionGMsg.GResGrowthGiftCharge.newBuilder();
        RoleRecharge roleRecharge = roleRechargeService.getRoleRecharge(event.getRid());
        builder.setChargeCount(roleRecharge.getTotalRecharge() );
        contextManager.write(event.getRid(), CmdCode._20019,builder.build());
    }

    /**
            * 成长礼包列表1
     * @param event
     */
    @Subscribe
    public void getVipBuyRewardList(LoginEvent event){
        growthGiftService.vipBuyRewardList(event.getRid());
    }
}
