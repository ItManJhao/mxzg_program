package com.ayjs.mxzg.message.module.crusadegroup.map;

import com.ayjs.mxzg.message.largecross.CrusadeGroupMessage;
import lombok.Getter;
import lombok.Setter;
import lombok.Value;

/**
 * 请求小地图数据
 */
@Getter
@Setter
@Value(staticConstructor = "valueOf")
public class SmallMapReqMessage implements CrusadeGroupMessage {

    private long rid;   //请求小地图数据的玩家，返回数据时该玩家的数据将被排除
    private int page;   // 请求的页数

}
