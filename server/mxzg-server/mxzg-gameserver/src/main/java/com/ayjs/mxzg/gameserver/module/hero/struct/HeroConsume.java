package com.ayjs.mxzg.gameserver.module.hero.struct;

import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2020/7/15
 **/
@Getter
@Setter
public class HeroConsume {

    /***
     * -1代表本体类型，0代表不限制英雄类型
     */
    private int type;
    private int star;
    private int num;

    public static HeroConsume of(Hero hero) {
        HeroConsume heroConsume = new HeroConsume();
        heroConsume.type = hero.getType();
        heroConsume.star = hero.getStar();
        heroConsume.num = 1;
        return heroConsume;
    }
}
