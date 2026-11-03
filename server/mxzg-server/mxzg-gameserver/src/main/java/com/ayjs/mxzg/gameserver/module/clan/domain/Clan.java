/*
 * Welcome to use the TableGo Tools.
 *
 * http://www.tablego.cn
 *
 * http://vipbooks.iteye.com
 * http://blog.csdn.net/vipbooks
 * http://www.cnblogs.com/vipbooks
 *
 * Author: bianj
 * Email: tablego@qq.com
 * Version: 6.4.0
 */
package com.ayjs.mxzg.gameserver.module.clan.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.clan.struct.ClanDungeonDamageData;
import com.ayjs.mxzg.gameserver.module.clan.struct.ClanMsgData;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.CopyOnWriteArraySet;

/**
 * clan
 */
@Entity
@Table(name = "clan")
@Data
public class Clan extends AbstractEntity {

    @Id
    @Column(name = "id", unique = true, nullable = false, length = 19)
    @LongIdGenerate
    private long id;

    @Column(name = "clan_name", length = 128, comment = "公会名称")
    private String clanName;

    @Column(name = "clan_level", comment = "公会等级")
    private int clanLevel;

    @Column(name = "clan_exp", comment = "公会经验值")
    private long clanExp;

//    @Column(name = "clan_join_type", comment = "公会加入审批条件, 0: 任何人可以加入 1: 由长老以上审批 2: 由军团长审批")
//    private int clanJoinType;

    @Column(name = "create_time", comment = "创建时间")
    private long createTime;

    @Column(name = "clan_desc", comment = "公会简介")
    private String clanDesc;

    @Column(name = "clan_head_rid", comment = "公会长ID")
    private long clanHeadRid;

    @Column(name = "clan_head_name", comment = "公会长名字 ")
    private String clanHeadName;

    @Column(name = "clan_icon", comment = "公会头像")
    private int clanIcon;

    @Column(name = "clan_fighting", comment = "公会战力")
    private long clanFighting;

    @Column(name = "fighting_update_time", comment = "战力修改时间")
    private int fightingUpdateTime;

    @Column(name = "clan_donate", comment = "公会当天的捐献值，隔天清零")
    private int clanDonate;

    @Column(name = "clan_msg", comment = "公会日志")
    private CopyOnWriteArrayList<ClanMsgData> clanMsgList = new CopyOnWriteArrayList<>();

    @Column(name = "server_id", comment = "服务器ID")
    private int serverId;

    @Column(name = "apply_ids", comment = "申请列表")
    private CopyOnWriteArraySet<Long> applyIds = new CopyOnWriteArraySet<>();

    @Column(name = "clan_dungeon_damage_list",comment = "公会成员伤害集")
    private List<ClanDungeonDamageData> clanDungeonDamageList = new ArrayList<>();

    /**
     * 活跃的会员人数，不保存到数据库
     */
    private int activeMembers;

}