package com.ayjs.mxzg.message.module.crusadegroup.group;

import com.ayjs.mxzg.message.largecross.CrusadeGroupMessage;
import com.ayjs.mxzg.message.module.crusadegroup.group.dto.Territory;
import lombok.Value;

import java.util.Collections;
import java.util.List;

/**
 * 请求地图数据
 */
@Value(staticConstructor = "valueOf")
public class MapDataResMessage implements CrusadeGroupMessage {

    /**
     * 指定坐标内的被占领领地列表
     */
    private List<Territory> territories;


    /**
     * 获取领地
     * @return
     */
    public List<Territory> getTerritories(){
        return this.territories == null ? Collections.emptyList() : this.territories;
    }
}
