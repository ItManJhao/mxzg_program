package com.ayjs.mxzg.gameserver.module.timeLimitItem.event;

import com.ayjs.mxzg.gameserver.module.timeLimitItem.domain.LimitItemInfo;
import lombok.Value;

import java.util.List;

/**
 * 增加期限道具
 *
 * @author hyx
 */
@Value(staticConstructor = "of")
public class TimeLimitItemEvent {

    private long rid;

    private List<LimitItemInfo> addItemList;

    private List<LimitItemInfo> delItemList;
}
