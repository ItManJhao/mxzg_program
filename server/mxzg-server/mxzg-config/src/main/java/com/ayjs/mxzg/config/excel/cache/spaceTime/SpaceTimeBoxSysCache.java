package com.ayjs.mxzg.config.excel.cache.spaceTime;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeBox;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

@Component
public class SpaceTimeBoxSysCache extends BaseExcelCache<CSpaceTimeBox> {

    private Map<Integer, List<CSpaceTimeBox>> map;

    @Override
    protected void loadAfterReady() {
        this.map = this.fillListMap(CSpaceTimeBox::getItem_id);
    }

    /**
     * 获取物资箱道具组
     *
     * @param itemId
     */
    public List<CSpaceTimeBox> getMap(int itemId) {
        List<CSpaceTimeBox> list = this.map.get(itemId);
        ConfigAsserts.notNull(list, () -> String.format("spacetimebox不存在宝箱类型{%s}", itemId));
        return list;
    }

    @Override
    public String getFileName() {
        return "spacetimebox";
    }
}
