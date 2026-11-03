package com.ayjs.mxzg.cross.module.magicTower.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * @Author: CWJ
 * @Date: 2021/6/19
 **/
@Entity
@Table(name = "magic_tower", comment = "幻魔塔")
@Getter
@Setter
public class MagicTower extends AbstractEntity {
    @Id
    @Column(name = "rid", comment = "玩家id")
    private long rid;
    @Column(name = "pass_level", comment = "通关关卡")
    private int passLevel;
    @Column(name = "pass_time", comment = "通关时间")
    private int passTime;
    @Column(name = "rank_time", comment = "上榜时间")
    private LocalDateTime rankTime = LocalDateTime.of(1970, 1, 1, 0, 0);
}
