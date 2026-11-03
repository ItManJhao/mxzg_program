package com.ayjs.mxzg.config.excel.entity.countrywar;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeKind;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Getter
public class CCountryWarCity implements BaseExcelModel {

    private int idx;
    /***
     * 1.大本营
     * 2.城池
     * 3.npc城池
     */
    private int type;

    /***
     * 大本营类型1->4;
     */
    private int camp;
    /****
     * 是否可以被攻击
     */
    private int can_attack;
    /***
     * 驻守人数
     */
    private int accommodate_count;
    /***
     * 防守时增加属性
     */
    private List<AttributeKind> add_attr;
    /***
     * 孤立时减属性
     */
    private List<AttributeKind> reduce_attr;
    /***
     * 攻击消耗
     */
    private int attack_cost;
    /***
     * 迁移消耗
     */
    private int move_cost;
    /***
     * 交战持续时间
     */
    private int war_duration;
    /***
     * 奖励间隔
     */
    private int reward_interval;
    /***
     * 积分
     */
    private int score;
    /***
     * 奖励
     */
    private ImmutableList<ImmutableThing> reward;
    /***
     * 语言key
     */
    private String[] lan_id;
    /***
     * 首次占领积分
     */
    private int first_score;

    @Override
    public int getExcelId() {
        return idx;
    }
}
