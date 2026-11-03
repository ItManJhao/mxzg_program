/**
 *
 */
package com.ayjs.mxzg.gameserver.module.hero.command;

import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.command.Command;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

import java.util.List;

/**
 * 计算英雄列表的战力
 */
@Getter
@Setter
@RequiredArgsConstructor
public class CalHerosFightingCommand implements Command {

    /** 英雄do信息 */
    private final List<HeroDo> heroDos;

    /** 阵容战力 */
    private int fighting;

    public static CalHerosFightingCommand createOf(List<HeroDo> heroDos) {
        return new CalHerosFightingCommand(heroDos);
    }
}
