package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CServerLadderMatch;
import org.springframework.stereotype.Component;

/**
 * 跨服天梯匹配
 */
@Component
public class ServerLadderMatchSysCache extends BaseExcelCache<CServerLadderMatch> {

    @Override
    public String getFileName() {
        return "serverladdermatch";
    }
}
