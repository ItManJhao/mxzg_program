package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.ZhuShenLevelInfo;
import lombok.Data;

import java.util.HashMap;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2019/10/23
 **/
@Entity
@Table(name = "promotion034_zhu_shen", comment = "诸神之战")
@Data
public class Promotion034ZhuShen extends BaseLoopingPromotion implements IPromotionDropsDomain {
    //    @Column(name = "curr_level", comment = "当前副本等级")
//    private Map<Integer, Integer> typeLevelMap = new HashMap<>();
//    @Column(name = "type_hp_rate", comment = "当前关卡血量剩余（万分比）")
//    private Map<Integer, Integer> typeHpRate = new HashMap<>();
    @Column(name = "last_drop_time")
    private int lastDropTime;
    @Column(name = "type_vo_map", comment = "战斗记录")
    private Map<Integer, BattlerVo> typeVoMap = new HashMap<>();
    @Column(name = "level_info_map", comment = "关卡信息")
    private Map<Integer, ZhuShenLevelInfo> levelInfoMap = new HashMap<>();
}
