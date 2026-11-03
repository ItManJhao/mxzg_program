package com.ayjs.mxzg.config.excel.entity.stageMatch.cross;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

/**
 * 跨服服务器配置
 */
@Getter
public class CStageCrossServer implements BaseExcelModel {

    private int idx;// 唯一标识键

    private int group_id;//超凡段位赛分组id

    private int server_id;// 游戏服id

    private int merge_server_id;//合服后的服务器id


    @Override
    public int getExcelId() {
        return idx;
    }
}
