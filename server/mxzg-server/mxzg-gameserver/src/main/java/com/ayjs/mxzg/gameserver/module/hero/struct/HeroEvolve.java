package com.ayjs.mxzg.gameserver.module.hero.struct;

import com.google.common.collect.ImmutableList;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/7/15
 **/
@Getter
@Setter
public class HeroEvolve {
    private int type;
    private int level;

    private List<HeroConsume> hadConsume = new ArrayList();

    /***
     * 重置，返回消耗列表
     * @return
     */
    public List<HeroConsume> reset() {
        this.type = 0;
        this.level = 0;
        List<HeroConsume> list = ImmutableList.copyOf(hadConsume);
        hadConsume.clear();
        return list;
    }

    public static HeroEvolve of(int type, int level) {
        HeroEvolve heroEvolve = new HeroEvolve();
        heroEvolve.type = type;
        heroEvolve.level = level;
        return heroEvolve;
    }
}
