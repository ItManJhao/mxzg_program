/**
 *
 */
package com.ayjs.mxzg.gameserver.module.hero.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroScore;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroScoreService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.hero.struct.HeroPosition;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.HeroScoreGMsg.GReqScanHeroScore;
import com.ayjs.mxzg.protocol.HeroScoreGMsg.GResScanHeroScore;
import com.ayjs.mxzg.protocol.HeroScoreGMsg.PSHeroCompare;
import com.ayjs.mxzg.protocol.HeroScoreGMsg.PSHeroScore;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

/**
 * @author YY
 *
 */
@Controller
public class HeroScoreHandler extends ProtocolHandler {

    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private HeroService heroService;
    @Autowired
    private HeroScoreService heroScoreService;

    @CMD(id = CmdCode._56001)
    public void scanHeroScore(PlayerContext playerContext, GReqScanHeroScore msg) {
        HeroLineUp heroLineUp = heroLineUpService.getLineUpByType(playerContext.getId(), LineUpType.MAIN);

        GResScanHeroScore.Builder builder = GResScanHeroScore.newBuilder();

        List<HeroPosition> posiList = new ArrayList<>(heroLineUp.getFormationMap().values());
        posiList.sort(Comparator.comparingInt(HeroPosition::getPos));

        for (HeroPosition heroPos : posiList) {
            Hero hero = heroService.getHero(playerContext.getId(), heroPos.getHeroId());

            HeroScore heroScore = heroScoreService.getScore(hero.getType());

            PSHeroCompare.Builder model = PSHeroCompare.newBuilder();
            model.setTop(serializeScore(heroScore));
            model.setMine(heroScoreService.countScore(hero, heroLineUp.getGoddessType()));
            model.setLevel(hero.getLevel());
            model.setStar(hero.getStar());
            model.setPos(heroPos.getPos());
            model.setEvolve(PbUtil.builderEvolve(hero));
            builder.addHeros(model.build());
        }
        playerContext.write(CmdCode._56001, builder.build());
    }

    private PSHeroScore serializeScore(HeroScore heroScore) {
        PSHeroScore.Builder builder = PSHeroScore.newBuilder();
        builder.setType((int) heroScore.getId());
        builder.setScore(heroScore.getScore());
        builder.setLevel(heroScore.getLevel());
        builder.setStar(heroScore.getStar());
        builder.setEquip(heroScore.getEquip());
        builder.setGrade(heroScore.getGrade());
        builder.setFetter(heroScore.getFetter());
        builder.setClanSkill(heroScore.getClanSkill());
        builder.setRunes(heroScore.getRunes());
        return builder.build();
    }

}
