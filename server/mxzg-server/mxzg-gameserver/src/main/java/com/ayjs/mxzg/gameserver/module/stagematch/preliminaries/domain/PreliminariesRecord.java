package com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.config.excel.constant.PreliminariesConst;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;


@Entity
@Table(name = "preliminaries_record", comment = "我的预赛记录")
@Data
public class PreliminariesRecord extends AbstractEntity {

    @Id
    @Column(name = "rid", readOnly = true, comment = "主键id")
    private long rid;

    @Column(name = "records", comment = "战斗日志", longtext = true)
    private List<MyRecord> records = new ArrayList<>();

    /**
     * 添加日志
     * @param record
     */
    public void addLog(MyRecord record){
        this.records.add(record);
        if(this.records.size() > PreliminariesConst.PRELIMINARIES_RECORD_NUM){
            this.records.remove(0);
        }
    }

    /**
     * 清理日志记录
     */
    public void cleanRecords(){
        if(this.records == null){
            this.records = new ArrayList<>();
        } else {
            this.records.clear();
        }
    }

}
