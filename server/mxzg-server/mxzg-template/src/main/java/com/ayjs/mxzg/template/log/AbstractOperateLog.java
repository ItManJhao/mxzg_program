/**
 *
 */
package com.ayjs.mxzg.template.log;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.MappedSuperclass;
import com.ayjs.mxzg.common.persistence.log.AbstractLog;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * @author YY
 * 玩家操作基类
 */
@MappedSuperclass
@Setter
@Getter
public abstract class AbstractOperateLog extends AbstractLog {
    @Id(auto = false)
    @LongIdGenerate
    @Column(name = "id", comment = "唯一ID")
    private long id;
    @Column(name = "rid", comment = "玩家ID")
    private long rid;
    @Column(name = "place", comment = "渠道")
    private String place = "";
    @Column(name = "op_time", comment = "操作的时间")
    private LocalDateTime opTime;

    @Override
    public Long getId() {
        return id;
    }

    @Override
    public void setId(Long id) {
        this.id = id;
    }
}
