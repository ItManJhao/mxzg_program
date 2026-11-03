package com.ayjs.mxzg.gameserver.module.tower.event;

import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2019/11/14
 **/
@Value(staticConstructor = "of")
public class TowerChallengeEvent {
    private long rid;
    
    private int stage;
    private boolean isWin;
    private int fighting;
    private int level;
}
