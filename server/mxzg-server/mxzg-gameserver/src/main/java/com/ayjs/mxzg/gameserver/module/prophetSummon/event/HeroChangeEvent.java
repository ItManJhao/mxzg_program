package com.ayjs.mxzg.gameserver.module.prophetSummon.event;

import lombok.Value;

/**
 * 英雄置换
 *
 * @Author: CWJ
 * @Date: 2019/10/19
 **/
@Value(staticConstructor = "of")
public class HeroChangeEvent {
    private long rid;
}
