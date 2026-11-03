package com.ayjs.mxzg.config.excel.cache.totems;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.totems.CTotems;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

@Component
public class TotemsSysCache extends BaseExcelCache<CTotems> {

    private Map<Key, CTotems> map_cTotems;

    @Override
    public String getFileName() {
        return "totems";
    }

    @Override
    protected void loadAfterReady() {
        Map<Key, CTotems> temp = new HashMap<>();
        for (CTotems template : this.getAll()) {
            temp.put(new Key(template.getTotems_id(), template.getQuality()),template);
        }
        map_cTotems = temp;
    }

    /**
     * 根据图腾id+品质获取图腾模板
     *
     * @param totems_id
     * @param quality
     * @return
     */
    public  CTotems getCTotems_key(int totems_id, int quality) {
        return this.map_cTotems.get(new Key(totems_id, quality));
    }


    //图腾id+品质  联合主键
    private class Key {
        private int totems_id;//图腾id
        private int quality;//品质

        public Key(int totems_id, int quality) {
            this.totems_id = totems_id;
            this.quality = quality;
        }

        public int getTotems_id() {
            return totems_id;
        }

        public int getQuality() {
            return quality;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (!(o instanceof Key)) return false;
            Key key = (Key) o;
            return getTotems_id() == key.getTotems_id() &&
                    getQuality() == key.getQuality();
        }

        @Override
        public int hashCode() {
            return Objects.hash(getTotems_id(), getQuality());
        }
    }

    public static void main(String[] args) {
//        Key key = new Key(111,1);
//
//        Map<Key, String> map = new HashMap<>();
//        map.put(key,"5454");
//        System.out.println(map.containsKey( new Key(111,1)));
    }

}
