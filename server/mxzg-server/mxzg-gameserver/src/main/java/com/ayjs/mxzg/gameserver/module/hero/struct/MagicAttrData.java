package com.ayjs.mxzg.gameserver.module.hero.struct;

import com.ayjs.mxzg.config.struct.AttributeType;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class MagicAttrData {
    // 属性类型
    private AttributeType attributeType;
    // 数值加成
    private Long value;

    public MagicAttrData() {

    }

    public MagicAttrData(AttributeType attributeType, Long value) {
        this.attributeType = attributeType;
        this.value = value;
    }
}
