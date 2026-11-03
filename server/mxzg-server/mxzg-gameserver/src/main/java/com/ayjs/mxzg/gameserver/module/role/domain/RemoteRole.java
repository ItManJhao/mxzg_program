package com.ayjs.mxzg.gameserver.module.role.domain;


import lombok.Value;

@Value
public class RemoteRole {
    /**
     * 角色id
     */
    private long role_id;
    /**
     * user表id,账号的唯一标识
     */
    private int user_id;
    /**
     * 区服务器id
     */
    private int sid;
    /**
     * 角色名
     */
    private String role_name;
    /**
     * 战斗力
     */
    private long fighting;
    /**
     * vip等级
     */
    private int vip;
    /**
     * 等级
     */
    private int level;
    /**
     * 累计充值金额分
     */
    private int total_recharge;
    /**
     * 创建时间
     */
    private int created_at;
    /**
     * 邀请人id
     */
    private long invite_rid;
    /**
     * 最后修改时间
     */
    private int last_update_time;
    /**
     * 头像Id
     */
    private int head_id;
    /**
     * 头像框Id
     */
    private int border_id;
}
