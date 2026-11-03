package com.ayjs.mxzg.gameserver.module.reikiEquip.struct;

import lombok.Getter;
import lombok.Setter;

/**
 * 灵器套装
 * @author hyx
 */
@Getter
@Setter
public class ReikiEquipSuit {

    /**
     * 灵器品质
     */
    private int rare;

   /* *//**
     * 系列套装（用于套装属性向下兼容）
     *//*
    private int suitType;
*/
    /**
     * 激活套装
     */
    private int suitId;

    /**
     * 当前套装装备数量
     */
    private int suitNum;

}
