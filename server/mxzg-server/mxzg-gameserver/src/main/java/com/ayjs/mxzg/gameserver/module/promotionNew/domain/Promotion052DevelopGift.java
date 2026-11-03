package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

@Data
@Table(name = "promotion052_develop_gift", comment = "超值养成礼包")
@Entity
public class Promotion052DevelopGift extends AbstractEntity {

    @Id
    @Column(name = "rid", comment = "角色id", readOnly = true)
    private long rid;

    @Column(name = "gifts", length = 128, comment = "礼包type:level")
    private Map<Integer, Integer> gifts = new HashMap<>();

    @Column(name = "refresh_date_time", comment = "重置时间--废弃")
    private LocalDate refreshDateTime;

    @Column(name = "refresh_date", comment = "重置时间-时间戳")
    private int refreshDate;
}
