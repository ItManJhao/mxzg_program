/**
 *
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import java.util.HashSet;
import java.util.Set;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;

import lombok.Getter;
import lombok.Setter;

/***
 * cwj
 */
@Entity
@Table(name = "promotion005_foundation", comment = "成长基金")
@Getter
@Setter
public class Promotion005Foundation extends AbstractEntity {
    @Id
    @Column(name = "rid")
    private long rid;
    @Column(name = "had_buy")
    private boolean hadBuy;
    @Column(name = "reward_ids", comment = "领奖记录", length = 500)
    private Set<Integer> rewardIds = new HashSet<>();

}
