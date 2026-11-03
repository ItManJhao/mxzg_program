package com.ayjs.mxzg.gameserver.module.stagematch.battle.domain;


import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.common.persistence.log.AbstractLog;
import com.ayjs.mxzg.config.excel.constant.StageMatchConst;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

/**
 * 角色段位赛信息
 */
@Entity
@Table(name = "role_stage_match_log", comment = "角色段位赛日志表")
@Getter
@Setter
public class RoleStageMatchLog extends AbstractLog {

    @Id
    @Column(name = "rid", readOnly = true, comment = "角色id")
    private long rid;

    @Column(name = "match_logs", comment = "匹配日志", longtext = true)
    private List<MatchLog> matchLogs = new ArrayList<>();

    @Override
    public Long getId() {
        return rid;
    }

    @Override
    public void setId(Long id) {
        this.rid = id;
    }

    /**
     * 添加日志
     * @param matchLog
     */
    public void addLog(MatchLog matchLog){
        this.matchLogs.add(matchLog);
        if(this.matchLogs.size() > StageMatchConst.SUPER_STAGE_PERSONAL_RECORD){
            this.matchLogs.remove(0);
        }
    }

}