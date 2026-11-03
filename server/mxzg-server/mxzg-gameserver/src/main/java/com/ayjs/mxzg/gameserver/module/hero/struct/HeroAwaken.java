package com.ayjs.mxzg.gameserver.module.hero.struct;

import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2021/1/18
 **/
@Getter
@Setter
public class HeroAwaken {
    private List<Integer> baseIndex = new ArrayList<>();
    private List<Integer> specialIndex = new ArrayList<>();

    public void replace(List<Integer> baseIndex, List<Integer> specialIndex) {
        this.baseIndex.clear();
        this.specialIndex.clear();
        this.baseIndex.addAll(baseIndex);
        this.specialIndex.addAll(specialIndex);
    }
}
