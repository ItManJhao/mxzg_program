package com.ayjs.mxzg.cross.module.crossparam.service;

import com.ayjs.mxzg.cross.module.crossparam.constant.CrossParamType;
import com.ayjs.mxzg.cross.module.crossparam.dao.CrossParamDao;
import com.ayjs.mxzg.cross.module.crossparam.domain.CrossParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.function.Supplier;

/**
 * 系统参数字典
 */
@Service
public class CrossParamService {

    @Autowired
    private CrossParamDao crossParamDao;

    /**
     * 获取字典数据
     *
     * @param serverParamType
     * @return
     */
    public CrossParam get(CrossParamType serverParamType) {
        return crossParamDao.get("spKey", serverParamType.getValue());
    }

    /**
     * 获取或者创建字典数据
     *
     * @param type
     * @param creator
     * @param <T>
     * @return
     */
    public <T> CrossParam getOrCreate(CrossParamType type, Supplier<T> creator) {
        CrossParam entity = get(type);
        if (entity != null) {
            return entity;
        }
        T data = creator.get();
        entity = CrossParam.of(type);
        entity.saveJson(data);
        add(entity);
        return entity;
    }

    /**
     * 保存字典数据
     *
     * @param type
     * @param supplier
     * @param <T>
     */
    public <T> void save(CrossParamType type, Supplier<T> supplier) {
        T data = supplier.get();
        CrossParam entity = get(type);
        if (entity == null) {
            entity = CrossParam.of(type);
            entity.saveJson(data);
            add(entity);
        } else {
            entity.saveJson(data);
            update(entity);
        }
    }

    /**
     * 添加字典数据
     *
     * @param serverParam
     */
    public void add(CrossParam serverParam) {
        crossParamDao.add(serverParam);
    }

    public void update(CrossParam serverParam) {
        crossParamDao.update(serverParam);
    }
}
