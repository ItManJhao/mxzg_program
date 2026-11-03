package com.ayjs.mxzg.config.struct;

import lombok.Getter;
import lombok.Setter;

/**
 * 装备信息
 *
 * @author meiyc
 */
@Getter
@Setter
public class EquipInfo {

    /**
     * 位置
     */
    private int pos;

    /**
     * 装备id
     */
    private int equipId;

    private int soulLv;
}
