package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.BasePromotionService;
import com.ayjs.mxzg.protocol.Task4GMsg;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

/**
 * 活动接口
 *
 * @Author: CWJ
 * @Date: 2019/10/25
 **/
@Service
@Slf4j
public class ActivityHandler extends ProtocolHandler {

    @CMD(id = CmdCode._13130)
    public void sendActivityInfo(PlayerContext playerContext, Task4GMsg.GReqActivityInfo req) {
        Task4GMsg.GResActivityInfo.Builder builder = Task4GMsg.GResActivityInfo.newBuilder();
        for (Integer typeId : req.getIdxsList()) {
            try {
                PromotionType type = PromotionType.valueOf(typeId);
                Asserts.notNull(type, String.format("不存在该活动类型{%s}", typeId));
                Task4GMsg.PSActivityInfo psActivityInfo = BasePromotionService.getPromotionService(type).sendActivityData(playerContext.getId());
                Asserts.notNull(psActivityInfo, String.format("该活动类型不支持推送数据,type:{%s}", typeId));
                builder.addList(psActivityInfo);
            } catch (Exception e) {
                log.info(String.format("不存在该活动类型{%s}", typeId));
            }
        }
        playerContext.write(CmdCode._13130, builder.build());
    }

    @CMD(id = CmdCode._13131)
    public void rewardActivity(PlayerContext playerContext, Task4GMsg.GReqActivityItemGet req) {
        PromotionType type = PromotionType.valueOf(req.getActivityIdx());
        Asserts.notNull(type, String.format("不存在该活动类型{%s}", req.getActivityIdx()));
        BasePromotionService.getPromotionService(type).getActivityReward(playerContext.getId(), req.getIdx());
    }
}
