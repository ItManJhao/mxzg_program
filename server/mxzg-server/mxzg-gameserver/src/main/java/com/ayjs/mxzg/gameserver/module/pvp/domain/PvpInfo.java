/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.pvp.domain;

import java.util.List;
import java.util.Set;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.pvp.struct.PvpRecord;

import lombok.Getter;
import lombok.Setter;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "pvp_info", comment = "玩家的竞技场信息表")
@Getter
@Setter
public class PvpInfo extends AbstractEntity {
	@Id
	@Column(name = "rid")
	private long rid;
	@Column(name = "num", comment = "今天已挑战次数")
	private int num;
	@Column(name = "daily_time", comment = "每日重置时间")
	private int dailyTime;
	@Column(name = "records", comment = "战斗记录", length = 10000)
	private List<PvpRecord> records;
	@Column(name = "other_rids", comment = "当前可以挑战的对手玩家ID")
	private Set<Long> otherRids;
	@Column(name = "challenge", comment = "竞技场已挑战的次数")
	private int challenge;
	@Column(name = "robot_ids", comment = "当前可挑战的机器人ID")
	private Set<Integer> robotIds;
	@Column(name = "belike", comment = "被点赞次数")
	private int belike;
	@Column(name = "season_reward", comment = "已领取的赛季累计挑战次数奖励", length = 100)
	private Set<Integer> seasonReward;
	@Column(name = "season_count", comment = "赛季挑战次数")
	private int seasonCount;
	@Column(name = "season_time", comment = "赛季时间")
	private int seasonTime;
	@Column(name = "like_rids", comment = "今天已点赞的玩家")
	private Set<Long> likeRids;
	@Column(name = "rainbow_time", comment = "彩虹圣殿挑战失败冷却时间")
	private int rainbowTime;
}
