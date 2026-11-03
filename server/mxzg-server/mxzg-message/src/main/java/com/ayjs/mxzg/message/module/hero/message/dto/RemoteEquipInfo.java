package com.ayjs.mxzg.message.module.hero.message.dto;

import lombok.Builder;
import lombok.Data;

@Builder
@Data
public class RemoteEquipInfo {
    private int place;//位置
    private int equipType;//装备类型
}
