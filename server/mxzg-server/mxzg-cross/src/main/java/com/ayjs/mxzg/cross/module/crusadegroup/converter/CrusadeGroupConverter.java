package com.ayjs.mxzg.cross.module.crusadegroup.converter;

import com.ayjs.mxzg.battle.model.HeroStatus;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.battle.model.mirror.HeroVo;
import com.ayjs.mxzg.message.module.crusadegroup.map.dto.Garrison;
import com.ayjs.mxzg.message.module.crusadegroup.map.dto.TerritoryGarrison;
import org.springframework.stereotype.Component;

@Component
public class CrusadeGroupConverter {

    /**
     * 根据battlerVo构造npc部队信息
     * @param gId
     * @param fighting
     * @param boss
     * @param battlerVo
     * @return
     */
    public TerritoryGarrison buildFrom(int gId, int fighting, boolean boss, BattlerVo battlerVo, boolean dead){
        TerritoryGarrison territoryGarrison = new TerritoryGarrison();
        territoryGarrison.setId(gId);
        territoryGarrison.setFighting(fighting);
        territoryGarrison.setBoss(boss);
        for (HeroVo hero : battlerVo.getHeros()) {
            long hp = hero.getStatus() == HeroStatus.DEAD.ordinal() || dead ? 0 : hero.getHp() ;
            Garrison garrison = Garrison.valueOf(hero.getHero_type(), hero.getStar(), hero.getLevel(), hp, hero.getMaxHp(), hero.getPos());
            territoryGarrison.getGarrisons().add(garrison);
        }
        return territoryGarrison;
    }

}
