package com.ayjs.mxzg.gameserver.module.astrolabe.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * 星盘
 *
 * @Author: CWJ
 * @Date: 2020/4/27
 **/
@Table(name = "astrolabe", comment = "星盘")
@Setter
@Getter
@Entity
public class Astrolabe extends AbstractEntity {

    @Id
    @Column(name = "rid", comment = "唯一标识")
    private long rid;

    @Column(name = "max_star", comment = "最大星级")
    private int maxStar;

    @Column(name = "active_elem", comment = "激活元素")
    private Set<Integer> activeElem = new HashSet<>();

    @Column(name = "light_star", comment = "点亮星级")
    private Map<Integer, Integer> lightStar = new HashMap<>();

    @Column(name = "active", comment = "是否激活星盘")
    private boolean active;


}
