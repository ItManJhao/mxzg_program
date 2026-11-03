package com.ayjs.mxzg.gameserver.module.timeLimitItem.event;

import com.ayjs.mxzg.gameserver.module.timeLimitItem.domain.WeeksCardInfo;
import lombok.Value;

import java.util.List;


/**
 * 周卡激活
 *
 * @author hyx
 */
@Value(staticConstructor = "of")
public class WeeksCardEvent {
    private long rid;
    private List<WeeksCardInfo> weeksCardInfos;
}
