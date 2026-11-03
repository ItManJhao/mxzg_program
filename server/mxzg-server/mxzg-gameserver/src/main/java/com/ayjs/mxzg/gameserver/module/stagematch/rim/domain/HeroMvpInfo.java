package com.ayjs.mxzg.gameserver.module.stagematch.rim.domain;

import com.ayjs.mxzg.battle.model.EvolveData;
import com.ayjs.mxzg.battle.model.mirror.HeroVo;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2020/6/22
 **/
@Getter
@Setter
public class HeroMvpInfo {

    private int heroType; //英雄类型
    private int star; //英雄星级
    private int fashionId; //皮肤id
    private int level; //英雄等级
    private EvolveData evolve = new EvolveData();

    public static HeroMvpInfo of(HeroVo heroVo) {
        HeroMvpInfo heroMvpInfo = new HeroMvpInfo();
        heroMvpInfo.heroType = heroVo.getHero_type();
        heroMvpInfo.star = heroVo.getStar();
        heroMvpInfo.level = heroVo.getLevel();
        heroMvpInfo.fashionId = heroVo.getFashionId();
        heroMvpInfo.evolve = EvolveData.of(heroVo.getEvolve());
        return heroMvpInfo;
    }
}
