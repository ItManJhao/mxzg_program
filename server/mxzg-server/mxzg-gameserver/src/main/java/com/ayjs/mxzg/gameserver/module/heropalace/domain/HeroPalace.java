package com.ayjs.mxzg.gameserver.module.heropalace.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

import java.util.concurrent.CopyOnWriteArrayList;

/**
 * @Author: CWJ
 * @Date: 2020/3/24
 **/
@Entity
@Table(name = "hero_palace", comment = "英雄殿堂", indexes = {@Index(name = "type", columnList = {"type"})},
        cache = {@Cache(columns = "type")})
@Getter
@Setter
public class HeroPalace extends AbstractEntity {

    @Id
    @LongIdGenerate(incrementDigit = 4)
    @Column(name = "id", comment = "标识")
    private long id;

    @Column(name = "rank_rid", comment = "排名id")
    private CopyOnWriteArrayList<Long> rankRid = new CopyOnWriteArrayList<>();

    @Column(name = "type", readOnly = true, comment = "殿堂类型")
    private int type;



}
