package com.ayjs.mxzg.gameserver.module.tower.event;

import com.ayjs.mxzg.gameserver.module.tower.domain.TowerRaiders;
import lombok.Value;

/**
 * 通关幻境之塔次数
 *
 * @Author: CWJ
 * @Date: 2019/10/19
 **/
@Value(staticConstructor = "of")
public class TowerPassEvent {
    private long rid;
    /**
     * 新的爬塔层数
     */
    private int newStage;

    /**
     * 通关的攻略
     */
    private TowerRaiders stageRaiders;

}
