package com.ayjs.mxzg.gameserver.module.operatorValue.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.operatorValue.constant.OperatorType;
import lombok.Data;

/**
 * @description: 玩家操作累计计数
 * @author: CWJ
 * @date: 2019/10/14 10:10
 */
@Entity
@Table(name = "operator_value", indexes = {@Index(name = "rid", columnList = {"rid"})}, cache = {@Cache(columns = "rid")})
@Data
public class OperatorValue extends AbstractEntity {

    @Id
    @LongIdGenerate
    @Column(name = "id", comment = "唯一主键")
    private long id;
    @Column(name = "rid", readOnly = true, unique = true, nullable = false, length = 19)
    private long rid;
    /**
     * {@link OperatorType}
     */
    @Column(name = "type", unique = true, nullable = false, length = 10)
    private int type;
    @Column(name = "condition")
    private int condition;
    @Column(name = "sub_condition")
    private int subCondition;

    /**
     * 计数
     */
    @Column(name = "count", nullable = false, length = 10)
    private int count;

    public int addProcess(int addValue) {
        return this.count += addValue;
    }
}
