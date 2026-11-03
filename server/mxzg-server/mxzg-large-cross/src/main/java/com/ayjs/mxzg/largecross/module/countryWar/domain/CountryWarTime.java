package com.ayjs.mxzg.largecross.module.countryWar.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.largecross.module.countryWar.struct.CountryWarGroup;
import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Getter
@Setter
@Table(name = "country_war_time", comment = "国战积分")
@Slf4j
public class CountryWarTime extends AbstractEntity {

    @Id
    @Column(name = "id", comment = "标识")
    private int id;
    @Column(name = "round", comment = "轮次")
    private int round;
    @Column(name = "had_settle", comment = "是否已结算")
    private boolean hadSettle = true;
    @Column(name = "stage", comment = "当前阶段")
    private int stage = 1;
    @Column(name = "server_2_group", comment = "服务器，组关系",longtext = true)
    private Map<Integer, Integer> server2Group = new ConcurrentHashMap<>();
    @Column(name = "group_data", comment = "组信息", longtext = true)
    private Map<Integer, CountryWarGroup> groupData = new ConcurrentHashMap<>();
    @Column(name = "stage_start_time", comment = "当前阶段开启时间")
    private LocalDateTime stageStartTime = LocalDateTime.of(1970, 1, 1, 0, 0);
    @Column(name = "group_time", comment = "分组时间")
    private LocalDate groupTime = LocalDate.of(1970, 1, 1);
    @Column(name = "group_index", comment = "组索引")
    private int groupIndex;
    @Column(name = "config_idx", comment = "阶段对应的配置")
    private int configIdx;

    public CountryWarGroup addServerToGroup(List<Integer> serverIds) {
        if (serverIds == null || serverIds.size() == 0) {
            return null;
        }
        int groupId = groupIndex++;
        CountryWarGroup group = new CountryWarGroup();
        group.setGroupId(groupId);
        group.getServerIds().addAll(serverIds);
        for (int serverId : serverIds) {
            server2Group.put(serverId, groupId);
        }
        groupData.putIfAbsent(groupId, group);
        return group;
    }

}
