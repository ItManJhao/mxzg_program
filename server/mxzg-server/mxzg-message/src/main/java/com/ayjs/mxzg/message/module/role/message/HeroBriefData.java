package com.ayjs.mxzg.message.module.role.message;

import lombok.Getter;
import lombok.Setter;

/**
 * 英雄简要信息
 */
@Getter
@Setter
public class HeroBriefData {
    private int pos;    //位置
    private int type;    //英雄类型
    private int level;    //英雄等级
    private int star;    //英雄星级
    private long heroId;
    private int fashionId;//皮肤
    private int evolveType;//进化类型
    private int evolveLevel;//进化等级
}
