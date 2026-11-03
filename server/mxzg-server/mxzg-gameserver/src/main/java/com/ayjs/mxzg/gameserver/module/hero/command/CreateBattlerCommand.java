package com.ayjs.mxzg.gameserver.module.hero.command;

import com.ayjs.mxzg.battle.model.DragonInfo;
import com.ayjs.mxzg.battle.model.Goddess;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.command.Command;
import com.ayjs.mxzg.config.struct.LineUpType;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

/**
 * 创建Battler指令
 */
@Getter
@Setter
public class CreateBattlerCommand implements Command {

    /**
     * 玩家id
     */
    private long playerId;

    /**
     * 阵容类型
     */
    private LineUpType lineUpType;

    /**
     * do列表该列表英雄属性不能包含羁绊女神跟阵容加成
     */
    private List<HeroDo> heroDos;

    /**
     * 神龙
     */
    private DragonInfo dragonInfo;

    /**
     * 女神
     */
    private Goddess goddess;

    /**
     * 阵法id
     */
    private int formationId;

    public static CreateBattlerCommand createOf(long playerId, LineUpType lineUpType, List<HeroDo> heroDos) {
        CreateBattlerCommand command = new CreateBattlerCommand();
        command.setHeroDos(heroDos);
        command.setPlayerId(playerId);
        command.setLineUpType(lineUpType);
        return command;
    }
}
