package com.ayjs.mxzg.config.excel.cache.reiki;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.reiki.CReikiEquip;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

/**
 *
 * @author hyx
 */
@Component
public class ReikiEquipSysCache extends BaseExcelCache<CReikiEquip> {

    public Map<Integer, List<CReikiEquip>> map ;

    @Override
    public String getFileName() {
        return "reikiequip";
    }

    @Override
    protected void loadAfterReady() {
        map = this.fillListMap(CReikiEquip::getPlace);
    }

    public Integer getMinPlace(int place){
        List<CReikiEquip> List = map.get(place);
        ConfigAsserts.notNull(List, () -> String.format("未找到reikiequip槽位{%s}的灵器数据", place));

        //获取槽位最低品质的灵器
        CReikiEquip cReikiEquip = null;
        int minPlaceIdx = 0;

        for(CReikiEquip config : List){
            if(cReikiEquip == null){
                cReikiEquip = config;
                minPlaceIdx = cReikiEquip.getIdx();
                continue;
            }
            if(config.getRare() < cReikiEquip.getRare()){
                cReikiEquip = config;
                minPlaceIdx = cReikiEquip.getIdx();
            }
        }
        return minPlaceIdx;

    }
}
