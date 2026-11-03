package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion068SpaceTimeTreasure;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion068SpaceTimeTreasureService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion068SpacetimeTreasureConfig;
import com.ayjs.mxzg.protocol.promotion068GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @author hyx
 */
@Controller
public class Promotion068SpaceTimeTreasureHandler extends ProtocolHandler {

    @Autowired
    private Promotion068SpaceTimeTreasureService promotion068SpaceTimeTreasureService;
    @Autowired
    private PromotionControlService promotionControlService;

    @CMD(id = CmdCode._13290)
    public void sendPromotionInfo(PlayerContext playerContext, promotion068GMsg.GReqSpaceTimeTreasureInfo msg) {

        Promotion068SpaceTimeTreasure promotion = promotion068SpaceTimeTreasureService.getPromotionInfo(playerContext.getId());

        promotion068GMsg.GResSpaceTimeTreasureInfo.Builder builder = promotion068GMsg.GResSpaceTimeTreasureInfo.newBuilder();
        builder.setDay(promotion068SpaceTimeTreasureService.getDay());
        builder.setStatus(promotion.getIdxList().isEmpty() ? 0 : 1);
        builder.addAllIdxList(promotion.getIdxList());

        playerContext.write(CmdCode._13290, builder.build());
    }

    @CMD(id = CmdCode._13291)
    public void chooseItem(PlayerContext playerContext, promotion068GMsg.GReqChooseItem msg) {
        Asserts.isTrue(promotionControlService.isPromotionRunning(PromotionType.SHI_KONG_YI_DAO),
                ErrorCode.PROMOTION_NOT_RUNNING.getValue(), "活动已结束");

        Promotion068SpaceTimeTreasure promotion = promotion068SpaceTimeTreasureService.getPromotionInfo(playerContext.getId());
        Asserts.isTrue(promotion.getChooseTime() == 0, ErrorCode.SPACE_TIME_TREASURE_CHOOSE.getValue(), "当天的时空异宝道具已选择");

        List<Integer> idxList = new ArrayList<>();
        Map<Integer, Promotion068SpacetimeTreasureConfig> configMap = promotion068SpaceTimeTreasureService.getConfigMap();
        for (int idx : msg.getIdxListList()) {
            Asserts.isTrue(configMap.containsKey(idx), ErrorCode.SPACE_TIME_TREASURE_CONFIG_NOT.getValue(),
                    String.format("今天不存在该配置可以选择，day:{%s},idx:{%S}", promotion068SpaceTimeTreasureService.getDay(), idx));
            Asserts.isTrue(!idxList.contains(idx), ErrorCode.SPACE_TIME_TREASURE_CONFIG_REPEAT.getValue(),
                    "不能重复选择一个奖励");
            idxList.add(idx);
        }
        promotion.setChooseTime(DateTimeUtil.currentSecond());
        promotion.getIdxList().addAll(idxList);
        promotion068SpaceTimeTreasureService.update(promotion);

        promotion068GMsg.GResChooseItem.Builder builder = promotion068GMsg.GResChooseItem.newBuilder();
        builder.setStatus(1);
        builder.addAllIdxList(promotion.getIdxList());
        playerContext.write(CmdCode._13291, builder.build());

    }
}
