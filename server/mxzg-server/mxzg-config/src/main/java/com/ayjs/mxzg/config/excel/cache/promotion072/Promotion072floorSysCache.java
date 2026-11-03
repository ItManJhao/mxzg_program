package com.ayjs.mxzg.config.excel.cache.promotion072;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.entity.promotion072.CPromotion072floor;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

/**
 * 诸神祭坛
 */
@Component
public class Promotion072floorSysCache extends BaseExcelCache<CPromotion072floor> {

    //key:star_server_day+end_server_day  value:   key：floor  value：template
    private Map<Key, Map<Integer, CPromotion072floor>> map_cPromotion072floor;

    @Override
    public String getFileName() {
        return "promotion072floor";
    }

    @Override
    protected void loadAfterReady() {
        Map<Key, Map<Integer, CPromotion072floor>> temp = new HashMap<>();
//        int openDay = DateTimeUtil.apartDay(activityData.getStime(), serverParamService.getServerStartTime()) + 1;
        for (CPromotion072floor template : this.getAll()) {
            Key key = new Key(template.getStar_server_day(), template.getEnd_server_day());
            Map<Integer, CPromotion072floor> map_ = temp.get(key);
            if (map_ == null) {
                map_ = new HashMap<>();
                temp.put(key, map_);
            }
            map_.put(template.getFloor(), template);
        }
        map_cPromotion072floor = temp;
    }

    /**
     * 根据开服天数和层数获取层级模板
     *
     * @param openDay
     * @param floor
     * @return
     */
    public CPromotion072floor getCPromotion072floor_openServerTime_floor(int openDay, int floor) {
        for (Map.Entry<Key, Map<Integer, CPromotion072floor>> entry : map_cPromotion072floor.entrySet()) {
            Key key = entry.getKey();
            Map<Integer, CPromotion072floor> map_ = entry.getValue();
            if (key.getStar_server_day() <= openDay && key.getEnd_server_day() >= openDay) {
                return map_.get(floor);
            }
        }
        return null;
    }

    /**
     * 获取最大层数
     *
     * @param openDay
     * @return
     */
    public int getCPromotion072floor_maxFloor(int openDay) {
        for (Map.Entry<Key, Map<Integer, CPromotion072floor>> entry : map_cPromotion072floor.entrySet()) {
            Key key = entry.getKey();
            Map<Integer, CPromotion072floor> map_ = entry.getValue();
            if (key.getStar_server_day() <= openDay && key.getEnd_server_day() >= openDay) {
                return map_.size();
            }
        }
        return 0;
    }

    private class Key {
        private int star_server_day;//配置读取开始天数
        private int end_server_day;//配置读取结束天数

        public Key(int star_server_day, int end_server_day) {
            this.star_server_day = star_server_day;
            this.end_server_day = end_server_day;
        }

        public int getStar_server_day() {
            return star_server_day;
        }

        public int getEnd_server_day() {
            return end_server_day;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (!(o instanceof Key)) return false;
            Key key = (Key) o;
            return getStar_server_day() == key.getStar_server_day() &&
                    getEnd_server_day() == key.getEnd_server_day();
        }

        @Override
        public int hashCode() {
            return Objects.hash(getStar_server_day(), getEnd_server_day());
        }
    }

}
