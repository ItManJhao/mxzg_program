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
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.Table;

import lombok.Getter;
import lombok.Setter;


/**
 * ClanMember
 */
@Entity
@Table(name = "clan_member", indexes = { @Index(name = "idx_clan_id", columnList = { "clan_id" }) }, cache = {
		@Cache(columns = { "clan_id" }) })
@Getter
@Setter
public class ClanMember extends AbstractEntity {
    @Id
    @Column(name = "rid")
    private long rid;
    @Column(name = "clan_id", readOnly = true)
    private long clanId;
    @Column(name = "position", comment = "职位 0：无效，1：会长；2：副会长；3：普通成员")
    private int position;
    @Column(name = "join_time", comment = "加入时间")
    private long joinTime;
    @Column(name = "today_donate", comment = "今天的捐献数")
    private long todayDonate;
    @Column(name = "total_donate", comment = "加入公会后的总捐献数，离开公会清0")
    private long totalDonate;
    @Column(name = "daily_time", comment = "每日重置时间")
    private int dailyTime;
}