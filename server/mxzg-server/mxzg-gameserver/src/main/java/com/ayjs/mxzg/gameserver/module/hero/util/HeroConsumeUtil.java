package com.ayjs.mxzg.gameserver.module.hero.util;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.struct.HeroConsume;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/7/15
 **/
public class HeroConsumeUtil {

    /***
     * 验证消耗和英雄列表是否匹配
     * @param heroConsume
     * @param heroes
     * @param identify
     *          本体
     * @return
     */
    public static boolean matchConsume(HeroConsume heroConsume, List<Hero> heroes, Hero identify) {
        if (CollectionUtil.isEmpty(heroes)) {
            if (heroConsume.getNum() == 0) {
                return true;
            } else {
                return false;
            }
        }
        if (heroes.size() != heroConsume.getNum()) {
            return false;
        }
        long num = heroes.stream().filter(hero -> matchHero(heroConsume, identify, hero)).count();
        return heroConsume.getNum() == num;
    }

    private static boolean matchHero(HeroConsume heroConsume, Hero identify, Hero hero) {
        if (identify == null) {
            if (heroConsume.getType() != hero.getType() || heroConsume.getType() != 0) {
                return false;
            }
            if (heroConsume.getStar() > hero.getStar()) {
                return false;
            }
            return true;
        } else {
            if (heroConsume.getType() == -1 && identify.getType() != hero.getType()) {
                return false;
            }
            if (heroConsume.getType() > 0 && heroConsume.getType() != hero.getType()) {
                return false;
            }
            if (heroConsume.getStar() > hero.getStar()) {
                return false;
            }
            return true;
        }
    }
}
