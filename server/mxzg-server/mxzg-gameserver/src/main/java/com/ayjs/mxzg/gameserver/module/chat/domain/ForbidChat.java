package com.ayjs.mxzg.gameserver.module.chat.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.hook.GetAfter;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

/**
 * @Author: CWJ
 * @Date: 2020/9/19
 **/
@Table(name = "forbid_chat", comment = "禁言")
@Getter
@Setter
@Entity
public class ForbidChat extends AbstractEntity implements GetAfter {

    @Id
    @Column(name = "rid", comment = "角色id")
    private long rid;

    @Column(name = "count", comment = "禁言次数")
    private int count;

    @Column(name = "forbid_time", comment = "禁言时间")
    private LocalDate forbidTime = LocalDate.of(2000, 1, 1);

    @Override
    public boolean getAfter() {
        if (!LocalDateTimeUtil.isSameWeek(forbidTime, LocalDate.now())) {
            count = 0;
            forbidTime = LocalDate.now();
            return true;
        }
        return false;
    }
}
