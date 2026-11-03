package com.ayjs.mxzg.gameserver.module.teamArena.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.message.module.teamArena.domain.ArenaTeamMember;
import com.ayjs.mxzg.message.module.teamArena.domain.TeamArenaRankData;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArrayList;

/**
 * @Author: CWJ
 * @Date: 2020/4/9
 **/
@Table(name = "arena_team", comment = "组队竞技场队伍")
@Getter
@Setter
@Entity
public class ArenaTeam extends AbstractEntity {

    @Id
    @LongIdGenerate
    @Column(name = "team_id", comment = "唯一标识")
    private long teamId;
    @Column(name = "captain_id", comment = "队长")
    private long captainId;
    @Column(name = "team_name", comment = "队伍名字")
    private String teamName;
    @Column(name = "min_fighting", comment = "最低战斗力")
    private int minFighting;
    @Column(name = "min_lv", comment = "最低等级")
    private int minLv;
    @Column(name = "auto_agree", comment = "是否需要审批")
    private boolean autoAgree;

    @Column(name = "member", comment = "所有队员")
    private CopyOnWriteArrayList<ArenaTeamMember> members = new CopyOnWriteArrayList<>();

    @Column(name = "score", comment = "积分")
    private int score;

    @Column(name = "rank_time", comment = "排行榜时间")
    private int rankTime;

    @Column(name = "had_sign", comment = "是否报名")
    private boolean hadSign;

    @Column(name = "invites", comment = "邀请列表")
    public Set<Long> invites = new HashSet<>();

    @Column(name = "count_add_time", comment = "挑战次数增加时间")
    private int countAddTime;
    @Column(name = "count", comment = "挑战次数")
    private int count;
    @Column(name = "defends", comment = "可挑战列表")
    private List<TeamArenaRankData> defends = new ArrayList<>();

    @Column(name = "member_reward", comment = "成员挑战奖励领取记录")
    private Map<Long, Set<Integer>> memberReward = new HashMap<>();
    @Column(name = "can_challenge_count", comment = "可挑战次数")
    private int canChallengeCount;
    @Column(name = "had_challenge_count", comment = "已挑战次数")
    private int hadChallengeCount;
    @Column(name = "last_add_time", comment = "上次增加挑战次数的时间")
    private int lastAddTime;
    
    @Column(name = "create_time", comment = "创建时间")
    private int createTime;

}
