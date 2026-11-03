package com.ayjs.mxzg.gameserver.module.tweakCube.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2020/9/8
 **/
@Entity
@Table(name = "tweak_cube", comment = "共鸣魔方")
@Getter
@Setter
public class TweakCube extends AbstractEntity {
    @Id
    @Column(name = "rid", comment = "角色id")
    private long rid;
    @Column(name = "hero_ranks", comment = "供奉列表")
    private List<Long> heroRanks = Lists.newArrayList();
    @Column(name = "trenches", comment = "槽位")
    private List<Trench> trenches = Lists.newArrayList();
    @Column(name = "trench_heroes", comment = "槽位英雄列表")
    private Map<Long, Integer> trenchHeroes = Maps.newHashMap();

    public void addToTrench(int trenchIndex, long heroId) {
        Trench trench = trenches.get(trenchIndex);
        trench.setHeroId(heroId);
        trenchHeroes.put(heroId, trenchIndex);
    }

    public long removeFromTrench(int trenchIndex, boolean inCd) {
        Trench trench = trenches.get(trenchIndex);
        long result = trench.getHeroId();
        trenchHeroes.remove(trench.getHeroId());
        trench.setHeroId(0);
        if (inCd) {
            trench.setLastChangeTime(TimeDateUtil.getCurrentTimeInt());
        }
        return result;
    }
}
