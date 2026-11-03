package com.ayjs.mxzg.config.excel.cache;


import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.excel.entity.CBuffArt;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class BuffArtSysCache extends BaseExcelCache<CBuffArt> {

    @Autowired
    private BuffSysCache buffSysCache;

    /**
     * 所有的buffId列表
     */
    private Set<Integer> buffIds = new HashSet<>();

    @Override
    public String getFileName() {
        return "buffart";
    }

    @Override
    public void loadAfterAllReady() {
        List<CBuffArt> buffArts = getAll();
        for (CBuffArt art : buffArts) {
            List<CBuff> buffs = art.getBuff_list().stream().map(this::getBuff).filter(buff -> buff != null).collect(Collectors.toList());
            art.setBuffs(buffs);
        }
    }

    @Override
    protected void loadAfterReady() {
        List<CBuffArt> buffArts = getAll();
        Set<Integer> buffIds_ = new HashSet<>();
        for (CBuffArt art : buffArts) {
            buffIds_.addAll(art.getBuff_list());
        }
        buffIds = buffIds_;
    }

    private CBuff getBuff(int buffId) {
        try {
            return buffSysCache.getOrThrow(buffId);
        } catch (Exception ex) {
            log.info(ex.getMessage());
        }
        return null;
    }

    /**
     * 获取所有的BuffId
     *
     * @return
     */
    public Set<Integer> getBuffIds() {
        return buffIds;
    }

}