package com.ayjs.mxzg.largecross.module.floatingIslands.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.message.module.teamArena.domain.RoleSimpleMessage;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2020/7/1
 **/
@Table(name = "role_floating_islands", comment = "跨服角色数据")
@Entity
@Setter
@Getter
public class RoleFloatingIslands extends AbstractEntity {

    @Id
    @Column(name = "rid", comment = "角色id")
    private long rid;

    @Column(name = "total_dmg", comment = "总伤害")
    private long totalDmg;

    @Column(name = "max_dmg", comment = "单词最大伤害")
    private long maxDmg;

    @Column(name = "rank_time", comment = "排行榜时间")
    private int rankTime;

    @Column(name = "server_id", comment = "服务器id")
    private int serverId;

    @Column(name = "role_message", comment = "角色信息")
    private RoleSimpleMessage roleSimpleMessage = new RoleSimpleMessage();

}
