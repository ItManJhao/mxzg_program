package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CPeerageEmblem;
import org.springframework.stereotype.Component;

/**
 * 尊贵标识
 *
 * @author hyx
 */
@Component
public class PeerageEmblemSysCache extends BaseExcelCache<CPeerageEmblem> {

    @Override
    public String getFileName() {
        return "peerageemblem";
    }

    /**
     * 获取当前尊贵标识等级
     *
     * @param recharge
     * @return
     */
    public int getPeerageLevel(long recharge) {
        return getAll().stream().filter(config -> config.getRecharge() <= recharge).mapToInt(CPeerageEmblem::getLevel).max().orElse(0);
    }

}
