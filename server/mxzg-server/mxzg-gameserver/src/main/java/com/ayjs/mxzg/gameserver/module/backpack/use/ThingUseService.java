package com.ayjs.mxzg.gameserver.module.backpack.use;

import com.ayjs.mxzg.common.base.IRegister;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.template.constant.ErrorCode;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.EnumMap;

@Slf4j
@Service
public class ThingUseService implements IRegister<ThingUse> {
    // 通用物品使用
    private final EnumMap<ThingUseType, ThingUse> thingUseMap = new EnumMap<>(ThingUseType.class);

    @Override
    public void registerBean(ThingUse bean) {
        Asserts.isNull(thingUseMap.putIfAbsent(bean.getType(), bean), String.format("%s duplicated", bean.getType()));
    }

    public ThingUse getUser(ThingUseType thingUseType) {
        ThingUse thingUse = thingUseMap.get(thingUseType);
        Asserts.notNull(thingUseType, ErrorCode.ITEM_USE_TYPE_ERROR.getValue(), () -> String.format("thingUseType %s unregister.", thingUseType.name()));
        return thingUse;
    }

}
