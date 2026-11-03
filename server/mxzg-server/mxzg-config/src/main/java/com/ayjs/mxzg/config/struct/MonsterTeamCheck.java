package com.ayjs.mxzg.config.struct;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/5/9
 **/
public interface MonsterTeamCheck {

    <T extends HeroConfig> List<List<T>> getAllTeams();
}
