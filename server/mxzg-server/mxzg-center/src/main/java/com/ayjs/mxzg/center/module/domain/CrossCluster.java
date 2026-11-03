package com.ayjs.mxzg.center.module.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.center.dto.GroupType;
import com.google.common.collect.Lists;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

@Getter
@Setter
@Entity
@Table(name = "cross_cluster", comment = "跨服集群表")
public class CrossCluster extends AbstractEntity {

    @Id
    @Column(name = "id", comment = "主键ID")
    private int id;
    @Column(name = "assignation", comment = "是否分配了跨服")
    private boolean assignation;
    @Column(name = "serial_number", comment = "分组流水号，用来判断跨服是否重组")
    private int serialNumber;
    @Column(name = "groups", comment = "跨服分组列表Map<groupId, 分组>", length = 512)
    private ConcurrentMap<Integer, CrossGroup> groups = new ConcurrentHashMap<>();
    @Column(name = "server_group", comment = "服务器分组映射Map<服务器id, 分组Id>", length = 512)
    private ConcurrentMap<Integer, Integer> serverGroup = new ConcurrentHashMap<>();
    @Column(name = "regrouping_time", comment = "下次重新分组的时间")
    private LocalDateTime regroupingTime = LocalDateTime.now();

    /**
     * 重置
     */
    public void reset() {
        this.assignation = true;
        this.serialNumber = (int)(System.currentTimeMillis()/1000);
        this.groups.clear();
        this.serverGroup.clear();
    }

    /**
     * 添加分组
     *
     * @param crossGroups
     */
    public void addGroups(Collection<CrossGroup> crossGroups) {
        for (CrossGroup group : crossGroups) {
            addGroup(group);
        }
    }

    /**
     * 添加跨服组
     *
     * @param group
     */
    private void addGroup(CrossGroup group) {
        this.groups.put(group.getGroupId(), group);
        for (int serverId : group.getServerIds()) {
            this.serverGroup.put(serverId, group.getGroupId());
        }
    }

    /**
     * 加入游戏服到分组
     * @param serverInfo
     * @param groupIdBuilder
     * @param crossServerId
     * @return
     */
    public CrossGroup joinToGroup(ServerInfo serverInfo, AtomicInteger groupIdBuilder, int crossServerId) {
        CrossGroup joinGroup = null;
        Optional<CrossGroup> underFullGroup = getUnderFullGroupBy(serverInfo.getGroupType());
        if(underFullGroup.isPresent()){
            joinGroup = underFullGroup.get();
        } else {
            joinGroup = CrossGroup.createOf(groupIdBuilder.getAndIncrement(), crossServerId, false, serverInfo.getGroupType(), Lists.newArrayList());
        }
        joinGroup.joinServer(serverInfo.getId());
        addGroup(joinGroup);
        return joinGroup;
    }

    /**
     * 根据分组类型获取一个未满的分组，
     * @param groupType
     * @return
     */
    private Optional<CrossGroup> getUnderFullGroupBy(GroupType groupType){
        return this.groups.values().stream().filter(group-> group.isType(groupType) && !group.isFull()).findFirst();
    }

    /**
     * 根据服务器id获取跨服组
     *
     * @param serverId
     * @return
     */
    public CrossGroup getServerCrossGroup(int serverId) {
        Integer groupId = this.serverGroup.get(serverId);
        return groupId == null ? null : this.groups.get(groupId);
    }

    /**
     * 根据跨服id获取跨服分组列表
     *
     * @param crossId
     * @return
     */
    public List<CrossGroup> getCrossGroups(int crossId) {
        return this.groups.values().stream().filter(group -> group.getCrossServerId() == crossId).collect(Collectors.toList());
    }

    /**
     * 获取最大的分组id
     * @return
     */
    public int getMaxGroupId(){
        return this.groups.keySet().stream().mapToInt(Integer::intValue).max().orElse(0);
    }

}
