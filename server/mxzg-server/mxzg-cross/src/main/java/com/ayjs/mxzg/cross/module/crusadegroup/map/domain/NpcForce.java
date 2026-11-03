package com.ayjs.mxzg.cross.module.crusadegroup.map.domain;

import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.constant.CrusadeGroupConst;
import lombok.Getter;
import lombok.Setter;

import java.util.*;

/**
 * npc部队信息
 */
@Getter
@Setter
public class NpcForce {

    // 领地id
    private int id;
    // 刷新时间
    private int refreshTime;
    // 保护时间
    private int guardTime;
    // 当前正在挑战的玩家
    private long challengerId;
    // Map<部队id，战斗阵容>
    private Map<Integer, BattlerVo> battlerVoMap = new HashMap<>();
    //战斗力
    private Map<Integer, Integer> fightingMap = new HashMap<>();
    // 击败的英雄id列表
    private Set<Long> defeatedHeroes = new HashSet<>();
    // 击败的阵容id
    private Set<Integer> defeatedFormationIds = new HashSet<>();
    // 角色伤害，
    private Map<Long, Long> damage = new HashMap<>();
    // 角色总伤害，
    private Map<Long, Long> totalDamage = new HashMap<>();
    // 战斗id
    private Map<Long, String> battleIds = new HashMap<>();



    /**
     * 获取指定队伍的战斗信息
     * @param teamId
     * @return
     */
    public BattlerVo getBattler(int teamId){
        return battlerVoMap.get(teamId);
    }

    /**
     * 替换
     * @param teamId
     * @param battlerVo
     */
    public void replace(int teamId, BattlerVo battlerVo){
        this.battlerVoMap.replace(teamId, battlerVo);
    }

    /**
     * 是否击败了所有的战斗单位
     * @return
     */
    public boolean isBeatAll(){
        return this.battlerVoMap.values().size() == defeatedFormationIds.size();
    }

    /**
     * 是否就剩余boss未击败
     *
     * @return
     */
    public boolean isOnlyBoss() {
        return this.battlerVoMap.values().size() == defeatedFormationIds.size() + 1;
    }

    /**
     * 添加击败的英雄id列表
     * @param beatHeroIds
     */
    public void addBeatHeroIds(List<Long> beatHeroIds){
        this.defeatedHeroes.addAll(beatHeroIds);
    }

    /**
     * 击败阵容
     * @param formationId
     */
    public void beat(int formationId){
        this.defeatedFormationIds.add(formationId);
    }

    /**
     * 指定的阵容是否已经被击败
     *
     * @param formationId
     * @return
     */
    public boolean isBeat(int formationId) {
        return this.defeatedFormationIds.contains(formationId);
    }

    /**
     * 添加伤害
     * @param rid
     * @param damage
     * @param battleId
     */
    public void addDamage(long rid, long damage, String battleId) {
        Long presence = this.damage.getOrDefault(rid, 0L);
        if(damage > presence){
            this.damage.put(rid, damage);
            this.battleIds.put(rid, battleId);
        }

        long totalDamage = this.totalDamage.getOrDefault(rid, 0L);
        totalDamage += damage;
        this.totalDamage.put(rid, totalDamage);
    }

    /**
     * 获取挑战者列表
     * @return
     */
    public Collection<Long> getChallengers(){
        return this.damage.keySet();
    }

    /**
     * 获取伤害
     * @param rid
     * @return
     */
    public long getDamage(long rid){
        return this.damage.getOrDefault(rid, 0l);
    }

    /**
     * 获取角色伤害
     * @param rid
     * @return
     */
    public long getTotalDamage(long rid){
        return this.totalDamage.getOrDefault(rid, 0l);
    }

    /**
     * 获取战斗id
     * @param rid
     * @return
     */
    public String getBattleId(long rid){
        return this.battleIds.get(rid);
    }

    /**
     * 获取战力
     * @param formationId
     * @return
     */
    public int getFighting(int formationId){
        return this.fightingMap.getOrDefault(formationId, 0);
    }

    /**
     * 是否需要刷新
     * @return
     */
    public boolean isRefresh(){
        return DateTimeUtil.currentSecond() > this.refreshTime && this.refreshTime != 0;
    }

    /**
     * boss刷新倒计时
     */
    public void bossRefreshCountdown(){
        this.refreshTime = DateTimeUtil.currentSecond() + CrusadeGroupConst.BOSS_REFRESH_TIME_S;
    }

    /**
     * 是否保护超时
     * @return
     */
    public boolean isProtectionTimeout(){
        return DateTimeUtil.currentSecond() > this.guardTime && this.guardTime != 0;
    }
}
