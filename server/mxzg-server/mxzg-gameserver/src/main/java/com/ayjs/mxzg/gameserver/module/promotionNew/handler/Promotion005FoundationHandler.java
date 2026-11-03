package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.exception.ErrorCodeException;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.config.excel.cache.PromotionFoundAtionSysCache;
import com.ayjs.mxzg.config.excel.entity.CPromotionFoundAtion;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ItemType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion005Foundation;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion005FoundationService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.PromotionGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2019/10/24
 **/
@Component
public class Promotion005FoundationHandler extends ProtocolHandler {

    @Autowired
    private PromotionFoundAtionSysCache promotionFoundAtionSysCache;

    @Autowired
    RoleService roleService;
    @Autowired
    ThingService thingService;
    @Autowired
    private Promotion005FoundationService promotion005FoundationService;

    private static final int HAD_REWARD_STATE = 1;

    @CMD(id = CmdCode._20001)
    public void promotionList(PlayerContext playerContext, PromotionGMsg.GReqPromotionList req) {
        long rid = playerContext.getId();
        Promotion005Foundation foundation = promotion005FoundationService.get(rid);
        PromotionGMsg.GResPromotionList.Builder builder = PromotionGMsg.GResPromotionList.newBuilder();
        builder.setIsBuyFoundation(foundation.isHadBuy() ? 1 : 0);
        foundation.getRewardIds().forEach(rewardId -> {
            ObjectGMsg.PSMapData.Builder status = ObjectGMsg.PSMapData.newBuilder();
            status.setKey(rewardId);
            status.setValue(1);
            builder.addFoundationRewardRecord(status.build());
        });
        playerContext.write(CmdCode._20001, builder.build());
    }

    @CMD(id = CmdCode._20018)
    public void rewardFoundation(PlayerContext playerContext, PromotionGMsg.GReqFoundationReward req) {
        long rid = playerContext.getId();
        int idx = req.getIdx();
        CPromotionFoundAtion config = promotionFoundAtionSysCache.getOrThrow(idx);
        if (config == null) {
            throw new ErrorCodeException(ErrorCode.CONFIG_NOT_EXISTS.getValue(), "配置不存在");
        }
        Role role = roleService.getOrThrow(rid);
        if (role.getLevel() < config.getLevel()) {
            throw new ErrorCodeException(ErrorCode.ROLE_LEVEL_LOW.getValue(), "等级不足");
        }
        Promotion005Foundation foundation = promotion005FoundationService.get(rid);
        if (!foundation.isHadBuy()) {
            throw new ErrorCodeException(ErrorCode.FOUNDATION_NOT_BUY.getValue(), "基金未购买");
        }

        foundation.getRewardIds().add(idx);
        promotion005FoundationService.update(foundation);

        thingService.add(role.getId(), ImmutableThing.of(ItemType.IT_GEM, config.getItem_one() + config.getItem_two()), GameEvent.PROMOTION_FOUND);
        playerContext.write(CmdCode._20018, PromotionGMsg.GResFoundationReward.newBuilder().build());
    }

}
