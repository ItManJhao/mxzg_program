package com.ayjs.mxzg.config.struct;

import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2020/7/30
 **/
@Getter
@Setter
public class RuneStoneThing {

    /***
     * 消耗符石类型，0代表无限制
     */
    private int type;

    /***
     * 品质限制，0代表无限制
     */
    private int quality;

    private int intensify;

    private int num;

}
