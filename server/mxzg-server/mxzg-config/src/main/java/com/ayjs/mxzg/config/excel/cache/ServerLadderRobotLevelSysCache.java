package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CServerLadderRobotLevel;
import org.springframework.stereotype.Component;

@Component
public class ServerLadderRobotLevelSysCache extends BaseExcelCache<CServerLadderRobotLevel> {

    @Override
    public String getFileName() {
        return "serverladderrobotlevel";
    }
}
