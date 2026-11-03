package com.ayjs.mxzg.gameserver.module.role.service;

import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.InternerPool;
import com.ayjs.mxzg.gameserver.module.role.constant.RoleParamType;
import com.ayjs.mxzg.gameserver.module.role.dao.RoleParamDao;
import com.ayjs.mxzg.gameserver.module.role.domain.RoleParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.function.Supplier;

/**
 * 角色参数表
 */
@Service
public class RoleParamService {

    private static final String PREFIX = "ROLE_PARAM";

    @Autowired
    private RoleParamDao roleParamDao;

    /**
     * 获取字典数据
     *
     * @param rid           角色id
     * @param roleParamType 类型
     * @return 数据
     */
    public RoleParam get(long rid, RoleParamType roleParamType) {
        return roleParamDao.get(rid, roleParamType);
    }

    /**
     * 获取字典数据, 不存在则根据{@code mappingFunction}创建
     *
     * @param rid     角色id
     * @param type    类型
     * @param creator 创建函数
     * @return
     */
    public <T> RoleParam getOrCreate(long rid, RoleParamType type, Supplier<T> creator) {
        RoleParam entity = roleParamDao.get(rid, type);
        if (entity != null) {
            return entity;
        }

        synchronized (InternerPool.intern(PREFIX, rid)) {
            entity = roleParamDao.get(rid, type);
            if (entity == null) {
                T data = creator.get();
                Asserts.notNull(data, () -> String.format("data cannot be null. type:%s , rid: %s", type, rid));
                entity = RoleParam.of(rid, type);
                entity.saveJson(data);
                roleParamDao.add(entity);
            }
            return entity;
        }
    }

    /**
     * 保存字典数据
     *
     * @param roleParam 字典数据
     */
    public void save(RoleParam roleParam) {
        roleParamDao.add(roleParam);
    }

    public void update(RoleParam roleParam) {
        roleParamDao.update(roleParam);
    }
}
