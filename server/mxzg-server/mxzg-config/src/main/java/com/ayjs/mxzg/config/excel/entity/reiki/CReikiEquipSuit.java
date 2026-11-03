package com.ayjs.mxzg.config.excel.entity.reiki;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.google.common.collect.ImmutableMap;
import lombok.Getter;
import org.springframework.stereotype.Component;

/**
 * 灵器套装配置表
 * @author
 */
@Getter
public class CReikiEquipSuit implements BaseExcelModel {

    private int suit_id;

    private int active_need_num;

    private ImmutableMap<AttributeType, Long> suit_ability;

    /**
     * 技能
     */
    private int skill;

    /**
     * 技能等级
     */
    private int skill_level;


    @Override
    public int getExcelId() {
        return suit_id;
    }
}
