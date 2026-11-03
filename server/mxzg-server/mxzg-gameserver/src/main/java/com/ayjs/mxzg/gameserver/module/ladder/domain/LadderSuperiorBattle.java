package com.ayjs.mxzg.gameserver.module.ladder.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.ladder.struct.LadderBattleRole;
import lombok.Data;

/**
 * @Author: CWJ
 * @Date: 2020/1/3
 **/
@Entity
@Table(name = "ladder_superior_battle", comment = "大神风采")
@Data
public class LadderSuperiorBattle extends AbstractEntity {

    @Id
    @LongIdGenerate
    @Column(name = "id")
    private long id;

    @Column(name = "report_id", comment = "战报id")
    private String reportId;

    @Column(name = "win_rid", comment = "胜利者")
    private long winRid;
    //    @Column(name = "attack_rank", comment = "攻击方新排名")
//    private int attackRank;
//    @Column(name = "defend_rank", comment = "防守方新排名")
//    private int defendRank;
    @Column(name = "battle_time", comment = "战斗时间")
    private int battleTime;

    @Column(name = "attack", comment = "攻击方")
    private LadderBattleRole attack = new LadderBattleRole();
    @Column(name = "defend", comment = "防守方")
    private LadderBattleRole defend = new LadderBattleRole();

}
