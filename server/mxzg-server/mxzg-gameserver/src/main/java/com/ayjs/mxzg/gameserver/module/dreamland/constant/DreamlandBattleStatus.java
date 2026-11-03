package com.ayjs.mxzg.gameserver.module.dreamland.constant;

/**
 * @Author: CWJ
 * @Date: 2019/12/12
 **/
public enum DreamlandBattleStatus {
    /***
     * 未战斗
     */
    NORMAL(1),
    /***
     * 进入下一关
     */
    BATTLE(2),
    /***
     * 选择buff
     */
    SELECT(3),
    ;
    private int value;

    DreamlandBattleStatus(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }
}
