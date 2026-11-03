package com.ayjs.mxzg.message.module.floatingIslands.message;

import com.ayjs.mxzg.message.module.floatingIslands.struct.FloatingIslandsRoleData;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.rpc.RemoteMessage;
import lombok.Value;

import java.util.List;
import java.util.Map;

/**
 * 更新排行榜数据
 *
 * @Author: CWJ
 * @Date: 2020/4/10
 **/
@Value(staticConstructor = "of")
public class FloatingIslandsUpdateRankMessage implements RemoteMessage {

    private List<RankData> rankDataList;

    private Map<Long, FloatingIslandsRoleData> roleDataMap;

}
