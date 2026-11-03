package com.ayjs.mxzg.config.excel.cache.totems;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.totems.CTotemsLevel;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

@Component
public class TotemsLevelSysCache extends BaseExcelCache<CTotemsLevel> {

    private Map<Key, CTotemsLevel> map_cTotemsLevel;

    @Override
    public String getFileName() {
        return "totemslevel";
    }

    @Override
    protected void loadAfterReady() {
        Map<Key, CTotemsLevel> temp = new HashMap<>();
        for (CTotemsLevel template : this.getAll()) {
            temp.put(new Key(template.getTotems_id(), template.getLevel()),template);
        }
        map_cTotemsLevel = temp;
    }

    /**
     * 根据图腾id+等级获取图腾升级模板
     *
     * @param totems_id
     * @param level
     * @return
     */
    public  CTotemsLevel getCTotemsLevel_key(int totems_id, int level) {
        return this.map_cTotemsLevel.get(new Key(totems_id, level));
    }


    //图腾id+等級  联合主键
    private class Key {
        private int totems_id;//图腾id
        private int level;//品质

        public Key(int totems_id, int level) {
            this.totems_id = totems_id;
            this.level = level;
        }

        public int getTotems_id() {
            return totems_id;
        }

        public int getLevel() {
            return level;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (!(o instanceof Key)) return false;
            Key key = (Key) o;
            return getTotems_id() == key.getTotems_id() &&
                    getLevel() == key.getLevel();
        }

        @Override
        public int hashCode() {
            return Objects.hash(getTotems_id(), getLevel());
        }
    }


}
