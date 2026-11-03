package com.ayjs.mxzg.gameserver.log.adven.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2020/1/19
 **/
@Getter
@Setter
@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "adven_challenge_log", comment = "勇者试炼挑战日志")
public class AdvenChallengeLog extends AbstractOperateLog {
    @Column(name = "mission_id",comment = "关卡数")
    private int missionId;
    @Column(name = "win",comment = "输赢状态")
    private boolean win;
    @ShardingId
    @Column(name = "challenge_time",comment = "挑战时间",readOnly = true)
    private int challengeTime;
}
