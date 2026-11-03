package com.ayjs.mxzg.battle.model.mirror;

import com.ayjs.mxzg.battle.model.Goddess;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class GoddessVo {

	private int goddessId;	// 羁绊女神id
	private int skillId;	// 技能
	private int level;		// 技能等级
	private long attack;	// 攻击
	private int uplimitLevel;	//突破等级
	private int energy;		//能量
	private boolean saveEnergy;	//是否保存能量
	private int fashionId;	// 皮肤id
	
	public static GoddessVo valueOf(Goddess goddess){
		if(goddess == null){
			return null;
		}
		
		GoddessVo goddessVo = new GoddessVo();
		goddessVo.setGoddessId(goddess.getGoddessId());
		goddessVo.setSkillId(goddess.getSkill().getSkillId());
		goddessVo.setLevel(goddess.getSkill().getSkill().getLevel());
		goddessVo.setAttack(goddess.getAttack());
		goddessVo.setUplimitLevel(goddess.getUplimitLevel());
		goddessVo.setEnergy(goddess.getEnergy());
		goddessVo.setFashionId(goddess.getFashionId());
		return goddessVo;
	}

	/**
	 * 获取能量
	 * @return
	 */
	public int getEnergy(){
		return this.saveEnergy ? this.energy : 0;
	}

}
