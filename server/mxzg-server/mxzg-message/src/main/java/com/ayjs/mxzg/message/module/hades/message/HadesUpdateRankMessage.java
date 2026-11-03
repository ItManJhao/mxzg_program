package com.ayjs.mxzg.message.module.hades.message;

import com.ayjs.mxzg.message.module.hades.struct.HadesRoleData;
import com.ayjs.rpc.RemoteMessage;
import lombok.Value;

import java.util.List;

/**
 * 更新排行榜数据
 *
 * @Author: CWJ
 * @Date: 2020/4/10
 **/
@Value(staticConstructor = "of")
public class HadesUpdateRankMessage implements RemoteMessage {

    private List<HadesRoleData> rankDataList;

    private int hadesType;


}
