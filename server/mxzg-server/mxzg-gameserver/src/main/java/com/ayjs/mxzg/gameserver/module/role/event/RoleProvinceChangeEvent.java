package com.ayjs.mxzg.gameserver.module.role.event;

import lombok.Value;

@Value(staticConstructor = "of")
public class RoleProvinceChangeEvent {
    private long rid;
    private String province;// 省
}
