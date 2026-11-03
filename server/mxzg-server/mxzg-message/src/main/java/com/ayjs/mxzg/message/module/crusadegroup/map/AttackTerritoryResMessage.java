package com.ayjs.mxzg.message.module.crusadegroup.map;

import com.ayjs.mxzg.message.largecross.CrusadeGroupMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.dto.TerritoryGarrison;
import lombok.Getter;
import lombok.Setter;

import java.util.Collections;
import java.util.List;
import java.util.Set;

/**
 * 攻击领地返回
 */
@Getter
@Setter
public class AttackTerritoryResMessage implements CrusadeGroupMessage {

    private int territoryId;    //领地id
    private boolean occupied;     //是否被占领了，被占领了则需要重新刷新数据
    private List<TerritoryGarrison> garrisons;        //驻军列表
    private int refreshCountdown;   //刷新倒计时（单位：秒）
    private int guardTime;  //保护时间
    private String challengerName;  //挑战者名字
    private int element; //可以驻守的元素
    private int star;   //可以驻守的英雄星级
    private Set<Long> deadHeroIds;

    public List<TerritoryGarrison> getGarrisons(){
        return this.garrisons == null ? Collections.emptyList() : this.garrisons;
    }

    public Set<Long> getDeadHeroIds(){
        return this.deadHeroIds == null ? Collections.emptySet() : this.deadHeroIds;
    }
}
