package com.ayjs.mxzg.gameserver.module.teamArena.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.config.excel.constant.VideoConst;
import com.ayjs.mxzg.protocol.BattleGMsg;
import com.google.protobuf.InvalidProtocolBufferException;
import lombok.Getter;
import lombok.Setter;

import java.io.UnsupportedEncodingException;

/**
 * @Author: CWJ
 * @Date: 2020/4/9
 **/
@Table(name = "arena_team_record_detail", comment = "组队竞技场队伍", indexes = {@Index(name = "record_id", columnList = {"record_id"})},
        cache = {@Cache(columns = "record_id")})
@Getter
@Setter
@Entity
public class ArenaTeamBattleRecordDetail extends AbstractEntity {

    @Id
    @LongIdGenerate
    @Column(name = "id")
    private long id;

    @Column(name = "record_id", comment = "记录id", readOnly = true)
    private long recordId;

//    @Column(name = "team_id", readOnly = true)
//    private long teamId;

    @Column(name = "report_id", comment = "战报id")
    private String reportId;

    @Column(name = "win_team", comment = "胜利者")
    private long winTeamId;

    //    @Column(name = "add_rank", comment = "增加排名")
//    private int addRank;
    @Column(name = "battle_time", comment = "战斗时间")
    private int battleTime;

    @Column(name = "attack_team_name", comment = "进攻方队伍名字")
    private String attackTeamName;
    @Column(name = "defend_team_name", comment = "防守方队伍名字")
    private String defendTeamName;

    @Column(name = "battle_log_str", comment = "数据", length = 2048)
    private String battleLogStr;

    @Column(name = "battle_round", comment = "数据", length = 2048)
    private int battleRound;

    private BattleGMsg.BattleLog battleLog;

    public BattleGMsg.BattleLog getBattleLog() {
        if (battleLog == null && battleLogStr != null) {
            try {
                battleLog = BattleGMsg.BattleLog.parseFrom(battleLogStr.getBytes(VideoConst.ISO));
            } catch (InvalidProtocolBufferException | UnsupportedEncodingException e) {
                e.printStackTrace();
            }
        }
        return battleLog;
    }


}
