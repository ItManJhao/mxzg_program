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

import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.*;
import lombok.Data;


/**
 * ClanBoss
 */
@Entity
@Table(name = "clan_boss", comment = "工会boss")
@Data
public class ClanBoss extends AbstractEntity {

    @Id
    @Column(name = "clan_id")
    private long clanId;

    @Column(name = "boss_idx", comment = "配置id")
    private int bossIdx;

    @Column(name = "now_hp", comment = "剩余血量成分比")
    private int nowHp;

    @Column(name = "boss_message", comment = "公会BOSS数据")
    private BattlerVo battlerVo;

    @Column(name = "status", comment = "战斗改版VO清除状态")
    private int status;
}