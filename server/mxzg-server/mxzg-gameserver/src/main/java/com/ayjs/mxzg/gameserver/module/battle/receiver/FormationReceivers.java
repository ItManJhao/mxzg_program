/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.battle.receiver;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.ayjs.mxzg.battle.command.QueryBattleCommand;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.command.Receivers;
import com.ayjs.mxzg.common.command.annotation.Invoker;
import com.ayjs.mxzg.config.excel.cache.BattleMatrixAdditionSysCache;
import com.ayjs.mxzg.config.excel.entity.CBattleMatrixAddition;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.module.hero.command.CreateBattlerCommand;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;

/**
 *
 */
@Component
public class FormationReceivers implements Receivers {
	
	@Autowired
	private HeroLineUpService heroLineUpService;
    @Autowired
    private BattleMatrixAdditionSysCache battleMatrixAdditionSysCache;
    
	
	@Invoker
    public void onQueryBattleHeroCommand(QueryBattleCommand command) {
        int formationId = setAttribute(command.getPlayerId(), command.getLineUpType(), command.getHeros());
        command.setFormationId(formationId);
    }

    @Invoker
    public void onCreateBattlerCommand(CreateBattlerCommand command) {
        int formationId = setAttribute(command.getPlayerId(), command.getLineUpType(),command.getHeroDos());
        command.setFormationId(formationId);
    }

    /**
     * 设置阵法属性
     * @param rid
     * @return
     */
    private int setAttribute(long rid, LineUpType lineUpType, List<HeroDo> heros){
		HeroLineUp heroLineUp = heroLineUpService.getLineUpByType(rid, lineUpType);
		if(heroLineUp.getFormationId() == 0){
			return 0;
		}

		Map<Integer, CBattleMatrixAddition> matrixMap = battleMatrixAdditionSysCache.getMatrix(heroLineUp.getFormationId());
		if(matrixMap == null) {
			return 0;
		}
        for (HeroDo hero : heros) {
        	CBattleMatrixAddition addition = matrixMap.get(hero.getPosition());
            if(addition != null){
                hero.getAttributeInfo().addAllAttribute(addition.getAbility());
            }
        }
        return heroLineUp.getFormationId();
    }
}
