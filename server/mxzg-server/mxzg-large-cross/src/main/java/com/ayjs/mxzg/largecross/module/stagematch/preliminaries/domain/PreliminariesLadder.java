package com.ayjs.mxzg.largecross.module.stagematch.preliminaries.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "preliminaries_ladder", comment = "预赛天梯表")
public class PreliminariesLadder extends AbstractEntity {

    @Id
    @Column(name = "rid", comment = "玩家ID")
    private long rid;
    /**
     * 排名
     */
    @Column(name = "rank", comment = "排名")
    private int rank;
    /**
     * 点赞
     */
    @Column(name = "likes", comment = "点赞")
    private int likes;
    /**
     * 战斗对象
     */
    @Column(name = "battler_vo", comment = "战斗Vo对象", length = 32768)
    private String battlerVo;
    /**
     * 战力
     */
    @Column(name = "fighting", comment = "战力")
    private int fighting;


    public static PreliminariesLadder valueOf(long rid, int rank){
        PreliminariesLadder preliminariesLadder = new PreliminariesLadder();
        preliminariesLadder.setRid(rid);
        preliminariesLadder.setRank(rank);
        return preliminariesLadder;
    }

    /**
     * 更新战斗信息
     * @param battlerVo
     * @param fighting
     */
    public void updateBattleInfo(String battlerVo, int fighting){
        this.battlerVo = battlerVo;
        this.fighting = fighting;
    }

    /**
     * 点赞
     */
    public void likes(){
        this.likes++;
    }

    /**
     * 赛季重置
     */
    public void reset(){
        this.rank = 0;
        this.likes = 0;
    }

}
