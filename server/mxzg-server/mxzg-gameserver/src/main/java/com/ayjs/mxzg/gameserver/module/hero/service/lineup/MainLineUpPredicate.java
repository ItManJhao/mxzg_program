/**
 *
 */
package com.ayjs.mxzg.gameserver.module.hero.service.lineup;

import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.constant.HeroConst;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.hero.struct.HeroPosition;
import com.ayjs.mxzg.gameserver.module.hero.struct.HeroSnapshot;
import com.ayjs.mxzg.gameserver.module.hero.struct.LineUpPredicate;
import com.ayjs.mxzg.gameserver.module.tweakCube.service.TweakCubeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @author YY
 *
 */
@Component
public class MainLineUpPredicate implements LineUpPredicate {

    @Autowired
    private HeroService heroService;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private TweakCubeService tweakCubeService;

    @Override
    public LineUpType lineUpType() {
        return LineUpType.MAIN;
    }

    @Override
    public HeroSnapshot pickHero(long rid, long heroId) {
        Hero hero = heroService.getHero(rid, heroId);
        if (hero == null) {
            return null;
        }
        HeroSnapshot heroSnapshot = new HeroSnapshot();
        heroSnapshot.setRid(rid);
        heroSnapshot.setId(hero.getId());
        heroSnapshot.setLevel(tweakCubeService.getTweakCubeLvAndStage(hero)[0]);
        heroSnapshot.setType(hero.getType());
        return heroSnapshot;
    }

    @Override
    public void handleAfterLineUpSaved(HeroLineUp heroLineUp) {
        if (heroLineUp.getType() != LineUpType.MAIN.getValue()) {
            return;
        }
        heroLineUpService.updateRoleFighting(heroLineUp.getRid(), GameEvent.HERO_UP_LINE);

        Map<Long, HeroPosition> langupHeroPos = new HashMap<>();
        HeroLineUp langUp = heroLineUpService.getLineUpByType(heroLineUp.getRid(), LineUpType.LANG_UP);
        int size = heroLineUp.getFormationMap().size();
        if (size <= HeroConst.LANG_UP_MAX_HERO_NUM) {
            langupHeroPos.putAll(heroLineUp.getFormationMap());
        } else {
            List<Long> heroIds = new ArrayList<>(heroLineUp.getFormationMap().keySet());
            List<Long> randomHeros = RandomUtil.randomList(heroIds, HeroConst.LANG_UP_MAX_HERO_NUM);
            langupHeroPos = randomHeros.stream().map(heroLineUp.getFormationMap()::get).collect(Collectors.toMap(HeroPosition::getHeroId, hero -> hero));
        }
        langUp.setTime(TimeDateUtil.getCurrentTimeInt());
        langUp.getFormationMap().clear();
        langUp.getFormationMap().putAll(langupHeroPos);
        heroLineUpService.updateHeroLineUp(langUp);
    }
}
