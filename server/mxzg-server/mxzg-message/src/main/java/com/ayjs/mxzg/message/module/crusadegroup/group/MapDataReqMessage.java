package com.ayjs.mxzg.message.module.crusadegroup.group;

import com.ayjs.mxzg.message.largecross.CrusadeGroupMessage;
import lombok.Getter;
import lombok.Setter;
import lombok.Value;

/**
 * 请求地图数据
 */
@Getter
@Setter
@Value(staticConstructor = "valueOf")
public class MapDataReqMessage  implements CrusadeGroupMessage {
    /** 左下角 */
    private int bottomLeftX;
    /** 左下角 */
    private int bottomLeftY;
    /** 右上角 */
    private int upperRightX;
    /** 右上角 */
    private int upperRightY;
}
