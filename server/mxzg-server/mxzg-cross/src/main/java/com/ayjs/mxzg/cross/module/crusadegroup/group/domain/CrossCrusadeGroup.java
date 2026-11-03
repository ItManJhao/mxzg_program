package com.ayjs.mxzg.cross.module.crusadegroup.group.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import lombok.Getter;
import lombok.Setter;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Entity
@Table(name = "cross_crusade_group", comment = "跨服讨贼团")
@Getter
@Setter
public class CrossCrusadeGroup extends AbstractEntity {

    @Id
    @Column(name = "id", comment = "唯一ID")
    private int id;

    @Column(name = "group_name", comment = "讨伐团名称")
    private String groupName = "";

    @Column(name = "rename_number", comment = "修改名称的次数")
    private int renameNumber;

    @Column(name = "emblem", comment = "团徽")
    private int emblem;

    @Column(name = "map_id", comment = "地图id")
    private int mapId;

    @Column(name = "head_id", comment = "团长id")
    private long headId;

    @Column(name = "commander_id", comment = "指挥官id")
    private Set<Long> commander = new HashSet<>();

    @Column(name = "server_id", comment = "服务器id列表")
    private Set<Integer> server_id = new HashSet<>();

    @Column(name = "members", comment = "所有玩家id")
    private Set<Long> members = new HashSet<>();

    @Column(name = "shenBin_all", comment = "团内获得精华总数")
    private long shenBinAll;

    @Column(name = "shenBin_update_time", comment = "神兵精华数量修改时间")
    private int shenBinUpdateTime;

    @Column(name = "bossHurt_all", comment = "boss伤害总数")
    private long bossHurtAll;

    @Column(name = "bossHurt_update_time", comment = "boss伤害修改时间")
    private int bossHurtUpdateTime;

    /**
     * 创建对象
     * @param serverInfos
     * @return
     */
    public static CrossCrusadeGroup createOf(int id, List<ServerInfo> serverInfos){
        Set<Long> membersId = serverInfos.stream().flatMap(serverInfo -> serverInfo.getApplicant().stream()).collect(Collectors.toSet());
        Set<Integer> serverIds = serverInfos.stream().map(serverInfo -> serverInfo.getServerId()).collect(Collectors.toSet());
        CrossCrusadeGroup crossCrusadeGroup = new CrossCrusadeGroup();
        crossCrusadeGroup.setId(id);
        crossCrusadeGroup.setMembers(membersId);
        crossCrusadeGroup.getServer_id().addAll(serverIds);
        return crossCrusadeGroup;
    }

    /**
     * 获取成员职位
     * @param memberId
     * @return
     */
    public GroupPosition getPosition(long memberId){
        if(this.headId == memberId){
            return GroupPosition.LEADER;
        } else if(this.commander.contains(memberId)){
            return GroupPosition.COMMANDER;
        } else {
            return GroupPosition.MEMBER;
        }
    }

    /**
     * 更新boss伤害
     * @param damage
     */
    public void updateBossHurt(long damage){
        this.bossHurtAll += damage;
        this.bossHurtUpdateTime = DateTimeUtil.currentSecond();
    }

    /**
     * 更新神兵精华
     * @param Essence
     */
    public void updateShenBin(long Essence){
        this.shenBinAll += Essence;
        this.shenBinUpdateTime = DateTimeUtil.currentSecond();
    }

    /**
     * 设置团长
     * @param rid
     * @param emblem
     * @param groupName
     */
    public void setHead(long rid, int emblem, String groupName){
        this.headId = rid;
        this.emblem = emblem;
        this.groupName = groupName;
    }

    /**
     * 设置指挥官
     * @param commanderIds
     */
    public void setCommander(Set<Long> commanderIds){
        this.commander.addAll(commanderIds);
    }

    /**
     * 修改讨伐团名称
     * @param groupName
     */
    public void rename(String groupName){
        this.groupName = groupName;
        this.renameNumber += 1;
    }

}
