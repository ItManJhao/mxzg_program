/**
 *
 */
package com.ayjs.mxzg.gameserver.module.hero.service.lineup;

import com.ayjs.mxzg.gameserver.module.tweakCube.service.TweakCubeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.ayjs.mxzg.battle.model.mirror.HeroVo;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.module.dreamland.service.DreamlandService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.hero.struct.HeroSnapshot;
import com.ayjs.mxzg.gameserver.module.hero.struct.LineUpPredicate;

/**
 * @author YY
 *
 */
@Component
public class DreamLandLineUpPredicate implements LineUpPredicate {

    @Autowired
    private DreamlandService dreamlandService;
    @Autowired
    private HeroService heroService;
    @Autowired
    private TweakCubeService tweakCubeService;

    @Override
    public LineUpType lineUpType() {
        return LineUpType.DREAMLAND;
    }

    @Override
    public HeroSnapshot pickHero(long rid, long heroId) {
        HeroVo assistVo = dreamlandService.getMySelectAssist(rid);
        HeroSnapshot heroSnapshot = new HeroSnapshot();
        if (assistVo != null && heroId == assistVo.getId()) {
            //TODO
            heroSnapshot.setRid(0);
            heroSnapshot.setId(assistVo.getId());
            heroSnapshot.setType(assistVo.getHero_type());
            heroSnapshot.setLevel(assistVo.getHero_level());
        } else {
            Hero hero = heroService.getHero(rid, heroId);
            if (hero == null) {
                return null;
            }
            heroSnapshot.setRid(rid);
            heroSnapshot.setId(hero.getId());
            heroSnapshot.setLevel(tweakCubeService.getTweakCubeLvAndStage(hero)[0]);
            heroSnapshot.setType(hero.getType());
        }
        return heroSnapshot;
    }
}
