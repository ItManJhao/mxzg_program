package com.ayjs.mxzg.gameserver.module.ladder.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.message.module.ladder.message.LadderDefenderData;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CopyOnWriteArraySet;

@Entity
@Table(name = "ladder", comment = "天梯")
@Getter
@Setter
public class Ladder extends AbstractEntity {
    @Id
    @Column(name = "rid", comment = "角色id")
    private long rid;
    @Column(name = "battle_times", comment = "挑战次数")
    private int battleTimes;
    @Column(name = "buy_times", comment = "购买次数")
    private int buyTimes;
    @Column(name = "had_buy_times", comment = "已购买次数")
    private int hadBuyTimes;
    @Column(name = "refresh_date_time", comment = "刷新时间")
    private LocalDate refreshDateTime;
    @Column(name = "defends_info", comment = "防守列表", length = 1024)
    private List<LadderDefenderData> defends = new ArrayList<>();
    @Column(name = "last_refresh_defend", comment = "刷新cd")
    private LocalDateTime lastRefreshDefend = LocalDateTime.now();
    @Column(name = "defends_time", comment = "防守列表时间")
    private int defendsTime;
    @Column(name = "be_like_count", comment = "被点赞次数")
    private int beLikeCount;
    @Column(name = "like_time", comment = "点赞时间")
    private Map<Integer, LocalDate> likeTime = new HashMap<>();
    /**
     * 战报读取时间
     */
    @Column(name = "read_time", comment = "战报读取时间")
    private int readTime;

}
