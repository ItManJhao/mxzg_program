package com.ayjs.mxzg.gameserver.module.stagematch.battle.domain;


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
@Table(name = "great_style_log", comment = "大神风采日志表")
public class GreatStyleLog extends AbstractEntity {

    @Id
    @Column(name = "id", readOnly = true, comment = "主键id")
    private int id;

    @Column(name = "match_logs", comment = "大神风采日志", longtext = true)
    private List<MatchLog> matchLogs = new ArrayList<>();

    /**
     * 添加日志
     * @param matchLog
     */
    public void addLog(MatchLog matchLog){
        this.matchLogs.add(matchLog);
        if(this.matchLogs.size() > StageMatchConst.GREAT_STYLE_RECORD){
            this.matchLogs.remove(0);
        }
    }
}