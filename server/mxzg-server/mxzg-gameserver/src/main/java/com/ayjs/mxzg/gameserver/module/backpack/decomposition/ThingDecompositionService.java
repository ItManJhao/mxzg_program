package com.ayjs.mxzg.gameserver.module.backpack.decomposition;

import com.ayjs.mxzg.common.base.IRegister;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.backpack.service.processor.ThingType;
import com.ayjs.mxzg.protocol.BackPackGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.stereotype.Service;

import java.util.EnumMap;

/**
 * 道具分解
 *
 * @author hyx
 */
@Service
public class ThingDecompositionService implements IRegister<ThingDecomposition> {

    // 通用物品使用
    private final EnumMap<ThingType, ThingDecomposition> thingDecompositionMap = new EnumMap<>(ThingType.class);

    @Override
    public void registerBean(ThingDecomposition bean) {
        Asserts.isNull(thingDecompositionMap.putIfAbsent(bean.getType(), bean), String.format("%s duplicated", bean.getType()));
    }

    /**
     * 分解道具
     * @param rid
     * @param thingType
     * @param item
     */
    public void decompositionThing(long rid, ThingType thingType, BackPackGMsg.ResBackPackItem item, GameEvent gameEvent) {
        ThingDecomposition thingDecomposition = thingDecompositionMap.get(thingType);
        Asserts.notNull(thingDecomposition, ErrorCode.BAG_NOT_DECOMPOSITION.getValue(), String.format("该道具的分解类型不存在:{%s}", thingType.getType()));
        thingDecomposition.decomposition(rid, item,gameEvent);
    }

}
