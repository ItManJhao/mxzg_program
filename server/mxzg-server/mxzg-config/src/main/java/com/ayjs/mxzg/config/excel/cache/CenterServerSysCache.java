package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CCenterServer;
import org.springframework.stereotype.Component;

/**
 * 服务器可见配置（暂时：主要影响同省频道聊天是否可见）
 */
@Component
public class CenterServerSysCache extends BaseExcelCache<CCenterServer> {

    @Override
    public String getFileName() {
        return "centerserver";
    }
}
