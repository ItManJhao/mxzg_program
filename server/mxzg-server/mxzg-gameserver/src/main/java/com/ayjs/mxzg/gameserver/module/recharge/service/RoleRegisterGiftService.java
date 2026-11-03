package com.ayjs.mxzg.gameserver.module.recharge.service;

import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.domain.RoleRecharge;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * 玩家注册奖励
 */
@Slf4j
@Service
public class RoleRegisterGiftService implements IRechargeBuyingService {

    @Autowired
    private RoleRechargeService roleRechargeService;
    @Autowired
    ThingService thingService;


    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.REGISTER_GIFT;
    }

    /**
     * 是否可以购买该商品
     *
     * @param rid
     * @param productId
     * @return
     */
    @Override
    public boolean canBuy(long rid, int productId) {
        RoleRecharge roleRecharge = roleRechargeService.getRoleRecharge(rid);
        if (roleRecharge.getRegisterGift().contains(productId)) {
            return false;
        }
        return true;
    }

    /**
     * 成功购买商品
     *
     * @param rid     角色ID
     * @param cBuyGem 商城 商品ID：3000
     * @param isGm
     */
    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {
        RoleRecharge roleRecharge = roleRechargeService.getRoleRecharge(rid);

        List<ImmutableThing> rewards = new ArrayList<>(cBuyGem.getItem());

        if (!roleRecharge.getRegisterGift().contains(cBuyGem.getIdx())) {
            roleRecharge.getRegisterGift().add(cBuyGem.getIdx());
            roleRechargeService.update(roleRecharge);
        }
        thingService.add(rid, rewards, GameEvent.GM_RECHARGE, NoticeType.NORMAL);

    }

}

