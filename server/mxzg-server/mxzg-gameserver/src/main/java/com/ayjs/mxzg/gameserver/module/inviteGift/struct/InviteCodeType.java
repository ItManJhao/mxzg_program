package com.ayjs.mxzg.gameserver.module.inviteGift.struct;

/**
 * 邀请码错误类型
 */
public class InviteCodeType {
    // 邀请人为空
    public static final int INVITEES_EMPTY = 1;
    // 被邀请人为空
    public static final int BE_INVITEES_EMPTY = 2;
    // 邀请人不存在
    public static final int INVITEES_NOT_EXIST = 3;
    // 被邀请人不存在
    public static final int BE_INVITEES_NOT_EXIST = 4;
    // 邀请人已经邀请过别人
    public static final int CODE_INVALID = 5;
    // 邀请自己
    public static final int MUTUAL_INVITATION = 6;
}
