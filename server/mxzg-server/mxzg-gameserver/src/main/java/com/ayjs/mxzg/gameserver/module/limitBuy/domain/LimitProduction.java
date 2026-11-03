package com.ayjs.mxzg.gameserver.module.limitBuy.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;

import java.time.LocalDate;

/**
 * @Author: CWJ
 * @Date: 2019/10/30
 **/
@Entity
@Data
@Table(name = "limit_production", comment = "限购商品",
        indexes = {@Index(name = "rid", columnList = {"rid"})}, cache = {@Cache(columns = "rid")})
public class LimitProduction extends AbstractEntity {
    @Id
    @LongIdGenerate
    @Column(name = "id", comment = "唯一标识")
    private long id;
    @Column(name = "rid", readOnly = true, comment = "角色id")
    private long rid;
    @Column(name = "buy_gem_idx", comment = "buyGem的配置id")
    private int buyGemIdx;
    @Column(name = "expire_time", comment = "过期时间")
    private int expireTime;
    @Column(name = "count", comment = "可购买数量")
    private int count;
    @Column(name = "buy_time", comment = "购买时间")
    private LocalDate buyTime;
    @Column(name = "buy_count", comment = "购买次数")
    private int buyCount;

}
