package com.ayjs.mxzg.gameserver.module.floatingIslands.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2020/6/30
 **/
@Entity
@Table(name = "role_floating_islands", comment = "浮空岛")
@Getter
@Setter
public class RoleFloatingIslands extends AbstractEntity {

    @Id
    @Column(name = "rid", comment = "角色id")
    private long rid;

    @Column(name = "challenge_count", comment = "挑战次数")
    private int challengeCount;

    @Column(name = "had_buy_count", comment = "已购买次数")
    private int hadBuyCount;

    @Column(name = "max_dmg", comment = "单次最大伤害")
    private long maxDmg;

    @Column(name = "total_dmg", comment = "boss总伤害")
    private long totalDmg;
    @Column(name = "count_refresh_time", comment = "次数刷新时间")
    private int countRefreshTime;


}
