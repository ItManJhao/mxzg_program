package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.*;
import lombok.Data;

/**
 * @description:
 * @author: CWJ
 * @date: 2019/10/14 22:50
 */
@Entity
@Table(name = "privilege_gift", comment = "特权礼包", indexes = {@Index(name = "rid", columnList = {"rid"})}, cache = {@Cache(columns = "rid")})
@Data
public class PrivilegeGift extends AbstractEntity {
    @Id
    @Column(name = "id")
    @LongIdGenerate
    private long id;
    @Column(name = "rid", readOnly = true)
    private long rid;
    @Column(name = "idx", comment = "特权配置表ID")
    private int idx;
    @Column(name = "buy_time", comment = "购买特权的时间")
    private int buyTime;
    @Column(name = "end_time", comment = "特权的结束时间，0为永久")
    private int endTime;
    @Column(name = "buy_count", comment = "已购买特权的次数")
    private int buyCount;
    @Column(name = "active", comment = "特权是否生效，1生效，0不生效")
    private int active;
}
