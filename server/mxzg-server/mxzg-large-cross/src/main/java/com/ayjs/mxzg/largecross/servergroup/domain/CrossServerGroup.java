package com.ayjs.mxzg.largecross.servergroup.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

/**
 * @Author: CWJ
 * @Date: 2020/6/18
 **/
@Getter
@Setter
@Entity
@Table(name = "cross_cluster", comment = "跨服组信息表")
public class CrossServerGroup extends AbstractEntity {
    @Id
    @Column(name = "id", comment = "主键ID")
    private int id;
    @Column(name = "assignation", comment = "是否分配了跨服")
    private boolean assignation;
    @Column(name = "serial_number", comment = "分组流水号，用来判断跨服是否重组")
    private int serialNumber;
    @Column(name = "groups", comment = "跨服分组列表Map<groupId, 分组>", length = 32768 )
    private ConcurrentMap<Integer, CrossGroup> groups = new ConcurrentHashMap<>();
    @Column(name = "server_group", comment = "服务器分组映射Map<服务器id, 分组Id>", length = 32768)
    private ConcurrentMap<Integer, Integer> serverGroup = new ConcurrentHashMap<>();
    @Column(name = "regrouping_time", comment = "下次重新分组的时间")
    private LocalDateTime regroupingTime = LocalDateTime.now();

    /**
     * 重新设置分组信息
     * @param serialNumber
     * @param groups
     */
    public void reset(int serialNumber, List<CrossGroup> groups) {
        this.groups.clear();
        this.serverGroup.clear();
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
            this.serverGroup.put(serverId, group.getGroupId());
        }
    }

    /**
     * 根据服务器id获取跨服组
     * @param serverId
     * @return
     */
    public CrossGroup getGroupByServerId(int serverId) {
        Integer groupId = serverGroup.get(serverId);
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
