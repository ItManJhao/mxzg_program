package com.ayjs.mxzg.cross.module.crusadegroup.map.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.cross.module.crusadegroup.group.domain.CrossCrusadeGroup;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

@Entity
@Table(name = "cross_crusade_group_map", comment = "跨服讨贼团地图")
@Getter
@Setter
public class CrossCrusadeGroupMap extends AbstractEntity {

    @Id
    @Column(name = "id", comment = "地图id")
    private int id;

    @Column(name = "groupIds", comment = "讨伐团id列表")
    private Set<Integer> groupIds = new HashSet<>();

    @Column(name = "server_id", comment = "服务器id列表")
    private Set<Integer> server_id = new HashSet<>();

    @Column(name = "role_id", comment = "所有玩家id", length = 4096)
    private Set<Long> roleId = new HashSet<>();

    @Column(name = "occupied_id", comment = "被占领的格子列表", longtext = true)
    private ConcurrentMap<Integer, Long> occupiedId = new ConcurrentHashMap<>();

    @Column(name = "reclaim_id", comment = "开垦的id列表", longtext = true)
    private Set<Integer> reclaimId = new HashSet<>();

    @Column(name = "npc_forces", comment = "战斗中的npc信息", longtext = true)
    private ConcurrentMap<Integer, NpcForce> npcForces = new ConcurrentHashMap<>();

    @Column(name = "last_regroup_time", comment = "上次重组的时间")
    private LocalDateTime lastRegroupTime = LocalDateTime.now();

    public static CrossCrusadeGroupMap createOf(int mapId, CrossCrusadeGroup liftGroup, CrossCrusadeGroup rightGroup){
        CrossCrusadeGroupMap map = new CrossCrusadeGroupMap();
        map.setId(mapId);
        map.addGroup(liftGroup);
        map.addGroup(rightGroup);
        return map;
    }

    /**
     * 添加分组信息
     * @param group
     */
    private void addGroup(CrossCrusadeGroup group){
        if(group == null){
            return;
        }
        this.roleId.addAll(group.getMembers());
        this.groupIds.add(group.getId());
        this.server_id.addAll(group.getServer_id());
    }

    /**
     * 根据领地id获取占领者
     * @return
     */
    public Long getOccupiedId(int territoryId){
        return this.occupiedId.getOrDefault(territoryId, 0L);
    }

    /**
     * 指定的领地是否被占领
     * @param territoryId
     * @return
     */
    public boolean isOccupied(int territoryId){
        return this.occupiedId.containsKey(territoryId);
    }

    /**
     * 占领领地
     * @param rid
     * @param territoryId
     * @param boss
     */
    public void occupiedTerritory(long rid, int territoryId, boolean boss){
        this.occupiedId.put(territoryId, rid);
        if(!boss){
            this.npcForces.remove(territoryId);
        }
    }

    /**
     * 放弃领地
     * @param territoryId
     */
    public void giveUpTerritory(int territoryId){
        this.occupiedId.remove(territoryId);
    }

    /**
     * 开垦领地
     * @param territoryId
     */
    public void reclaimTerritory(int territoryId, long heroId){
        if(heroId == 0){
            unReclaimTerritory(territoryId);
        } else {
            this.reclaimId.add(territoryId);
        }
    }

    /**
     * 取消开垦
     * @param territoryId
     */
    public void unReclaimTerritory(int territoryId){
        this.reclaimId.remove(territoryId);
    }


    /**
     * 添加npc部队
     * @param npcForce
     */
    public void addNpcForce(NpcForce npcForce){
        this.npcForces.put(npcForce.getId(), npcForce);
    }

    /**
     * 获取npc部队信息
     * @param territoryId
     * @return
     */
    public NpcForce getNpcForce(int territoryId){
        NpcForce npcForce = this.npcForces.get(territoryId);
        if(npcForce == null){
            return null;
        } else if(npcForce.isRefresh()){
            this.npcForces.remove(territoryId);
            npcForce = null;
        }

        if(npcForce.isProtectionTimeout()){
            npcForce.setChallengerId(0);
            npcForce.setChallengerId(0);
        }
        return npcForce;
    }

    /**
     * 是否开垦中
     * @param territoryId
     * @return
     */
    public boolean isReclaim(int territoryId){
        return this.reclaimId.contains(territoryId);
    }

}
