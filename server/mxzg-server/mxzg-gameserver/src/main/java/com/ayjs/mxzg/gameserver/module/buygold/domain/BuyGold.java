package com.ayjs.mxzg.gameserver.module.buygold.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.Map;

@Entity
@Table(name = "buy_gold", comment = "点金表")
@Data
public class BuyGold extends AbstractEntity {

    /**
     * 角色id
     */
    @Id
    @Column(name = "rid", comment = "角色id")
    private long rid;
    /**
     * 购买数量
     */
    @Column(name = "buy_info", comment = "购买数量")
    private Map<Integer, Integer> buyInfo;
    /**
     * 下次刷新时间
     */
    @Column(name = "buy_time", comment = "下次刷新时间")
    private LocalDateTime nextRefreshTime;
}
