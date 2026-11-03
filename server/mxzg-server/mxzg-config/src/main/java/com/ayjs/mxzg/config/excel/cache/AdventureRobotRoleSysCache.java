package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CAdventureRobotRole;
import org.springframework.stereotype.Component;

/**
 * 勇者试炼机器人
 */
@Component
public class AdventureRobotRoleSysCache extends BaseExcelCache<CAdventureRobotRole> {

    @Override
    public String getFileName() {
        return "adventurerobotrole";
    }
}
