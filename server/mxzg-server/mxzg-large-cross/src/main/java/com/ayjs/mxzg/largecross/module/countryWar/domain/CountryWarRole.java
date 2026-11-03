package com.ayjs.mxzg.largecross.module.countryWar.domain;

import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.message.module.countryWar.dto.CountryWarLogInfo;
import com.ayjs.mxzg.message.module.countryWar.dto.CountryWarRoleInfo;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.concurrent.CopyOnWriteArrayList;

/**
 * @Author: CWJ
 * @Date: 2021/4/14
 **/
@Getter
@Setter
@Table(name = "country_war_role", comment = "角色信息")
public class CountryWarRole extends AbstractEntity {
    @Id
    @Column(name = "rid", comment = "角色id")
    private long rid;
    @Column(name = "defend_city", comment = "驻守城池")
    private int defendCity;
    @Column(name = "defeated_city_rank_time", comment = "排行榜时间")
    private LocalDateTime defeatCityRankTime = LocalDateTime.of(1970, 1, 1, 0, 0);
    @Column(name = "damage", comment = "伤害")
    private long damage;
    @Column(name = "damage_rank_time", comment = "排行榜时间")
    private LocalDateTime damageRankTime = LocalDateTime.of(1970, 1, 1, 0, 0);
    @Column(name = "kill_count", comment = "击杀")
    private int killCount;
    @Column(name = "kill_count_rank_time", comment = "排行榜时间")
    private LocalDateTime killCountRankTime = LocalDateTime.of(1970, 1, 1, 0, 0);
    @Column(name = "battleVo", comment = "阵容", length = 32768)
    private String battleVo = "";
    @Column(name = "round", comment = "轮次")
    private int round;
    @Column(name = "main_server_id", comment = "主服务器id")
    private int mainServerId;
    @Column(name = "occupy_city", comment = "占领城池")
    private int occupyCity;
    @Column(name = "country_war_role_info", comment = "玩家简单信息")
    private CountryWarRoleInfo countryWarRoleInfo = new CountryWarRoleInfo();
    @Column(name = "logs", comment = "日志")
    private CopyOnWriteArrayList<CountryWarLogInfo> logs = new CopyOnWriteArrayList<>();
    @Column(name = "online", comment = "是否在线")
    private boolean online;

    private BattlerVo battlerVoObj;

    public BattlerVo getBattlerVoObj() {
        if (battlerVoObj == null) {
            battlerVoObj = GsonUtils.fromJson(battleVo, BattlerVo.class);
        }
        return battlerVoObj;
    }

    public void setBattleVo(String battleVo) {
        this.battleVo = battleVo;
        battlerVoObj = GsonUtils.fromJson(battleVo, BattlerVo.class);
    }
}
