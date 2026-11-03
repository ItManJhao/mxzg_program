/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.growthGiftBag.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.*;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "growth_gift", comment = "成长礼包", indexes = {@Index(name = "rid", columnList = {"rid"})}, cache = {@Cache(columns = "rid")})
@Data
public class GrowthGift extends AbstractEntity {
	@Id
	@Column(name = "id")
	@LongIdGenerate
	private long id;
	@Column(name = "rid", readOnly = true)
	private long rid;
	@Column(name = "reward_idx")
	private List<Integer> reward_idx = new ArrayList<>();
	@Column(name = "type", comment = "成长礼包类型。1为权益购买礼包。2为权益免费礼包。都为终生限购一次")
	private int type;

}
