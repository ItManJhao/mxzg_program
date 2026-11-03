package com.ayjs.mxzg.message.module.teamArena.domain;

/**
 * @Author: CWJ
 * @Date: 2020/4/11
 **/
public enum TeamArenaState {

    /**
     * 休战阶段
     */
    OVER(1),
    /**
     * 组队阶段
     */
    TEAM(2, RoleAction.MEMBER_CHANGE_TEAM, RoleAction.SIGN),
    /**
     * 挑战阶段
     */
    CHALLENGE(3, RoleAction.MEMBER_CHANGE_TEAM, RoleAction.SIGN, RoleAction.BATTLE, RoleAction.GET_DEFEND),
    /**
     * 结算阶段
     */
    SETTLE(4);

    private static TeamArenaState[] states = null;

    static {
        states = new TeamArenaState[TeamArenaState.values().length];
        for (TeamArenaState state : TeamArenaState.values()) {
            states[state.getState() - 1] = state;
        }
    }


    private int state;

    private int roleAction;

    TeamArenaState(int state, RoleAction... roleActions) {
        this.state = state;
        if (roleActions != null) {
            for (RoleAction roleAction : roleActions) {
                this.roleAction |= roleAction.getAction();
            }
        }
    }

    public TeamArenaState nextState() {
        return states[(this.getState()) % states.length];
    }

    public static TeamArenaState stateOf(int state) {
        return states[state - 1];
    }

    public int getState() {
        return state;
    }

    public boolean canAction(RoleAction action) {
        return (roleAction & action.getAction()) > 0;
    }

}
