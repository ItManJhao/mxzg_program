package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.CItemExChange;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

@Component
public class ItemExChangeSysCache extends BaseExcelCache<CItemExChange> {

    private Map<Integer, List<CItemExChange>> itemMap;

    @Override
    public String getFileName() {
        return "itemexchange";
    }

    @Override
    protected void loadAfterReady() {
        this.itemMap = this.fillListMap(CItemExChange::getItem_type);
    }

    public List<CItemExChange> getItemList(int itemType) {
        List<CItemExChange> itemList = itemMap.get(itemType);
        ConfigAsserts.notNull(itemList, () -> String.format("不存在该类型的随机道具列表，itemType :%s", itemType));
        return itemList;
    }

}
