/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.hero.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.cache.TalentSysCache;
import com.ayjs.mxzg.config.excel.constant.HeroConst;
import com.ayjs.mxzg.config.excel.entity.CTalent;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroTalentChangeEvent;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.hero.struct.Talent;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.HeroTalentGMsg.*;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;


/**
 * @author YY
 *
 */
@Controller
public class HeroTalentHandler extends ProtocolHandler {
	
	@Autowired
	private HeroService heroService;
	@Autowired
	private ThingService thingService;
	@Autowired
	private TalentSysCache talentSysCache;
	@Autowired
	private EventBus eventBus;
	
	@CMD(id = CmdCode._4301)
	public void learnTalent(PlayerContext playerContext, GReqHeroTalentLearn msg) {
		
		Integer needStar = HeroConst.TALENT_STAR.get(msg.getSlot());
		Asserts.isTrue(needStar != null, ErrorCode.ERROR_PARAM.getValue(), "参数错误" + msg.getSlot());
		
		Hero hero = heroService.getHero(playerContext.getId(), msg.getHeroId());
		Asserts.isTrue(hero != null, ErrorCode.HERO_NOT_EXIST.getValue(), "找不到英雄" + msg.getHeroId());
		
		Talent talent = hero.getTalents().get(msg.getSlot());
		if(talent == null) {
			Asserts.isTrue(hero.getStar() >= needStar, ErrorCode.HERO_TALENT_STAR_LOW.getValue(), "还没有达到领悟该天赋的星级");
		} else {
			Asserts.isTrue(talent.getSkillId() == 0, ErrorCode.HERO_TALENT_NOT_EMPTY.getValue(), "请先遗忘原先天赋再重新领悟");
		}
		
		CTalent cTalent = talentSysCache.getTalent(msg.getSkillId(), 1);
		Asserts.isTrue(!hero.isRepetitiveSkills(cTalent.getSkill_type()), ErrorCode.HERO_TALENT_REPETITIVE.getValue(), "无法重复领悟相同的技能");

		thingService.cost(playerContext.getId(), cTalent.getUpgrade_need(), GameEvent.TALENT_LEARN);
		
		if(talent == null) {
			talent = new Talent();
			talent.setSort(msg.getSlot());
			hero.getTalents().put(msg.getSlot(), talent);
		}
		
		talent.setSkillId(msg.getSkillId());
		talent.setLevel(1);
		heroService.updateHero(hero);
		
		GResHeroTalentLearn.Builder builder = GResHeroTalentLearn.newBuilder();
		builder.setHeroId(hero.getId());
		builder.setTalent(PbUtil.serializeTalent(talent));
		playerContext.write(CmdCode._4301, builder.build());
		
		eventBus.post(HeroTalentChangeEvent.of(hero, GameEvent.TALENT_LEARN));
	}
	
	@CMD(id = CmdCode._4302)
	public void upgradeTalent(PlayerContext playerContext, GReqHeroTalentUpgrade msg) {
		Hero hero = heroService.getHero(playerContext.getId(), msg.getHeroId());
		Asserts.isTrue(hero != null, ErrorCode.HERO_NOT_EXIST.getValue(), "找不到英雄" + msg.getHeroId());
		
		Talent talent = hero.getTalents().get(msg.getSlot());
		Asserts.isTrue(talent != null, ErrorCode.HERO_TALENT_NOT_LEARN.getValue(), "还没有领悟到天赋");
		Asserts.isTrue(talent.getSkillId() != 0, ErrorCode.HERO_TALENT_NOT_LEARN.getValue(), "还没有领悟到天赋");
		
		CTalent cTalent = talentSysCache.getTalent(talent.getSkillId(), talent.getLevel() + 1);
		thingService.cost(playerContext.getId(), cTalent.getUpgrade_need(), GameEvent.TALENT_UPGRADE);
		
		talent.setLevel(talent.getLevel() + 1);
		heroService.updateHero(hero);
		
		GResHeroTalentUpgrade.Builder builder = GResHeroTalentUpgrade.newBuilder();
		builder.setHeroId(hero.getId());
		builder.setTalent(PbUtil.serializeTalent(talent));
		playerContext.write(CmdCode._4302, builder.build());
		
		eventBus.post(HeroTalentChangeEvent.of(hero, GameEvent.TALENT_UPGRADE));
	}
	
	@CMD(id = CmdCode._4303)
	public void forgetTalent(PlayerContext playerContext, GReqHeroTalentForget msg) {
		Hero hero = heroService.getHero(playerContext.getId(), msg.getHeroId());
		Asserts.isTrue(hero != null, ErrorCode.HERO_NOT_EXIST.getValue(), "找不到英雄" + msg.getHeroId());
		
		Talent talent = hero.getTalents().get(msg.getSlot());
		Asserts.isTrue(talent != null, ErrorCode.HERO_TALENT_NOT_LEARN.getValue(), "还没有领悟到天赋");
		Asserts.isTrue(talent.getSkillId() != 0, ErrorCode.HERO_TALENT_NOT_LEARN.getValue(), "还没有领悟到天赋");
		
		CTalent cTalent = talentSysCache.getTalent(talent.getSkillId(), talent.getLevel());
		thingService.cost(playerContext.getId(), cTalent.getForget_need(), GameEvent.TALENT_FORGET);
		//遗忘返还
		thingService.add(playerContext.getId(), cTalent.getForget_reward(), GameEvent.TALENT_FORGET);
		
		talent.setSkillId(0);
		talent.setLevel(0);
		heroService.updateHero(hero);
		
		GResHeroTalentForget.Builder builder = GResHeroTalentForget.newBuilder();
		builder.setHeroId(hero.getId());
		builder.setTalent(PbUtil.serializeTalent(talent));
		playerContext.write(CmdCode._4303, builder.build());
		
		eventBus.post(HeroTalentChangeEvent.of(hero, GameEvent.TALENT_FORGET));
	}
}
