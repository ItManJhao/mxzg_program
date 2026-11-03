package com.ayjs.mxzg.largecross.module.stagematch.battle.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.message.module.stagematch.dto.LegendInfo;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

/**
 * 赛季传奇
 */
@Entity
@Getter
@Setter
@Table(name = "season_legend", cache = {@Cache(columns = {"season", "group_id"})}, comment = "赛季传奇表")
public class SeasonLegend extends AbstractEntity {


    @Id
    @LongIdGenerate(incrementDigit = 4)
    @Column(name = "id", readOnly = true, comment = "主键id")
    private long id;
    @Column(name = "season", readOnly = true, comment = "赛季")
    private int season;
    @Column(name = "group_id", readOnly = true, comment = "分组id")
    private int groupId;
    @Column(name = "legend_info", comment = "赛季传奇列表", longtext = true)
    private List<LegendInfo> legendInfo = new ArrayList<>();

}
