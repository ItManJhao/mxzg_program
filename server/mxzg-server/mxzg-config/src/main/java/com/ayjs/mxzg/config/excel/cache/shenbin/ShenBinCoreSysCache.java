package com.ayjs.mxzg.config.excel.cache.shenbin;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.shenbin.CShenBinCore;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

@Component
public class ShenBinCoreSysCache extends BaseExcelCache<CShenBinCore> {

    private Map<Key, CShenBinCore> map_CShenBinCoreTemplate;

    @Override
    public String getFileName() {
        return "crusadegroupshenbincore";
    }

    @Override
    protected void loadAfterReady() {
        Map<Key, CShenBinCore> temp = new HashMap<>();
        for (CShenBinCore template : this.getAll()) {
            temp.put(new Key(template.getJob(), template.getCorelv()), template);
        }
        map_CShenBinCoreTemplate = temp;
    }

    /**
     * 根据职业+核心获取CShenBinCoreTemplate
     *
     * @param job
     * @param coreLv
     * @return
     */
    public CShenBinCore getCShenBinCoreTemplate_jobCore(int job, int coreLv) {
        return map_CShenBinCoreTemplate.get(new Key(job, coreLv));
    }

    //职业+核心等级  联合主键
    private class Key {
        private int job;//职业
        private int corelv;//核心等级

        public Key(int job, int corelv) {
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
            if (!(o instanceof Key)) return false;
            Key key = (Key) o;
            return getJob() == key.getJob() &&
                    getCorelv() == key.getCorelv();
        }

        @Override
        public int hashCode() {
            return Objects.hash(getJob(), getCorelv());
        }
    }
}
