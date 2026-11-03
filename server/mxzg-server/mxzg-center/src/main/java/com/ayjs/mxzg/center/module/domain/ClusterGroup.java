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
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.concurrent.atomic.AtomicInteger;

@Getter
@Setter
@Entity
@Table(name = "cluster_group", comment = "跨服分组表")
public class ClusterGroup extends AbstractEntity {

    @Id
    @Column(name = "id", comment = "分组ID")
    private int id;
    @Column(name = "full", comment = "分组是否满了")
    private boolean full;
    @Column(name = "cross_server_id", comment = "分配的跨服id")
    private int crossServerId;
    @Column(name = "group_type", comment = "跨服类型0新服，1旧服")
    private GroupType groups;
    @Column(name = "server_group", comment = "服务器id列表", length = 512)
    private Set<Integer> serverIds = new HashSet<>();
    @Column(name = "regrouping_time", comment = "下次重新分组的时间")
    private LocalDateTime regroupingTime = LocalDateTime.now();

    /**
     * 重置
     */
    public void reset() {
//        this.assignation = true;
//        this.serialNumber = (int)(System.currentTimeMillis()/1000);
//        this.groups.clear();
//        this.serverGroup.clear();
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
//        this.groups.put(group.getGroupId(), group);
//        for (int serverId : group.getServerIds()) {
//            this.serverGroup.put(serverId, group.getGroupId());
//        }
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
//        return this.groups.values().stream().filter(group-> group.isType(groupType) && !group.isFull()).findFirst();
        return null;
    }

    /**
     * 根据服务器id获取跨服组
     *
     * @param serverId
     * @return
     */
    public CrossGroup getServerCrossGroup(int serverId) {
//        Integer groupId = this.serverGroup.get(serverId);
//        return groupId == null ? null : this.groups.get(groupId);
        return null;
    }

    /**
     * 根据跨服id获取跨服分组列表
     *
     * @param crossId
     * @return
     */
    public List<CrossGroup> getCrossGroups(int crossId) {
//        return this.groups.values().stream().filter(group -> group.getCrossServerId() == crossId).collect(Collectors.toList());
        return null;
    }

    /**
     * 获取最大的分组id
     * @return
     */
    public int getMaxGroupId(){
//        return this.groups.keySet().stream().mapToInt(Integer::intValue).max().orElse(0);
        return 0;
    }

}
