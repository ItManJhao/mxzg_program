package com.ayjs.mxzg.battle.model;

import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.protocol.BattleGMsg.BattleReport;
import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 战斗结果
 *
 * @author meiyc
 */
@Getter
@Setter
public class BattleResult {

    /**
     * 战场上下文
     */
    private BattleContext context;


    public static BattleResult valueOf(BattleContext context) {
        BattleResult result = new BattleResult();
        result.setContext(context);
        return result;
    }

    /**
     * 是否胜利，如果胜利方为攻方则return true
     *
     * @return
     */
    public boolean isWin() {
        return this.context.getAttacker().getPlayerId() == this.context.getWinId();
    }

    /**
     * 获取战报
     *
     * @return
     */
    public BattleReport getReport() {
        return context.getReport();
    }

    /**
     * 获取攻方血量
     *
     * @return <位置，血量信息>
     */
    public Map<Integer, HeroHpInfo> attackerHpInfo() {
        return getHpInfoBy(Faction.ATTACKER);
    }

    /**
     * 获取守方血量
     *
     * @return <位置，血量信息>
     */
    public Map<Integer, HeroHpInfo> defenderHpInfo() {
        return getHpInfoBy(Faction.DEFENDER);
    }

    /**
     * 构建防守方战场数据对象
     *
     * @return
     */
    public BattlerVo buildDefenderVo() {
        return this.context.getDefender().toBattlerVo();
    }

    /**
     * 构建攻方战场数据对象
     *
     * @return
     */
    public BattlerVo buildAttackerVo() {
        return this.context.getAttacker().toBattlerVo();
    }

    /**
     * 根据阵营获取总伤害
     *
     * @param faction
     * @return
     */
    public long getTotalDamage(Faction faction) {
        return getHeroByFaction(faction).stream().mapToLong(hero -> hero.getFightLog().getTotalDamage()).sum();
    }

    /**
     * 根据阵营获取血量信息
     *
     * @param faction
     * @return <位置，血量信息>
     */
    private Map<Integer, HeroHpInfo> getHpInfoBy(Faction faction) {
        List<HeroDo> heroDos = getHeroByFaction(faction).stream().filter(hero -> hero.getPosition() != 0).collect(Collectors.toList());
        Map<Integer, HeroHpInfo> map = new HashMap<>();
        heroDos.forEach(heroDo -> {
            map.put(heroDo.getPosition(), HeroHpInfo.createOf(heroDo));
        });
        return map;
    }

    /***
     * 根据阵营获取所有英雄
     * @param faction
     * @return
     */
    public List<HeroDo> getHeroByFaction(Faction faction) {
        return context.getSelf(faction).getHeroAndContainHelper();
    }
}
