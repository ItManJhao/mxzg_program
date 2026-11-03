package com.ayjs.mxzg.message.module.crusadegroup.map;

import com.ayjs.mxzg.message.largecross.CrusadeGroupMessage;
import lombok.Getter;
import lombok.Setter;
import lombok.Value;

import java.util.Collections;
import java.util.List;

/**
 * 请求小地图数据
 */
@Getter
@Setter
@Value(staticConstructor = "valueOf")
public class SmallMapResMessage implements CrusadeGroupMessage {

    private int page;           // 请求的页数
    private int totalPage;      //总页数
    private List<Integer> territoryIds;    //被占领的领地id列表

    public List<Integer> getTerritoryIds(){
        return this.territoryIds == null ? Collections.emptyList() : this.territoryIds;
    }
}
