package com.ayjs.mxzg.center.module.rechargeLimit.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

import java.util.Set;

/**
 * 跨服充值限制条件
 */
@Getter
@Setter
@Entity
@Table(name = "center_recharge_limit", comment = "跨服充值限制条件")
public class CenterRechargeLimit extends AbstractEntity {
    @Id
    @Column(name = "id", comment = "Id")
    private int id;
    @Column(name = "total_recharge", comment = "总充值额")
    private long totalRecharge;
    @Column(name = "areas", comment = "限制的注册地区列表", length = 1024)
    private Set<String> areas;
    @Column(name = "login_areas", comment = "限制的登录地区列表", length = 1024)
    private Set<String> loginAreas;
}
