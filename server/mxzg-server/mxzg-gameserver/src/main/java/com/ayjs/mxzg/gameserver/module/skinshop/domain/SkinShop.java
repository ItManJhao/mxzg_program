package com.ayjs.mxzg.gameserver.module.skinshop.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.*;
import lombok.Getter;
import lombok.Setter;

import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "skin_shop", comment = "永久皮肤商城表", indexes = { @Index(name = "rid", columnList = { "rid" }) }, cache = {
        @Cache(columns = "rid") })
@Getter
@Setter
public class SkinShop extends AbstractEntity {
    @Id
    @Column(name = "rid", readOnly = true)
    private long rid;
    @Column(name = "buy_map", comment = "已经购买的")
    private Set<Integer> buySet = new HashSet<>();
}
