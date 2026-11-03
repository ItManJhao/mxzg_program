package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 点赞评论分享奖励
 */
@Getter
public class CCommentSharedReward implements BaseExcelModel {

    private int idx;// 唯一标识键

    private ImmutableList<ImmutableThing> reward; // 奖励

    @Override
    public int getExcelId() {
        return idx;
    }
}
