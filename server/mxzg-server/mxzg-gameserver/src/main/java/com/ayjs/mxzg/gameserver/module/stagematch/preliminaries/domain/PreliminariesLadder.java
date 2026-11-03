package com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.config.excel.constant.PreliminariesConst;
import com.ayjs.mxzg.message.module.stagematch.dto.RankDto;
import lombok.Getter;
import lombok.Setter;
import org.springframework.util.CollectionUtils;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Entity
@Table(name = "preliminaries_ladder", comment = "巅峰赛预赛")
@Getter
@Setter
public class PreliminariesLadder extends AbstractEntity {
    @Id
    @Column(name = "rid", comment = "角色id")
    private long rid;
    @Column(name = "challenges", comment = "挑战次数，每天重置")
    private int challenges;
    @Column(name = "purchases", comment = "每天购买次数，每天重置")
    private int purchases;
    @Column(name = "refresh_date_time", comment = "刷新时间")
    private LocalDate refreshDateTime;
    @Column(name = "defends_info", comment = "防守列表", length = 2048)
    private List<RankDto> defends = new ArrayList<>();
    @Column(name = "last_refresh_defend", comment = "刷新cd")
    private LocalDateTime lastRefreshDefend = LocalDateTime.now();
    @Column(name = "defends_time", comment = "防守列表时间")
    private int defendsTime;
    @Column(name = "be_like_count", comment = "被点赞次数")
    private int beLikeCount;
    @Column(name = "likes", comment = "点赞列表")
    private List<Long> likes = new ArrayList<>();
    @Column(name = "read_time", comment = "战报读取时间")
    private int readTime;

    /**
     * 获取剩余挑战次数
     * @return
     */
    public int getRemainingChallenges(){
        return this.purchases + PreliminariesConst.PRELIMINARIES_CHALLENGES - this.challenges;
    }

    /**
     * 获取剩余购买次数
     * @return
     */
    public int getRemainingPurchases(){
        return PreliminariesConst.PRELIMINARIES_PURCHASES - this.purchases;
    }

    /**
     * 是否没有超过购买次数上限
     * @return
     */
    public boolean notPurchaseLimit(){
        return this.purchases < PreliminariesConst.PRELIMINARIES_BUY_TIMES;
    }

    /**
     * 增加购买次数
     */
    public void addPurchases(){
        this.purchases++;
    }

    /**
     * 修改挑战结果后的信息
     * @param defends
     */
    public void updateResultInfo(List<RankDto> defends){
        this.challenges++;
        updateDefends(defends);
    }

    /**
     * 修改对手列表
     * @param defends
     */
    public void updateDefends(List<RankDto> defends){
        if(!CollectionUtils.isEmpty(defends)){
            this.defends.clear();
            this.defends.addAll(defends);
            this.lastRefreshDefend = LocalDateTime.now();
        }
    }

    /**
     * 获取防守列表
     * @return
     */
    public List<RankDto> getDefends(){
        return this.defends == null ? Collections.emptyList() : this.defends;
    }

    /**
     * 赛季重置
     */
    public void seasonReset(){
        this.challenges = 0;
        this.purchases = 0;
        this.refreshDateTime = LocalDate.now();
        this.beLikeCount = 0;
        this.likes.clear();
        this.readTime = 0;
        if(this.defends == null){
            this.defends = new ArrayList<>();
        } else {
            this.defends.clear();
        }
        if(this.likes == null){
            this.likes = new ArrayList<>();
        } else {
            this.likes.clear();
        }
    }

   /**
     * 每天重置
     */
    public void dailyReset(){
        this.challenges = 0;
        this.purchases = 0;
        this.likes.clear();
        this.refreshDateTime = LocalDate.now();
    }

    /**
     * 添加点赞
     * @param rid
     */
    public void addLikes(long rid){
        this.likes.add(rid);
    }
}
