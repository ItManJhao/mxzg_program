package com.ayjs.mxzg.config.struct;

import lombok.Getter;
import lombok.Setter;

/**
 * 图腾信息
 */
@Getter
@Setter
public class TotemsInfo {
    private int sysId;

    private int level;

    private int quality;

    private long rid;

    private long heroId;

    private boolean isOpen;
}
