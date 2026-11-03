/**
 *
 */
package com.ayjs.mxzg.gameserver.module.inviteGift.handler;

import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.ShareCodeUtil;
import com.ayjs.mxzg.config.excel.cache.PromotionInviteSysCache;
import com.ayjs.mxzg.config.excel.entity.CPromotionInvite;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.global.platform.PlatformSupport;
import com.ayjs.mxzg.gameserver.module.inviteGift.domain.InviteGift;
import com.ayjs.mxzg.gameserver.module.inviteGift.service.InviteGiftService;
import com.ayjs.mxzg.gameserver.module.role.domain.RemoteRole;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.web.support.PlatformHttpResult;
import com.ayjs.mxzg.protocol.InviteGiftGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author YY 邀请有礼
 * //TODO 需要完成平台邀请码功能
 */
@Controller
public class InvitationHandler extends ProtocolHandler {

    @Autowired
    private PromotionInviteSysCache promotionInviteSysCache;
    @Autowired
    private InviteGiftService inviteGiftService;
    @Autowired
    private ThingService thingService;

    @Autowired
    private RoleService roleService;
    @Autowired
    private PlatformSupport platformSupport;

    @CMD(id = CmdCode._13082)
    public void inviteInfo(PlayerContext playerContext, InviteGiftGMsg.GReqInvitationList msg) {
        playerContext.write(CmdCode._13082, inviteGiftService.sendData(playerContext.getId()));
    }

    @CMD(id = CmdCode._13083)
    public void inviteReward(PlayerContext playerContext, InviteGiftGMsg.GReqInviteReward msg) {
        // 获得自身邀请码，查询已邀请玩家列表
        CPromotionInvite config = promotionInviteSysCache.getOrThrow(msg.getIdx());
        List<RemoteRole> remoteRoles = roleService.getInviteRoles(playerContext.getId());
        InviteGift entity = inviteGiftService.load(playerContext.getId());
        int count = inviteGiftService.calcCanRewardCount(remoteRoles, config);
        int hadRewardCount = entity.getRewardIds().getOrDefault(config.getIdx(), 0);
        Asserts.isTrue(count > hadRewardCount,
                ErrorCode.INVITE_HAD_REWARD.getValue(), String.format("奖励已经领取count:{%s},maxCount:{%s}",
                        hadRewardCount, count));

        entity.getRewardIds().put(config.getIdx(), hadRewardCount + 1);
        inviteGiftService.update(entity);

        thingService.add(playerContext.getId(), config.getReward(), GameEvent.INVITE_GIFT);

        InviteGiftGMsg.GResInviteReward.Builder builder = InviteGiftGMsg.GResInviteReward.newBuilder();
        InviteGiftGMsg.PSRewardState.Builder rewardStateBuilder = InviteGiftGMsg.PSRewardState.newBuilder();
        rewardStateBuilder.setIdx(config.getIdx());
        rewardStateBuilder.setHadRewardCount(entity.getRewardIds().getOrDefault(config.getIdx(), 0));
        rewardStateBuilder.setMaxRewardCount(count);
        builder.setRewardRecord(rewardStateBuilder);
        playerContext.write(CmdCode._13083, builder.build());

    }

    @CMD(id = CmdCode._13084)
    public void useInviteCode(PlayerContext playerContext, InviteGiftGMsg.GReqInviteUseCode msg) {
        InviteGift entity = inviteGiftService.load(playerContext.getId());
        Asserts.isTrue(entity.getInvitorId() <= 0, ErrorCode.INVITE_CODE_HAD_USED.getValue(), "已经使用过邀请码");

        long inviteId = ShareCodeUtil.codeToId(StringUtils.upperCase(msg.getUseCode()).trim());

        Asserts.isTrue(playerContext.getId() != inviteId, ErrorCode.CAN_NOT_INVITE_YOURSELF.getValue(), "无法邀请自己");

        Map<String, Object> params = new HashMap<>();
        params.put("action", "Platform.setInviteRole");
        params.put("invite_rid", inviteId);
        params.put("role_id", playerContext.getId());
        PlatformHttpResult result = platformSupport.sendToPlatform(params);
        InviteGiftGMsg.GResInviteUseCode.Builder builder = InviteGiftGMsg.GResInviteUseCode.newBuilder();
        if (ConvertUtils.toInt(result.getCode()) == 200) {
            entity.setInvitorId(inviteId);
            builder.setUsedState(1);
        } else {
            inviteGiftService.checkPlatformResult(result.getCode());
            builder.setUsedState(0);
        }
        inviteGiftService.update(entity);

        playerContext.write(CmdCode._13084, builder.build());
    }
}
