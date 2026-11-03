package com.ayjs.mxzg.battle.model;

import com.ayjs.mxzg.protocol.BattleGMsg.DragonUnit;
import lombok.Data;

import java.util.stream.Collectors;


@Data(staticConstructor = "of")
public class DragonInfo {

    private int unitId;	//单位id
    private final int dragonId;  // 等级
    private final SkillInfo skillInfo;    // 技能信息
    private final AttributeInfo attributeInfo;    // 属性信息
    private HeroDo camouflage;	//伪装成一个英雄

    /**
     * 获取技能
     * @currentRound
     * @return
     */
    public SkillDo getSkill(int currentRound){
        return camouflage.getSkill(currentRound);
    }

    /**
     * 初始化神龙
     * @param unitId
     * @param faction
     */
    public void initialize(int unitId, Faction faction){
        this.unitId = unitId;
        HeroDo.HeroDoBuilder builder = HeroDo.builder();
        builder.unitId(unitId).faction(faction).attributeInfo(attributeInfo);
        builder.skillInfo(this.skillInfo).actionInfo(ActionInfo.getInstance());
        this.camouflage = builder.build();
        this.camouflage.initAttribute();
    }

    /**
     * 转换成协议对象
     * @return
     */
    public DragonUnit toDragonUnit(){
        DragonUnit.Builder builder = DragonUnit.newBuilder();
        builder.setUnitId(this.unitId).setDragonId(this.dragonId);
        builder.addAllSkillId(this.skillInfo.getActiveSkills().stream().map(SkillDo::getSkillId).collect(Collectors.toList()));
        return builder.build();
    }

}
