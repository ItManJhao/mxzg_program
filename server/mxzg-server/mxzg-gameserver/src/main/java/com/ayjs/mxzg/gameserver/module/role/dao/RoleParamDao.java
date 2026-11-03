package com.ayjs.mxzg.gameserver.module.role.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.gameserver.module.role.constant.RoleParamType;
import com.ayjs.mxzg.gameserver.module.role.domain.RoleParam;
import com.google.common.collect.ImmutableMap;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * 角色参数字典
 */
@Repository
public class RoleParamDao extends BaseRepository<RoleParam> {

    public List<RoleParam> list(long rid) {
        return list(ImmutableMap.of("rid", rid));
    }

    public RoleParam get(long rid, RoleParamType roleParamType) {
        List<RoleParam> list = list(rid);
        if (list != null && list.size() > 0) {
            Optional<RoleParam> first = list.stream()
                    .filter(roleParam -> roleParam.getRpKey() == roleParamType.getValue()).findFirst();
            return first.orElse(null);
        }
        return null;
    }
}
