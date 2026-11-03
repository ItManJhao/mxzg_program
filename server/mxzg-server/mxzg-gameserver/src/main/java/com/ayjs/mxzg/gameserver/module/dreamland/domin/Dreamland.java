package com.ayjs.mxzg.gameserver.module.dreamland.domin;

import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.battle.model.mirror.HeroVo;
import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;

import java.util.*;

/**
 * @Author: CWJ
 * @Date: 2019/12/11
 **/
@Data
@Table(name = "dreamland", comment = "永恒梦境")
@Entity
public class Dreamland extends AbstractEntity {
    @Id
    @Column(name = "rid", comment = "玩家id")
    private long rid;
    @Column(name = "max_lv", comment = "历史最大关卡")
    private int maxLv;
    @Column(name = "today_max_lv", comment = "今日最大关卡")
    private int todayMaxLv;
    @Column(name = "today_min_lv", comment = "今日最小关卡")
    private int todayMinLv;
    @Column(name = "cur_lv", comment = "当前关卡")
    private int curLv;
    @Column(name = "reward_lv", comment = "通关关卡领奖记录")
    private int rewardLv;
    @Column(name = "today_challenge_count", comment = "今日挑战次数")
    private int todayChallengeCount;
    @Column(name = "today_reward_lv", comment = "今日已领取层关卡数")
    private int todayRewardLv;
    @Column(name = "last_refresh_time", comment = "上次刷新时间")
    private int lastRefreshTime;


    @Column(name = "random_buff_ids", comment = "下一轮可选择的buff集合", length = 100)
    private List<Integer> randomBuffIds = new ArrayList<>();
    @Column(name = "curr_buff_id", comment = "当前buff")
    private int currBuffId;
    @Column(name = "buff_valid", comment = "buff已生效回合数")
    private int buffValid;

    @Column(name = "assist_hero", comment = "支援英雄,非镜像数据")
    private HeroVo assistHero = new HeroVo();
    @Column(name = "select_hero", comment = "选择的好友英雄，镜像数据")
    private Map<Long, HeroVo> selectHero = new HashMap<>();


    @Column(name = "battle_status", comment = "战斗状态，1.非战斗；2.战斗；3，选择")
    private int battleStatus;
    @Column(name = "next_battle_status", comment = "下一个战斗状态，1.非战斗；2.战斗；3，选择")
    private int nextBattleStatus;
    @Column(name = "status_change_time", comment = "战斗状态切换时间")
    private int statusChangeTime;

    @Column(name = "last_battle_result", comment = "上一场战斗结果0，未战斗，1胜利，2，失败")
    private int lastBattleResult;
    @Column(name = "this_pass_lv", comment = "本次通关层数")
    private int thisPassLv;
    @Column(name = "battle_vo", comment = "战斗数据保存", longtext = true)
    private BattlerVo battlerVo = new BattlerVo();

    public void setBattlerVo(BattlerVo battlerVo) {
        this.battlerVo = battlerVo;
    }
}
