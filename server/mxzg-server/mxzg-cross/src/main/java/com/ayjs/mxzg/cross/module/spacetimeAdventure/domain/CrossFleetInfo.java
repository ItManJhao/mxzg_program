package com.ayjs.mxzg.cross.module.spacetimeAdventure.domain;

import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.Map;


/**
 * @author hyx
 */
@Table(name = "cross_fleet_info", comment = "时空冒险航行英雄阵容数据")
@Getter
@Setter
@Entity
public class CrossFleetInfo extends AbstractEntity {

    @Id
    @Column(name = "rid", comment = "角色id")
    private long rid;
    @Column(name = "server_id", comment = "服务器id")
    private int serverId;
    @Column(name = "nick", length = 128, comment = "昵称")
    private String nick = "";
    @Column(name = "max_fighting", comment = "历史最大战力")
    private int maxFighting;
    @Column(name = "battle_vo_map", comment = "上阵英雄vo")
    private Map<Integer, BattlerVo> battlerVoMap = new HashMap<>();
}
