package com.ayjs.mxzg.center.module.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.message.center.dto.GroupType;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(name = "server_info", comment = "服务器信息列表")
public class ServerInfo extends AbstractEntity implements Comparable<ServerInfo> {

    @Id
    @Column(name = "id", comment = "服务器id")
    private int id;
    @Column(name = "world_level", comment = "世界等级")
    private int worldLevel;
    @Column(name = "active_players_number", comment = "活跃玩家数量")
    private int activePlayersNumber;
    @Column(name = "group_type", comment = "分组类型")
    private int groupType;
    @Column(name = "open_server_time", comment = "开服时间")
    private LocalDateTime openServerTime;
    @Column(name = "update_time", comment = "开服时间")
    private LocalDateTime updateTime;

    public static ServerInfo of(int id, int worldLevel, int activePlayersNumber, int groupType, LocalDateTime openServerTime){
        ServerInfo serverInfo = new ServerInfo();
        serverInfo.setId(id);
        serverInfo.setWorldLevel(worldLevel);
        serverInfo.setActivePlayersNumber(activePlayersNumber);
        serverInfo.setGroupType(groupType);
        serverInfo.setOpenServerTime(openServerTime);
        serverInfo.setUpdateTime(LocalDateTime.now());
        return serverInfo;
    }

    /**
     * 是否是老服
     *
     * @return
     */
    public boolean isOldServer() {
        return groupType == GroupType.OLD_SERVER.ordinal();
    }

    /**
     * 更新服务器信息
     * @param worldLevel
     * @param activePlayersNumber
     * @param groupType
     * @param openServerTime
     */
    public void update(int worldLevel, int activePlayersNumber, GroupType groupType, LocalDateTime openServerTime){
        this.worldLevel = worldLevel;
        this.activePlayersNumber = activePlayersNumber;
        this.groupType = groupType.ordinal();
        this.openServerTime = openServerTime;
        this.updateTime = LocalDateTime.now();
    }

    /**
     * 获取分组类型
     * @return
     */
    public GroupType getGroupType(){
        return GroupType.values()[this.groupType];
    }


    @Override
    public int compareTo(ServerInfo o) {
        return Integer.compare(o.getWorldLevel(), this.getWorldLevel());
    }

}
