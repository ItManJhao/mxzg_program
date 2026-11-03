package com.ayjs.mxzg.config.excel.entity.promotion072;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 诸神祭坛层级信息
 */
@Getter
public class CPromotion072floor implements BaseExcelModel {

    private int idx;
    private int floor;//层级
    private int min_count;//最少几次才出（解锁道具）
    private int max_count;//最多几次必出（解锁道具）
    private ImmutableList<ImmutableThing> cost_item;//每次抽取消耗道具
    private ImmutableList<ImmutableThing> cost_money;//消耗游戏币抽取
    private int lock_reward;//解锁道具(关联promotion072reward.xlsx表的idx)
    private int star_server_day;//配置读取开始天数
    private int end_server_day;//配置读取结束天数

    @Override
    public int getExcelId() {
        return idx;
    }
}
