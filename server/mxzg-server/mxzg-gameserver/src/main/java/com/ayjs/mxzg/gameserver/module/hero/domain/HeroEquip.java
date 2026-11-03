/**
 *
 */
package com.ayjs.mxzg.gameserver.module.hero.domain;

import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.config.struct.EquipInfo;
import com.ayjs.mxzg.gameserver.module.hero.domain.base.HeroPlacingPart;

/**
 * @author YY
 * 英雄装备槽位，每次换装备的时候，只修改sysId
 */
@Entity
@Table(name = "hero_equip", comment = "英雄装备槽位表", indexes = {@Index(name = "rid", columnList = {"rid"})}, cache = {@Cache(columns = "rid")})
public class HeroEquip extends HeroPlacingPart {

    @Column(name = "soul_lv", comment = "附魂等级")
    private int soulLv;

    /**
     * 转换为装备信息
     * @return
     */
    public EquipInfo toEquipInfo() {
        EquipInfo equipInfo = new EquipInfo();
        equipInfo.setEquipId(getSysId());
        equipInfo.setPos(getPlace());
        equipInfo.setSoulLv(soulLv);
        return equipInfo;
    }

    public int getSoulLv() {
        return soulLv;
    }

    public void setSoulLv(int soulLv) {
        this.soulLv = soulLv;
    }
}
