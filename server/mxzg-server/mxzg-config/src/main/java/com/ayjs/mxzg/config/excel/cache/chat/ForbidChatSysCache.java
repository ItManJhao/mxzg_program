package com.ayjs.mxzg.config.excel.cache.chat;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.chat.CForbidChat;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2020/9/19
 **/
@Component
public class ForbidChatSysCache extends BaseExcelCache<CForbidChat> {
    @Override
    public String getFileName() {
        return "forbidchat";
    }
}
