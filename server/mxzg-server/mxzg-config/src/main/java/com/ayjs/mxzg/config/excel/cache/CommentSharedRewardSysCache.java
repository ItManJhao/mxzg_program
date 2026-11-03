package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CCommentSharedReward;
import org.springframework.stereotype.Component;

@Component
public class CommentSharedRewardSysCache extends BaseExcelCache<CCommentSharedReward> {


    @Override
    public String getFileName() {
        return "commentsharedreward";
    }

}