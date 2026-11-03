package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.Map;


/**
 * 精灵周卡(循环活动)
 * @author hyx
 */
@Getter
@Setter
@Entity
@Table(name = "promotion063_elf_weeks_card", comment = "召唤周卡")
public class Promotion063ElfWeekCard  extends BaseLoopingPromotion {

    @Column(name = "buy_list",comment = "已购买次数")
    private Map<Integer,Integer> buyList = new HashMap<>();

}

