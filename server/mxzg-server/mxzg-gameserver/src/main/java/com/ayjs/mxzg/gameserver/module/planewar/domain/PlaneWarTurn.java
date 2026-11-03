package com.ayjs.mxzg.gameserver.module.planewar.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

/**
 * @Author: CWJ
 * @Date: 2020/9/15
 **/
@Table(name = "plane_war_turn", comment = "位面之战轮次")
@Getter
@Setter
@Entity
public class PlaneWarTurn extends AbstractEntity  {

    @Id
    @Column(name = "id", comment = "标识")
    private long id;

    @Column(name = "turn", comment = "轮次")
    private int turn;

    @Column(name = "turn_reset_time", comment = "轮次重置时间")
    private LocalDate turnResetTime = LocalDate.of(2000, 1, 1);


}
