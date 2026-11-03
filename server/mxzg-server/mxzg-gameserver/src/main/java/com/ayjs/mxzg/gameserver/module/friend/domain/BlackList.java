package com.ayjs.mxzg.gameserver.module.friend.domain;

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
 * 黑名单
 *
 * @Author: CWJ
 * @Date: 2020/3/3
 **/
@Table(name = "black_list", comment = "黑名单")
@Entity
@Getter
@Setter
public class BlackList extends AbstractEntity {

    @Id
    @Column(name = "rid", comment = "玩家id")
    private long rid;

    @Column(name = "blacks", comment = "黑名单列表", length = 1024)
    private Set<Long> blacks = new HashSet<>();

    @Column(name = "cross_blacks", comment = "包含跨服的黑名单列表")
    private Map<Long, Integer> crossBlacks = new HashMap<>();

    @Column(name = "repair", comment = "是否已修复数据")
    private boolean repair;
}
