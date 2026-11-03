package com.ayjs.mxzg.gameserver.module.hero.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.*;
import com.ayjs.mxzg.gameserver.module.hero.struct.FashionData;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

/**
 * 英雄皮肤
 *
 * @author hyx
 */
@Entity
@Getter
@Setter
@Table(name = "hero_fashion", comment = "英雄皮肤表")
public class HeroFashion extends AbstractEntity {

    @Id
    @Column(name = "rid")
    private long rid;

    @Column(name = "fashion_list", comment = "激活列表")
    private List<FashionData> fashionList = new ArrayList<>();
}
