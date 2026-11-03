package com.ayjs.mxzg.gameserver.module.crusadegroup.group.converter;

import com.ayjs.mxzg.config.excel.constant.CrusadeGroupConst;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain.CrusadeGroupHero;
import com.ayjs.mxzg.gameserver.module.hero.dao.HeroDao;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.message.module.crusadegroup.group.dto.Territory;
import com.ayjs.mxzg.message.module.crusadegroup.map.dto.Garrison;
import com.ayjs.mxzg.message.module.crusadegroup.map.dto.TerritoryGarrison;
import com.ayjs.mxzg.protocol.CrusadeGroupGMsg;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@Component
public class CrusadeGroupConverter {

    @Autowired
    private HeroDao heroDao;

    /**
     * 构建英雄宝箱列表
     * @param heroes
     * @return
     */
    public List<CrusadeGroupGMsg.PSHeroBox> buildHeroBoxList(Collection<CrusadeGroupHero> heroes){
        return heroes.stream().map(this::buildHeroBox).collect(Collectors.toList());
    }

    /**
     * 构造标记列表
     * @param marks
     * @return
     */
    public List<CrusadeGroupGMsg.PSTerritoryMark> buildMarkList(Map<Integer, String> marks){
        return marks.entrySet().stream().map(entry -> CrusadeGroupGMsg.PSTerritoryMark.newBuilder()
                .setTerritoryId(entry.getKey()).setName(entry.getValue()).build()).collect(Collectors.toList());
    }

    /**
     * 构建英雄盒子
     * @param hero
     * @return
     */
    public CrusadeGroupGMsg.PSHeroBox buildHeroBox(CrusadeGroupHero hero){
        CrusadeGroupGMsg.PSHeroBox.Builder box = CrusadeGroupGMsg.PSHeroBox.newBuilder();
        box.setBoxId(hero.getId());
        box.setPhysicalStrength(hero.getPhysicalStrength());

        CrusadeGroupGMsg.PSHero psHero = buildHero(hero.getHeroId(), hero.getDevelopmentTerritoryId());
        if(psHero != null){
            box.setHero(psHero);
        }
        return box.build();
    }

    /**
     * 构建英雄
     * @param heroId
     * @param developmentTerritoryId
     * @return
     */
    public CrusadeGroupGMsg.PSHero buildHero(long heroId, int developmentTerritoryId){
        if(heroId == 0){
            return null;
        }

        Hero hero = heroDao.get(heroId);
        if(hero == null){
            return null;
        }
        CrusadeGroupGMsg.PSHero.Builder psHero = CrusadeGroupGMsg.PSHero.newBuilder();
        psHero.setStage(hero.getStage()).setHeroId(heroId).setHeroType(hero.getType());
        psHero.setLevel(CrusadeGroupConst.CRUSADE_GROUP_HERO_LEVEL).setStar(hero.getStar());
        psHero.setDevelopmentStatus(developmentTerritoryId != 0);
        return psHero.build();
    }

    /**
     * 构造领地
     * @param territory
     * @return
     */
    public CrusadeGroupGMsg.PSTerritory buildTerritory(Territory territory){
        CrusadeGroupGMsg.PSTerritory.Builder psTerritory = CrusadeGroupGMsg.PSTerritory.newBuilder();
        psTerritory.setId(territory.getId());
        psTerritory.setHeroId(territory.getHeroId());
        psTerritory.setOccupiedId(territory.getOccupierId());
        psTerritory.setElement(territory.getElementId());
        return psTerritory.build();
    }

    /**
     * 构造npc阵容
     * @param territoryGarrison
     * @return
     */
    public CrusadeGroupGMsg.PSNpcFormation buildFrom(TerritoryGarrison territoryGarrison){
        CrusadeGroupGMsg.PSNpcFormation.Builder builder = CrusadeGroupGMsg.PSNpcFormation.newBuilder();
        builder.setFormationId(territoryGarrison.getId());
        builder.setFighting(territoryGarrison.getFighting());
        builder.setBoss(territoryGarrison.isBoss());
        for (Garrison garrison : territoryGarrison.getGarrisons()) {
            CrusadeGroupGMsg.PSNpcHero.Builder heroBuilder = CrusadeGroupGMsg.PSNpcHero.newBuilder();
            heroBuilder.setHeroType(garrison.getHero_type());
            heroBuilder.setStar(garrison.getStar());
            heroBuilder.setHp(garrison.getHp());
            heroBuilder.setMaxHp(garrison.getMax_hp());
            heroBuilder.setPosition(garrison.getPosition());
            heroBuilder.setLevel(garrison.getLevel());
            builder.addHero(heroBuilder);
        }
        return builder.build();
    }

}
