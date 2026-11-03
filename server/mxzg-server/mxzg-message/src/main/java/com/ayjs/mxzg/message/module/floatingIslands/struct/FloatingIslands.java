package com.ayjs.mxzg.message.module.floatingIslands.struct;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2020/7/1
 **/
@Entity
@Table(name = "floating_islands", comment = "浮空岛数据")
@Setter
@Getter
public class FloatingIslands extends AbstractEntity {

    @Id
    @Column(name = "id", comment = "唯一标识")
    private long id;

    @Column(name = "dmg", comment = "全服总伤害")
    private long dmg;

    @Column(name = "last_boss_settle_time",comment = "上次boss结算时间")
    private int lastBossSettleTime;

}
