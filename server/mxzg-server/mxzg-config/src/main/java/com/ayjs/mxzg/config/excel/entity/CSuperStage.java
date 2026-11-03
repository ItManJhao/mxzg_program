package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;
import org.springframework.util.CollectionUtils;

import java.util.List;

/**
 * 段位表
 */
@Getter
public class CSuperStage implements BaseExcelModel {

    /**
     * 主键
     */
    private int idx;
    /**
     * 积分上限
     */
    private int integral_limit;
    /**
     * 首次奖励
     */
    private ImmutableList<ImmutableThing> first_reward;

    /**
     * 段位奖励
     */
    private ImmutableList<ImmutableThing> stage_reward;
    /**
     * 胜利奖励
     */
    private List<Integer> victory_reward;
    /**
     * 失败奖励
     */
    private List<Integer> failure_reward;
    /**
     * 继承段位
     */
    private int inherit_stage;
    /**
     * 保护积分
     */
    private int protection_integral;
    /**
     * 晋级场数
     */
    private int advance_num;

    /**
     * 晋级需要达到的胜场
     */
    private int advance_win;
    /**
     * 语言表
     */
    private String name_lang;
    /**
     * 对手初始战力比例
     */
    private int initial_fighting_ratio;
    /**
     * 战力范围比例
     */
    private int fighting_range_ratio;

    @Override
    public int getExcelId() {
        return idx;
    }

    /**
     * 是否有首次奖励
     * @return
     */
    public boolean hasFirstReward(){
        return !CollectionUtils.isEmpty(this.first_reward);
    }
}
