package com.ayjs.mxzg.gameserver.module.blessingPool.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.template.scheduler.service.AbstractCronTask;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

/**
 * 许愿池稀有奖励记录
 *
 * @Author: CWJ
 * @Date: 2020/3/2
 **/
@Table(name = "blessing_pool_rare_log", comment = "稀有奖励日志")
@Entity
@Data
public class BlessingPoolRareLog extends AbstractEntity {

    @Id
//    @LongIdGenerate
    @Column(name = "type", comment = "主键id")
    private int type;

    @Column(name = "rare_log", comment = "日志", length = 1000)
    private List<RareLogData> rareLog = new ArrayList<>();
}
