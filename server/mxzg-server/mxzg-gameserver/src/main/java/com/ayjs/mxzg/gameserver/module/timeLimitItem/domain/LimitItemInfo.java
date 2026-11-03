package com.ayjs.mxzg.gameserver.module.timeLimitItem.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Table(name = "limit_item_info", comment = "期限道具数据",
        indexes = {@Index(name = "rid", columnList = {"rid"})}, cache = {@Cache(columns = "rid")})
public class LimitItemInfo extends AbstractEntity {

    @Id
    @LongIdGenerate
    @Column(name = "id")
    private long id;
    @Column(name = "rid", comment = "角色ID", readOnly = true)
    private long rid;
    /**
     * {@link com.ayjs.mxzg.gameserver.module.timeLimitItem.constant.TimeLimitItemType}
     */
    @Column(name = "type", comment = "类型")
    private int type;
    @Column(name = "item_type", comment = "道具id")
    private int itemType;
    @Column(name = "active_time", comment = "激活时间")
    private int activeTime;
    @Column(name = "end_time", comment = "过期时间")
    private int endTime;
}
