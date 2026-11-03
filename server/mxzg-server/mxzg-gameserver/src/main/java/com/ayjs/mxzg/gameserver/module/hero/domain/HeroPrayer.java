package com.ayjs.mxzg.gameserver.module.hero.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;
import com.ayjs.mxzg.common.persistence.annotation.Id;

/**
 * 英雄祈愿表
 * @author hyx
 */
@Entity
@Table(name = "hero_prayer", comment = "英雄祈愿表")
@Getter
@Setter
public class HeroPrayer extends AbstractEntity {

    @Id
    @Column(name = "rid", comment = "玩家id")
    private long rid;

    @Column(name = "prayer_privilege",comment = "祈愿特权是否开启,0为未开启，1为已开启")
    private int prayerPrivilege;

    @Column(name = "end_time",comment = "特权结束时间")
    private int end_time;
}

