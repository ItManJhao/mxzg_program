package com.ayjs.mxzg.config.excel.cache;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CArea;
import lombok.Getter;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;

/**
 * 省市数据
 */
@Component
public class AreaSysCache extends BaseExcelCache<CArea> {
    // 省--> 市
    private Map<String, List<CArea>> cityMap;

    // 默认北京市
    @Getter
    private int defaultCityId = 1;
    @Getter
    private String defaultProvince = "北京";

    @Override
    public String getFileName() {
        return "area";
    }

    @Override
    protected void loadAfterReady() {
        this.cityMap = this.fillListMap(CArea::getProvince);
        if (getAll().size() > 0) {
            CArea cArea = getAll().get(0);
            if (Objects.nonNull(cArea)) {
                defaultCityId = cArea.getIdx();
                defaultProvince = cArea.getProvince();
            }
        }
    }

    public List<CArea> getAreaList(String province) {
        return cityMap.get(province);
    }

    public CArea getArea(String province, String cityName) {
        List<CArea> areaList = getAreaList(province);
        if (CollectionUtil.isEmpty(areaList)) {
            return null;
        }
        // 默认获取省会
        CArea provincialCapital = areaList.get(0);
        Optional<CArea> areaOpt = areaList.stream().filter(cArea -> cArea.getCity().equals(cityName)).findFirst();
        if (areaOpt.isPresent()) {
            return areaOpt.get();
        } else {
            Optional<CArea> tempAreaOpt = areaList.stream().filter(cArea -> cArea.getCity().contains(cityName)).findFirst();
            if (tempAreaOpt.isPresent()) {
                return tempAreaOpt.get();
            }
        }
        return provincialCapital;
    }
}
