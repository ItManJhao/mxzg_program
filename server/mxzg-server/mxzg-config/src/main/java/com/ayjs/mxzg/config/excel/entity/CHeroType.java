package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.StringUtil;
import com.ayjs.mxzg.config.struct.DamageType;
import com.google.common.collect.Lists;
import lombok.Getter;

import java.util.List;

/**
 * 英雄类型表
 */
@Getter
public class CHeroType implements BaseExcelModel {
    /**
     * 英雄类型
     */
    private int type;

    private String note;

    private int occupation;

    private int elem;

    private int star;

    private DamageType damage_type;

    private String to_5_star;

    private String to_6_star;

    private String to_7_star;

    private String to_8_star;

    private String to_9_star;

    private String to_10_star;

    private String to_11_star;

    private String to_12_star;

    private String to_13_star;

    private String to_14_star;

    private int skill_1;

    private int skill_2;

    private int skill_3;

    private int skill_4;

    private int skill_5;

    private int item_id;    // 英雄碎片的道具id

    @Override
    public int getExcelId() {
        return type;
    }

    public List<Integer> getStars() {
        List<Integer> stars = Lists.newArrayList(star);
        if (this.star < 4) {
            stars.add(this.star);
            return stars;
        }

        if (this.star >= 4) {
            stars.add(this.star);
        }
        if (StringUtil.isNotBlank(this.to_5_star)) {
            stars.add(5);
        }
        if (StringUtil.isNotBlank(this.to_6_star)) {
            stars.add(6);
        }
        if (StringUtil.isNotBlank(this.to_7_star)) {
            stars.add(7);
        }
        if (StringUtil.isNotBlank(this.to_8_star)) {
            stars.add(8);
        }
        if (StringUtil.isNotBlank(this.to_9_star)) {
            stars.add(9);
        }
        if (StringUtil.isNotBlank(this.to_10_star)) {
            stars.add(10);
        }
        if (StringUtil.isNotBlank(this.to_11_star)) {
            stars.add(11);
        }
        if (StringUtil.isNotBlank(this.to_12_star)) {
            stars.add(12);
        }
        if (StringUtil.isNotBlank(this.to_13_star)) {
            stars.add(13);
        }
        if (StringUtil.isNotBlank(this.to_14_star)) {
            stars.add(14);
        }

        return stars;
    }

}
