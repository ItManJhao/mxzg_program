package com.ayjs.mxzg.gameserver.module.inviteGift.service;

import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.ShareCodeUtil;
import com.ayjs.mxzg.config.excel.cache.PromotionInviteSysCache;
import com.ayjs.mxzg.config.excel.entity.CPromotionInvite;
import com.ayjs.mxzg.gameserver.module.inviteGift.dao.InviteGiftDao;
import com.ayjs.mxzg.gameserver.module.inviteGift.domain.InviteGift;
import com.ayjs.mxzg.gameserver.module.inviteGift.struct.InviteCodeType;
import com.ayjs.mxzg.gameserver.module.role.domain.RemoteRole;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.protocol.InviteGiftGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;

/**
 * @Author: CWJ
 * @Date: 2019/11/21
 **/
@Service
public class InviteGiftService {

    @Autowired
    private InviteGiftDao inviteGiftDao;
    @Autowired
    private RoleService roleService;
    @Autowired
    private PromotionInviteSysCache promotionInviteSysCache;

    public InviteGift load(long rid) {
        InviteGift inviteGift = inviteGiftDao.get(rid);
        if (inviteGift == null) {
            inviteGift = new InviteGift();
            inviteGift.setRid(rid);
            inviteGiftDao.add(inviteGift);
        }
        return inviteGift;
    }

    public InviteGiftGMsg.GResInvitationList sendData(long rid) {
        // 获得自身邀请码，查询已邀请玩家列表
        List<RemoteRole> remoteRoles = roleService.getInviteRoles(rid);
        if (Objects.isNull(remoteRoles)) {
            return InviteGiftGMsg.GResInvitationList.getDefaultInstance();
        }

        InviteGiftGMsg.GResInvitationList.Builder builder = InviteGiftGMsg.GResInvitationList.newBuilder();
        remoteRoles.forEach(remoteRole -> {
            InviteGiftGMsg.PSInvitationData.Builder invitationBuilder = InviteGiftGMsg.PSInvitationData.newBuilder();
            invitationBuilder.setRoleId(remoteRole.getRole_id());
            invitationBuilder.setName(remoteRole.getRole_name());
            invitationBuilder.setLevel(remoteRole.getLevel());
            invitationBuilder.setPower((int) remoteRole.getFighting());
            invitationBuilder.setLastOperatorTime(remoteRole.getLast_update_time());
            invitationBuilder.setHeadId(remoteRole.getHead_id());
            invitationBuilder.setBorderId(remoteRole.getBorder_id());
            builder.addRoleList(invitationBuilder);
        });
        InviteGift entity = load(rid);
        promotionInviteSysCache.getAll().forEach(config -> {
            InviteGiftGMsg.PSRewardState.Builder rewardStateBuilder = InviteGiftGMsg.PSRewardState.newBuilder();
            rewardStateBuilder.setIdx(config.getIdx());
            rewardStateBuilder.setHadRewardCount(entity.getRewardIds().getOrDefault(config.getIdx(), 0));
            rewardStateBuilder.setMaxRewardCount(calcCanRewardCount(remoteRoles, config));
            builder.addRewardRecord(rewardStateBuilder);
        });

        builder.setInviteCode(ShareCodeUtil.toDynamicsCode(rid));
        builder.setUsed(entity.getInvitorId() > 0 ? 1 : 0);
        return builder.build();
    }

    public int calcCanRewardCount(List<RemoteRole> remoteRoles, CPromotionInvite config) {
        if (config.getType() == 1) {
            return Math.min((int) remoteRoles.stream().filter(remoteRole -> remoteRole.getFighting() >= config.getNum()).count(),
                    config.getGain_limit());
        } else {
            return Math.min((int) remoteRoles.stream().filter(remoteRole -> remoteRole.getTotal_recharge() >= config.getNum()).count(),
                    config.getGain_limit());
        }

    }

    public void update(InviteGift entity) {
        inviteGiftDao.update(entity);
    }

    // 根据错误码细分错误
    public void checkPlatformResult(int code) {
        ErrorCode errorCode = null;
        if (code == InviteCodeType.INVITEES_EMPTY) {
            errorCode = ErrorCode.INVITEES_CAN_NOT_EMPTY;
        } else if (code == InviteCodeType.BE_INVITEES_EMPTY) {
            errorCode = ErrorCode.BE_INVITEES_CAN_NOT_EMPTY;
        } else if (code == InviteCodeType.INVITEES_NOT_EXIST) {
            errorCode = ErrorCode.INVITEES_IS_NOT_EXIST;
        } else if (code == InviteCodeType.BE_INVITEES_NOT_EXIST) {
            errorCode = ErrorCode.BE_INVITEES_IS_NOT_EXIST;
        } else if (code == InviteCodeType.CODE_INVALID) {
            errorCode = ErrorCode.INVITE_CODE_HAD_USED;
        } else if (code == InviteCodeType.MUTUAL_INVITATION) {
            errorCode = ErrorCode.CAN_NOT_MUTUAL_INVITATION;
        }

        if (Objects.nonNull(errorCode)) {
            Asserts.isTrue(false, errorCode.getValue(), errorCode.getDesc());
        }
    }
}
