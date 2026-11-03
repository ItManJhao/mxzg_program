package com.ayjs.mxzg.battle.command;

import com.ayjs.mxzg.battle.model.DragonInfo;
import com.ayjs.mxzg.battle.model.Goddess;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.command.Command;
import com.ayjs.mxzg.config.struct.LineUpType;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

/**
 * 查询战场英雄指令
 * @author meiyc
 *
 */
@Getter
@Setter
public class QueryBattleCommand implements Command {

	/** 玩家id */
	private long playerId;
	
	/** 阵容类型 */
	private LineUpType lineUpType;
	
	/** 女神 */
	private Goddess goddess;

	/** 圣龙 */
	private DragonInfo dragonInfo;
	
	/** 英雄列表 */
	private List<HeroDo> heros;

	/** 阵法id */
	private int formationId;
	
	public static QueryBattleCommand createOf(long playerId, LineUpType lineUpType){
		QueryBattleCommand command = new QueryBattleCommand();
		command.setPlayerId(playerId);
		command.setLineUpType(lineUpType);
		return command;
	}
	
}
