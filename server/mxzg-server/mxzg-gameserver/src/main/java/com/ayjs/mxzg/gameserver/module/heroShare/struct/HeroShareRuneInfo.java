package com.ayjs.mxzg.gameserver.module.heroShare.struct;

import java.util.ArrayList;
import java.util.List;

import com.ayjs.mxzg.config.struct.RuneSkill;

import lombok.Getter;
import lombok.Setter;

/**
 * 符文镜像数据
 * @author hyx
 */
@Getter
@Setter
public class HeroShareRuneInfo {

    private int runeType;

    private int abilityId;

    private List<RuneSkill> skillList = new ArrayList<>();

}
