/**
 *
 */
package com.ayjs.mxzg.gameserver.module.hero.service.lineup;

import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.module.adven.domain.AdvenMission;
import com.ayjs.mxzg.gameserver.module.adven.service.AdvenMissionService;
import com.ayjs.mxzg.gameserver.module.adven.struct.AdvenSelectAssist;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.hero.struct.HeroPosition;
import com.ayjs.mxzg.gameserver.module.hero.struct.HeroSnapshot;
import com.ayjs.mxzg.gameserver.module.hero.struct.LineUpPredicate;
import com.ayjs.mxzg.gameserver.module.tweakCube.service.TweakCubeService;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

/**
 * @author YY
 *
 */
@Component
public class AdvenLineUpPredicate implements LineUpPredicate {

    @Autowired
    private AdvenMissionService advenMissionService;
    @Autowired
    private HeroService heroService;
    @Autowired
    private TweakCubeService tweakCubeService;

    @Override
    public LineUpType lineUpType() {
        return LineUpType.ADVEN;
    }

    @Override
    public HeroSnapshot pickHero(long rid, long heroId) {
        AdvenMission advenMission = advenMissionService.getAdvenMission(rid);
        List<AdvenSelectAssist> values = advenMission.getSelectAssists();
        Hero hero = heroService.getHero(rid, heroId);
        HeroSnapshot heroSnapshot = new HeroSnapshot();
        if (hero == null) {
            AdvenSelectAssist advenSelectAssist = values.stream().filter(assist -> assist.getHeroVo().getId() == heroId).findFirst().orElse(null);
            if (advenSelectAssist == null) {
                return null;
            }
            heroSnapshot.setRid(advenSelectAssist.getOwnerId());
            heroSnapshot.setId(advenSelectAssist.getHeroVo().getId());
            heroSnapshot.setLevel(advenSelectAssist.getHeroVo().getHero_level());
            heroSnapshot.setType(advenSelectAssist.getHeroVo().getHero_type());
        } else {
            heroSnapshot.setRid(rid);
            heroSnapshot.setId(hero.getId());
            heroSnapshot.setLevel(tweakCubeService.getTweakCubeLvAndStage(hero)[0]);
            heroSnapshot.setType(hero.getType());
        }
        return heroSnapshot;
    }

    @Override
    public void checkLineUp(Map<Long, HeroPosition> heroPos) {
        boolean hadAssist = false;
        for (HeroPosition pos : heroPos.values()) {
            if (pos.getOwnerId() == 0) {
                continue;
            }
            if (hadAssist) {
                Asserts.isTrue(!hadAssist, ErrorCode.ADVEN_HAD_ASSIST_IN_LINE_UP.getValue(), "不能重复上阵支援英雄");
            }
            hadAssist = true;
        }
    }

    @Override
    public void handleAfterLineUpSaved(HeroLineUp heroLineUp) {
        HeroPosition heroPos = null;
        for (HeroPosition tempPos : heroLineUp.getFormationMap().values()) {
            if (tempPos.getOwnerId() != 0) {
                heroPos = tempPos;
                break;
            }
        }
        if (heroPos == null) {
            return;
        }
        AdvenMission advenMission = advenMissionService.getAdvenMission(heroLineUp.getRid());
        List<AdvenSelectAssist> values = advenMission.getSelectAssists();
        AdvenSelectAssist advenSelectAssist = null;
        for (AdvenSelectAssist assist : values) {
            if (assist.getHeroVo().getId() == heroPos.getHeroId()) {
                advenSelectAssist = assist;
                break;
            }
        }
        if (advenSelectAssist == null) {
            return;
        }
        if (!advenSelectAssist.isHadBattle()) {
            advenSelectAssist.setHadBattle(true);
            advenMissionService.updateAdvenMission(advenMission);
            //添加被战斗次数
            AdvenMission friendAdven = advenMissionService.getAdvenMission(advenSelectAssist.getOwnerId());
            friendAdven.setBeSelectNum(friendAdven.getBeSelectNum() + 1);
            advenMissionService.updateAdvenMission(friendAdven);
        }
    }
}
