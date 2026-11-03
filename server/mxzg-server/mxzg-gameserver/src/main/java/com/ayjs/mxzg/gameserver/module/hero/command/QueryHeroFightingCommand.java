package com.ayjs.mxzg.gameserver.module.hero.command;

import com.ayjs.mxzg.common.command.Command;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

/**
 * 查询英雄战力指令
 */
@Getter
@Setter
@RequiredArgsConstructor
public class QueryHeroFightingCommand implements Command {

    /** 英雄 */
    private final Hero hero;

    /** 模块类型 */
    private final ModuleType type;

    /** 战力 */
    private int fighting;

    public static QueryHeroFightingCommand createOf(Hero hero, ModuleType type){
        return new QueryHeroFightingCommand(hero, type);
    }

}
