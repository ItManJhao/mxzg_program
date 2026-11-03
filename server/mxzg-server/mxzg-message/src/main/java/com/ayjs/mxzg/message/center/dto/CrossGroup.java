package com.ayjs.mxzg.message.center.dto;

import cn.hutool.core.util.RandomUtil;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

/**
 * 跨服分组
 */
@Getter
@Setter
public class CrossGroup {

    /**
     * 分组id
     */
    private int groupId;

    /**
     * 跨服服务器id
     */
    private int crossServerId;

    /**
     * 分组类型
     */
    private GroupType groupType;

    /**
     * 是否满了
     */
    private boolean full;

    /**
     * 服务器id列表
     */
    private Set<Integer> serverIds = new HashSet<>();

    public static CrossGroup createOf(int groupId, int crossServerId, boolean full, GroupType groupType, Collection<Integer> serverIds) {
        CrossGroup crossGroup = new CrossGroup();
        crossGroup.setGroupId(groupId);
        crossGroup.setGroupType(groupType);
        crossGroup.setFull(full);
        crossGroup.setCrossServerId(crossServerId);
        crossGroup.getServerIds().addAll(serverIds);
        return crossGroup;
    }

    /**
     * 加入一个服务器
     *
     * @param serverId
     */
    public void joinServer(int serverId) {
        this.serverIds.add(serverId);
    }

    /**
     * 分组是否未满员
     *
     * @return
     */
    public boolean isNotFull(int maxServerMember) {
        return this.serverIds.size() < maxServerMember;
    }

    /**
     * 是否是指定的服务器组类型
     * @param groupType
     * @return
     */
    public boolean isType(GroupType groupType){
        return this.groupType == groupType;
    }


    /**
     * 随机一个服务器id
     * @return
     */
    public int randomServerId(){
        return RandomUtil.randomEle(new ArrayList<>(this.serverIds));
    }

}
