package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.StringUtil;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.config.struct.AttributeKind;
import com.ayjs.mxzg.config.struct.EquipInfo;
import com.ayjs.mxzg.config.struct.HeroConfig;
import com.ayjs.mxzg.config.struct.RunesVo;
import com.google.common.collect.ImmutableList;
import com.google.common.reflect.TypeToken;

import lombok.Getter;

@Getter
public class CTower implements BaseExcelModel, HeroConfig {
    /**
     * 幻境之塔id
     */
    private int idx;
    /**
     * 关卡ID
     */
    private int mission_id;
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
    private int hero_level;
    /**
     * 怪物星级
     */
    private int hero_star;
    /**
     * 星际
     */
    private ImmutableList<AttributeKind> attr;

    /**
     * 装备
     */
    private ImmutableList<EquipInfo> equipment;

    /**
     * 铭文
     */
    private ImmutableList<RunesVo> runes;

    @Override
    public int getExcelId() {
        return idx;
    }
    
    @SuppressWarnings("serial")
	public static CTower createOf(String info){
    	if(StringUtil.isEmpty(info)){
    		return null;
    	}
    	CTower tower = new CTower();
    	String[] infoArray = info.split(" ");
    	tower.idx = ConvertUtils.toInt(infoArray[0]);
    	tower.mission_id = ConvertUtils.toInt(infoArray[1]);
    	tower.pos = ConvertUtils.toInt(infoArray[2]);
    	tower.hero_type = ConvertUtils.toInt(infoArray[3]);
    	tower.hero_level = ConvertUtils.toInt(infoArray[4]);
    	tower.hero_star = ConvertUtils.toInt(infoArray[5]);
    	tower.attr = GsonUtils.fromJson(infoArray[6], new TypeToken<ImmutableList<AttributeKind>>(){});
    	tower.equipment = GsonUtils.fromJson(infoArray[7], new TypeToken<ImmutableList<EquipInfo>>(){});
    	tower.runes = GsonUtils.fromJson(infoArray[8], new TypeToken<ImmutableList<RunesVo>>(){});
    	return tower;
    }
    
}
