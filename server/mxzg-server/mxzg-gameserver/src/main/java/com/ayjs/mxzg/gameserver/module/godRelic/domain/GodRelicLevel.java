package com.ayjs.mxzg.gameserver.module.godRelic.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * @Author: CWJ
 * @Date: 2020/3/23
 **/
@Table(name = "god_relic_level", comment = "诸神遗迹关卡信息",
        indexes = {@Index(name = "rid", columnList = {"rid"})}, cache = {@Cache(columns = "rid")})
@Data
@Entity
public class GodRelicLevel extends AbstractEntity {

    @Id
    @LongIdGenerate(incrementDigit = 6)
    @Column(name = "id", comment = "唯一标识")
    private long id;

    @Column(name = "rid", comment = "角色id", readOnly = true)
    private long rid;

    @Column(name = "chapter", comment = "章节")
    private int chapter;
    @Column(name = "level", comment = "关卡等级")
    private int level;

    @Column(name = "complete_target", comment = "通关条件集合", length = 1024)
    private List<Integer> completeTarget = new ArrayList<>(3);


}
