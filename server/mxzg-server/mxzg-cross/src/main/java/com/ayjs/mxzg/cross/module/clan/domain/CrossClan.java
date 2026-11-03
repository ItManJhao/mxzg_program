package com.ayjs.mxzg.cross.module.clan.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.CopyOnWriteArraySet;

/**
 * @Author: CWJ
 * @Date: 2019/12/18
 **/
@Entity
@Table(name = "cross_clan", comment = "跨服公会")
@Data
public class CrossClan extends AbstractEntity {

    @Id
    @Column(name = "id", nullable = false, length = 19)
    private long id;

    @Column(name = "clan_name", comment = "公会名称")
    private String clanName = "";

    @Column(name = "clan_level", comment = "公会等级")
    private int clanLevel;

    @Column(name = "create_time", comment = "创建时间")
    private long createTime;

    @Column(name = "clan_head_rid", comment = "公会长ID")
    private long clanHeadRid;

    @Column(name = "clan_head_name", length = 50, comment = "公会长名")
    private String clanHeadName = "";

    @Column(name = "clan_icon", comment = "公会头像")
    private int clanIcon;

    @Column(name = "clan_fighting", comment = "公会战力")
    private long clanFighting;

    @Column(name = "fighting_update_time", comment = "战力修改时间")
    private int fightingUpdateTime;

    @Column(name = "server_id", comment = "服务器ID")
    private int serverId;

    @Column(name = "server_open_time", comment = "服务器开服时间")
    private int serverOpenTime;

}
