package com.ayjs.mxzg.cross.module.crossservice.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

@Getter
@Setter
@Entity
@Table(name = "cross_server_group", comment = "跨服分组表")
public class CrossServerGroup extends AbstractEntity {

    @Id
    @Column(name = "id", comment = "主键ID")
    private int id;
    @Column(name = "serial_number", comment = "分组流水号，用来判断跨服是否重组")
    private int serialNumber;
    @Column(name = "groups", comment = "跨服管理的服务器分组列表Map<groupId, 跨服分组>", length = 512)
    private ConcurrentMap<Integer, CrossGroup> groups = new ConcurrentHashMap<>();
    @Column(name = "server_groups", comment = "跨服管理的服务器分组列表Map<groupId, 跨服id>", length = 512)
    private ConcurrentMap<Integer, Integer> serverGroups = new ConcurrentHashMap<>();

    /**
     * 重新设置分组信息
     * @param serialNumber
     * @param groups
     */
    public void reset(int serialNumber, List<CrossGroup> groups) {
        this.groups.clear();
        this.serverGroups.clear();
        for (CrossGroup group : groups) {
            addGroup(group);
        }
        this.serialNumber = serialNumber;
    }

    /**
     * 判断流水号检测是否重组
     * @param serialNumber
     * @return
     */
    public boolean isRegroup(int serialNumber){
        return this.serialNumber != serialNumber;
    }

    /**
     * 添加跨服组
     *
     * @param group
     */
    public void addGroup(CrossGroup group) {
        this.groups.put(group.getGroupId(), group);
        for (Integer serverId : group.getServerIds()) {
            this.serverGroups.put(serverId, group.getGroupId());
        }
    }

    /**
     * 根据服务器id获取跨服组
     * @param serverId
     * @return
     */
    public CrossGroup getGroupByServerId(int serverId) {
        Integer groupId = serverGroups.get(serverId);
        return groupId == null ? null : this.groups.get(groupId);
    }

    /**
     * 根据分组id获取跨服组
     *
     * @param groupId
     * @return
     */
    public CrossGroup getGroupByGroupId(int groupId) {
        return groups.get(groupId);
    }

}
