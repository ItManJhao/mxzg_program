package com.ayjs.mxzg.message.module.role.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.message.module.role.message.HeroBriefData;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Entity
@Table(name = "cross_role", comment = "角色")
@Getter
@Setter
public class CrossRole extends AbstractEntity {
    @Id
    @Column(name = "id", comment = "角色id")
    private long id;
    @Column(name = "user_id", readOnly = true, comment = "账号id")
    private long userId;
    @Column(name = "server_id", readOnly = true, comment = "服务器id")
    private int serverId;
    @Column(name = "nick", length = 128, comment = "昵称")
    private String nick = "";
    @Column(name = "head_id", comment = "头像ID")
    private int headId;
    @Column(name = "border_id", comment = "头像框ID")
    private int borderId;
    @Column(name = "image_id", comment = "形象id")
    private int imageId;
    @Column(name = "level", comment = "角色等级")
    private int level;
    @Column(name = "create_time", comment = "创号时间")
    private long createTime;
    @Column(name = "clan_id", comment = "公会id")
    private long clanId;
    @Column(name = "clan_name", length = 128, comment = "公会名称")
    private String clanName;
    @Column(name = "arena_score", comment = "竞技场积分")
    private int arenaScore;
    @Column(name = "area_id", comment = "区域id,省市对应id")
    private int areaId;
    @Column(name = "fighting_rank_time", comment = "排行榜更新时间")
    private int fightRankTime;
    @Column(name = "max_fighting", comment = "历史最大战力")
    private int maxFighting;
    @Column(name = "fighting", comment = "当前战力")
    private int fighting;
    @Column(name = "hero_brief", comment = "主线阵营简要信息")
    private List<HeroBriefData> heroBrief;
    @Column(name = "last_offline_time", comment = "下线时间")
    private long lastOfflineTime;
    @Column(name = "place", comment = "渠道")
    private String place = "";
    @Column(name = "formation_id", comment = "主线阵营阵法ID")
    private int formationId;
    @Column(name = "assistance_unlock", comment = "援助是否解锁")
    private boolean assistanceUnlock;
    @Column(name = "is_online", comment = "当前是否在线")
    private boolean isOnline;
}
