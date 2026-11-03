package com.ayjs.mxzg.gameserver.module.hero.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.*;
import com.ayjs.mxzg.gameserver.module.hero.struct.MagicAttrData;
import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.Map;

/**
 * @author Rondo
 * 2021-05-19 11:12:40
 */
@Entity
@Table(name = "magic_wand_info", comment = "魔杖表", indexes = { @Index(name = "rid", columnList = { "rid" }) }, cache = {
        @Cache(columns = "rid") })
@Getter
@Setter
public class HeroMagicWand extends AbstractEntity {
    @Id
    @LongIdGenerate
    @Column(name = "id")
    private long id;
    @Column(name = "rid", readOnly = true)
    private long rid;
    @Column(name = "type_id", comment = "配置表的id")
    private int typeId;
    @Column(name = "hero_id", comment = "在哪个英雄身上，没有则为0")
    private long heroId;
    @Column(name = "type", comment = "类型，红色品质区分")
    private int type;
    @Column(name = "rare", comment = "品质")
    private int rare;
    @Column(name = "strengthen", comment = "强化等级")
    private int strengthen;
    @Column(name = "wash_time", comment = "洗练次数")
    private int wash_times;
    @Column(name = "base_attrs", comment = "基础属性，属性类型+数值")
    private Map<Integer, MagicAttrData> base_attrs = new HashMap<>();
    @Column(name = "random_attrs", comment = "随机属性，属性类型+数值")
    private Map<Integer, MagicAttrData> random_attrs = new HashMap<>();
    @Column(name = "wash_attrs", comment = "洗炼中的随机属性信息")
    private Map<Integer, MagicAttrData> wash_attrs = new HashMap<>();

}
