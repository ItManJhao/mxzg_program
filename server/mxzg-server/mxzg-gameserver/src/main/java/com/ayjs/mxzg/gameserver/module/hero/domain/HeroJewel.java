/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.hero.domain;

import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.hero.domain.base.HeroPlacingPart;

/**
 * @author YY
 * 英雄装备槽位，每次镶嵌、卸下的时候，只修改sysId
 */
@Entity
@Table(name = "hero_jewel", comment = "英雄宝石槽位表", indexes = {@Index(name = "rid", columnList = {"rid"})}, cache = {@Cache(columns = "rid")})
public class HeroJewel extends HeroPlacingPart {
}
