/**
 *
 */
package com.ayjs.mxzg.cross.module.hero.service;

import org.springframework.stereotype.Service;

import com.ayjs.mxzg.battle.model.mirror.HeroVo;
import com.ayjs.mxzg.message.module.hero.message.HeroMessage.ResHeroMessage;
import com.ayjs.mxzg.message.module.hero.message.HeroMessage.ResHeroMessage.ResHeroMessageBuilder;

/**
 * @author YY
 *
 */
@Service
public class HeroService {

    public ResHeroMessage serialize(HeroVo heroVo) {
        ResHeroMessageBuilder builder = ResHeroMessage.builder();
        builder.heroId(heroVo.getId());
        builder.heroType(heroVo.getHero_type());
        builder.level(heroVo.getHero_level());
        builder.stage(heroVo.getStage());
        builder.star(heroVo.getHero_star());
        builder.fashionId(heroVo.getFashionId());
        builder.pos(heroVo.getPos());
        builder.hp(heroVo.getHp());
        builder.evolveLevel(heroVo.getEvolve().getLevel());
        builder.evolveType(heroVo.getEvolve().getType());
//TODO	查看个人信息的时候不需要显示英雄的战力，因此此处可以不处理	builder.fighting(heroVo.getH);
        return builder.build();
    }
    
}
