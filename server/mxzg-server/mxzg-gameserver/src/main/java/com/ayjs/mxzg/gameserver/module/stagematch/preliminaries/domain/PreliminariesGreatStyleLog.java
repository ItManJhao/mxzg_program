package com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.domain;


import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.config.excel.constant.StageMatchConst;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

/**
 * 大神风采日志
 */
@Entity
@Getter
@Setter
@Table(name = "preliminaries_great_style_log", comment = "巅峰赛预赛大神风采日志表")
public class PreliminariesGreatStyleLog extends AbstractEntity {

    @Id
    @Column(name = "id", readOnly = true, comment = "主键id")
    private int id;

    @Column(name = "records", comment = "大神风采日志", longtext = true)
    private List<BattleRecord> records = new ArrayList<>();

    /**
     * 添加日志
     * @param battleRecord
     */
    public void addLog(BattleRecord battleRecord){
        this.records.add(battleRecord);
        if(this.records.size() > StageMatchConst.GREAT_STYLE_RECORD){
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