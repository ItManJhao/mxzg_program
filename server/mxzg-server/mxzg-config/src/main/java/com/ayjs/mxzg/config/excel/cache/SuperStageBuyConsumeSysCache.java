package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CSuperStageBuyConsume;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

/**
 * 段位赛购买匹配次数消耗表
 */
@Slf4j
@Component
public class SuperStageBuyConsumeSysCache extends BaseExcelCache<CSuperStageBuyConsume> {

    @Override
    public String getFileName() {
        return "superstagebuyconsume";
    }

}
