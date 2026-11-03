package com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.service;

import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.hero.struct.HeroPosition;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.dao.PreliminariesLadderDao;
import com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.domain.PreliminariesLadder;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GResPinnacleLineData;
import com.ayjs.mxzg.protocol.PinnacleGMsg.PSPinnacleHero;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Objects;

/**
 * 巅峰赛天梯
 */
@Service
@Slf4j
public class PreliminariesService {

    @Autowired
    private PreliminariesLadderDao preliminariesLadderDao;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private HeroService heroService;


    public PreliminariesLadder getLadder(long rid) {
        PreliminariesLadder ladder = preliminariesLadderDao.get(rid);
        if (Objects.isNull(ladder)) {
            ladder = new PreliminariesLadder();
            ladder.setRid(rid);
            ladder.setRefreshDateTime(LocalDate.now());
            ladder.setLastRefreshDefend(LocalDateTime.now());
            preliminariesLadderDao.add(ladder);
        } else if (!ladder.getRefreshDateTime().isEqual(LocalDate.now())) {
            ladder.dailyReset();
            updateLadder(ladder);
        }

        return ladder;
    }

    public void updateLadder(PreliminariesLadder ladder) {
        preliminariesLadderDao.update(ladder);
    }

    /***
     * 构建我的battleDO
     * @param rid
     * @return
     */
    public HeroLineUp getMyDefendLineUp(long rid) {
        HeroLineUp lineUpByType = heroLineUpService.getLineUpOr(rid, LineUpType.PINNACLE, LineUpType.STAGE_MATCH);
        if (lineUpByType.getFormationMap().size() > 0) {
            return lineUpByType;
        } else {
            return heroLineUpService.getLineUpByType(rid, LineUpType.STAGE_MATCH);
        }
    }


    public GResPinnacleLineData.Builder builderLineup(long rid) {
        GResPinnacleLineData.Builder builder = GResPinnacleLineData.newBuilder();
        HeroLineUp lineUpData = getMyDefendLineUp(rid);
        Role role = roleService.getOrThrow(rid);
        for (HeroPosition heroPosition : lineUpData.getFormationMap().values()) {
            Hero hero = heroService.getHero(rid, heroPosition.getHeroId());
            if (Objects.nonNull(hero)) {
                PSPinnacleHero.Builder pinnacleHero = PSPinnacleHero.newBuilder();
                pinnacleHero.setHeroType(hero.getType());
                pinnacleHero.setLevel(hero.getLevel());
                pinnacleHero.setStar(hero.getStar());
                pinnacleHero.setPos(heroPosition.getPos());
                pinnacleHero.setId(hero.getId());
                builder.addHeros(pinnacleHero);
            }
        }
        builder.setFormationId(lineUpData.getFormationId());
        builder.setFight(heroLineUpService.getLineUpFighting(lineUpData));
        return builder;
    }


}
