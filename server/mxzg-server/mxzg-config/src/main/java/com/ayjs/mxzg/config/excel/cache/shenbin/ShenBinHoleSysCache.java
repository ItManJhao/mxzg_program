package com.ayjs.mxzg.config.excel.cache.shenbin;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.shenbin.CShenBinHole;
import org.springframework.stereotype.Component;

import java.util.*;

@Component
public class ShenBinHoleSysCache extends BaseExcelCache<CShenBinHole> {

    private Map<Key, CShenBinHole> map_CShenBinHoleTemplate;

    private Map<Key2, List<CShenBinHole>> map_CShenBinHoleTemplate_list;

    @Override
    public String getFileName() {
        return "crusadegroupshenbinhole";
    }

    @Override
    protected void loadAfterReady() {
        Map<Key, CShenBinHole> temp = new HashMap<>();
        Map<Key2, List<CShenBinHole>> temp2 = new HashMap<>();
        for (CShenBinHole template : this.getAll()) {
            temp.put(new Key(template.getJob(), template.getCorelv(), template.getHole()), template);
            //////////////////////
            Key2 key2 = new Key2(template.getJob(), template.getCorelv());
            List<CShenBinHole> list = temp2.get(key2);
            if (list == null) {
                list = new ArrayList<>();
                temp2.put(key2, list);
            }
            list.add(template);
        }
        map_CShenBinHoleTemplate = temp;
        map_CShenBinHoleTemplate_list = temp2;
    }

    /**
     * 根据职业+核心+孔位获取CShenBinHoleTemplate
     *
     * @param job
     * @param coreLv
     * @param hole
     * @return
     */
    public CShenBinHole getCShenBinHoleTemplate_jobCoreHole(int job, int coreLv, int hole) {
        return map_CShenBinHoleTemplate.get(new Key(job, coreLv, hole));
    }

    /**
     * 根据职业+核心 CShenBinHoleTemplate集合
     *
     * @param job
     * @param coreLv
     * @return
     */
    public List<CShenBinHole> getCShenBinHoleTemplates_jobCore(int job, int coreLv) {
        Key2 key2 = new Key2(job, coreLv);
        if (map_CShenBinHoleTemplate_list.get(key2) == null) {
            return null;
        }
        return new ArrayList<>(map_CShenBinHoleTemplate_list.get(key2));
    }

    //职业+核心等级+孔位  联合主键
    private class Key {
        private int job;//职业
        private int corelv;//核心等级
        private int hole;//孔位

        public Key(int job, int corelv, int hole) {
            this.job = job;
            this.corelv = corelv;
            this.hole = hole;
        }

        public int getJob() {
            return job;
        }

        public int getCorelv() {
            return corelv;
        }

        public int getHole() {
            return hole;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (!(o instanceof Key)) return false;
            Key key = (Key) o;
            return getJob() == key.getJob() &&
                    getCorelv() == key.getCorelv() &&
                    getHole() == key.getHole();
        }

        @Override
        public int hashCode() {
            return Objects.hash(getJob(), getCorelv(), getHole());
        }
    }

    //职业+核心等级  联合主键
    private class Key2 {
        private int job;//职业
        private int corelv;//核心等级

        public Key2(int job, int corelv) {
            this.job = job;
            this.corelv = corelv;
        }

        public int getJob() {
            return job;
        }

        public int getCorelv() {
            return corelv;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (!(o instanceof Key2)) return false;
            Key2 key2 = (Key2) o;
            return getJob() == key2.getJob() &&
                    getCorelv() == key2.getCorelv();
        }

        @Override
        public int hashCode() {
            return Objects.hash(getJob(), getCorelv());
        }
    }

}
