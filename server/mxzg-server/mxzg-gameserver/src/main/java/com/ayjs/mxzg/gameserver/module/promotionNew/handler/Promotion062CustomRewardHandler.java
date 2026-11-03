/**
 *
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.gameserver.infrastructure.gm.GMCommand;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.GMCmdCode;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion062CustomReward;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion062CustomRewardService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.CustomRewardData;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion062CustomRewardConfig;
import com.ayjs.mxzg.protocol.Promotion062GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.List;

/**
 *
 */
@Controller
public class Promotion062CustomRewardHandler extends ProtocolHandler {

    @Autowired
    private Promotion062CustomRewardService promotion062CustomRewardService;
    @Autowired
    private PromotionControlService promotionControlService;


    @CMD(id = CmdCode._71001)
    public void getData(PlayerContext playerContext, Promotion062GMsg.GReqCustomRewardData req) {
        promotion062CustomRewardService.sendData(playerContext.getId());
    }

    @CMD(id = CmdCode._71002)
    public void rewardCustom(PlayerContext playerContext, Promotion062GMsg.GReqRewardCustom req) {
        Promotion062CustomReward promotionInfo = promotion062CustomRewardService.getPromotionInfo(playerContext.getId());

        Asserts.isTrue(promotionControlService.isPromotionRunning(PromotionType.CUSTOM), ErrorCode.PROMOTION_NOT_RUNNING.getValue(),
                String.format("活动已关闭{%s}", PromotionType.CUSTOM));

        List<Integer> placeList = new ArrayList<>();
        int productId = 0;
        for (Integer idx : req.getCustomIdsList()) {
            Promotion062CustomRewardConfig config = promotion062CustomRewardService.getConfigById(idx);
            Asserts.isTrue(config != null, ErrorCode.CONFIG_NOT_EXIST.getValue(), String.format("配置不存在{%s}", idx));
            Asserts.isTrue(!placeList.contains(config.getPlace()), ErrorCode.CUSTOM_PLACE_HAD.getValue(),
                    String.format("奖励相同{%s}", config.getPlace()));
            Asserts.isTrue(productId == 0 || productId == config.getProduct_id(), ErrorCode.CUSTOM_PRODUCT_ID_DIFF.getValue(),
                    String.format("奖励对应的配置不一样{%s}", config.getPlace()));
            placeList.add(config.getPlace());
            productId = config.getProduct_id();
        }

        int finalProductId = productId;
        long count = promotion062CustomRewardService.getConfigList().stream().filter(config -> config.getProduct_id() == finalProductId)
                .mapToInt(Promotion062CustomRewardConfig::getPlace).distinct().count();
        Asserts.isTrue(count == placeList.size(), ErrorCode.CUSTOM_PRODUCT_ID_DIFF.getValue(),
                String.format("配置不存在{%s}", JsonUtil.toJson(req.getCustomIdsList())));

        CustomRewardData customRewardData = promotionInfo.getCustomData().get(productId);
        if (customRewardData == null) {
            customRewardData = new CustomRewardData();
            customRewardData.setProductId(productId);
            promotionInfo.getCustomData().put(productId, customRewardData);
        }
        customRewardData.getCustomRewardIds().clear();
        customRewardData.getCustomRewardIds().addAll(req.getCustomIdsList());
        promotion062CustomRewardService.updatePromotion(promotionInfo);

        Promotion062GMsg.GResRewardCustom.Builder builder = Promotion062GMsg.GResRewardCustom.newBuilder();
        Promotion062GMsg.PSCustomData.Builder buyRecord = Promotion062GMsg.PSCustomData.newBuilder();
        buyRecord.setProductId(customRewardData.getProductId());
        buyRecord.addAllCustomRewardId(customRewardData.getCustomRewardIds());
        buyRecord.setBuyCount(customRewardData.getBuyCount());
        builder.setCustomData(buyRecord);

        playerContext.write(CmdCode._71002, builder.build());
    }

    @GMCommand(command = GMCmdCode.CUSTOM_REWARD_CLEAR)
    public void clear(Role role, List<String> param) {
        Promotion062CustomReward promotionInfo = promotion062CustomRewardService.getPromotionInfo(role.getId());
        promotionInfo.getCustomData().clear();
        promotion062CustomRewardService.updatePromotion(promotionInfo);

        promotion062CustomRewardService.sendData(role.getId());
    }


}
