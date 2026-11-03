package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

/**
 * 服务器可见配置（暂时：主要影响同省频道聊天是否可见）
 */
@Getter
public class CCenterServer implements BaseExcelModel {

    private int server_id;// 分区id

    private int group_id;// 显示分组id

    @Override
    public int getExcelId() {
        return server_id;
    }
}
