package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CShelterEvent;
import org.springframework.stereotype.Component;

@Component
public class ShelterEventSysCache extends BaseExcelCache<CShelterEvent> {

    @Override
    public String getFileName() {
        return "shelterevent";
    }
}
