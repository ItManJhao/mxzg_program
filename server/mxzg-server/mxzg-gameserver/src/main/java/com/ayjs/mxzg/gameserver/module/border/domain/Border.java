package com.ayjs.mxzg.gameserver.module.border.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import lombok.Data;

/**
 * @Author: CWJ
 * @Date: 2019/10/28
 **/
@Entity
@Table(name = "border", comment = "头像框", indexes = {@Index(name = "rid", columnList = "rid")}, cache = {@Cache(columns = "rid")})
@Data
public class Border extends AbstractEntity {

    @Id
    @Column(name = "id", comment = "唯一标识")
    @LongIdGenerate
    private long id;
    @Column(name = "rid", readOnly = true)
    private long rid;
    @Column(name = "config_id", comment = "配置id")
    private int configId;
    @Column(name = "expire_time", comment = "过期时间,-1代表永久激活")
    private int expireTime;

    public boolean isActive() {
        return expireTime < 0 || expireTime >= TimeDateUtil.getCurrentTimeInt();
    }
}
