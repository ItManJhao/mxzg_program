package com.ayjs.mxzg.message.module.teamArena.domain;

/**
 * @Author: CWJ
 * @Date: 2020/4/11
 **/
public enum RoleAction {

    /**
     * 报名
     */
    SIGN(1),
    /**
     * 换队伍
     */
    MEMBER_CHANGE_TEAM(1 << 1),
    /**
     * 挑战
     */
    BATTLE(1 << 2),

    /**
     * 获取防守队伍
     */
    GET_DEFEND(1 << 3),
    ;
    private int action;

    RoleAction(int action) {
        this.action = action;
    }

    public int getAction() {
        return action;
    }
}
