package com.ayjs.mxzg.config.excel.entity;

import java.util.List;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeKind;
import com.ayjs.mxzg.config.struct.EquipInfo;
import com.ayjs.mxzg.config.struct.HeroConfig;
import com.ayjs.mxzg.config.struct.RunesVo;

import lombok.Getter;


@Getter
public class CGuideBattle implements BaseExcelModel, HeroConfig {

    /**
     * 关卡id
     */
    private int idx;
    /**
     * 队伍编号
     */
    private int team;
    /**
     * 怪物站位
     */
    private int pos;
    /**
     * 怪物类型
     */
    private int hero_type;
    /**
     * 怪物等级
     */
    private int level;
    
    /**
     * 等阶
     */
    private int stage;
    /**
     * 怪物星级
     */
    private int star;

    /**
     * 攻击倍率
     */
    private int atk_multiple;
    
    /**
     * 加成属性
     */
    private List<AttributeKind> attr;

    @Override
    public int getExcelId() {
        return idx;
    }

	@Override
	public int getHero_level() {
		return level;
	}

	@Override
	public int getHero_star() {
		return star;
	}
	
	@Override
	public List<AttributeKind> getAttr() {
		return this.attr;
	}
	
	public void setAttr(List<AttributeKind> attributeKinds){
		this.attr = attributeKinds;
	}

	@Override
	public List<EquipInfo> getEquipment() {
		return null;
	}

	@Override
	public List<RunesVo> getRunes() {
		return null;
	}
}
