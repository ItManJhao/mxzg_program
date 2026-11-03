package com.ayjs.mxzg.gameserver.module.adven.struct;

import com.ayjs.mxzg.battle.model.mirror.HeroVo;
import lombok.Getter;
import lombok.Setter;

/**
 * 勇者试炼选择助战数据
 *
 * @Author: CWJ
 * @Date: 2020/2/29
 **/
@Getter
@Setter
public class AdvenSelectAssist {

    /***
     * 英雄数据
     */
    private HeroVo heroVo = new HeroVo();

    /***
     * 玩家id
     */
    private long ownerId;

    /***
     * 是否上过阵
     */
    private boolean hadBattle;

}
