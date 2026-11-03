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
import com.ayjs.mxzg.common.persistence.annotation.Table;

import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;


/**
 * ClanBossBattleInfo
 */
@Entity
@Table(name = "clan_boss_battle_Info", comment = "公会副本挑战次数")
@Getter
@Setter
public class ClanBossBattleInfo extends AbstractEntity {

    @Id
    @Column(name = "rid")
    private long rid;

    @Column(name = "purchase_num", comment = "已使用购买次数")
    private int purchaseNum;

    @Column(name = "now_battle", comment = "剩余的挑战次数")
    private int nowBattle;

    @Column(name = "use_battle", comment = "已使用挑战次数")
    private int useBattle;

    @Column(name = "battle_time",comment = "上一次挑战时间")
    private int battleTime;

    @Column(name = "clan_kill_list",comment = "公会副本击杀集")
    private List<Integer> clanKillList = new ArrayList<>();

    @Column(name = "clan_rank_list",comment = "公会副本排行榜奖励领取集")
    private List<Integer> clanRankRewardList = new ArrayList<>();


}