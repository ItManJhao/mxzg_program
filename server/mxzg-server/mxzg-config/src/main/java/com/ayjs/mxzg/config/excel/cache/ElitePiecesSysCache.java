package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CElitePieces;
import org.springframework.stereotype.Component;

@Component
public class ElitePiecesSysCache extends BaseExcelCache<CElitePieces> {

    @Override
    public String getFileName() {
        return "elitepieces";
    }
}
