/**
 * 
 */
package com.ayjs.mxzg.config.struct;

import lombok.Getter;
import lombok.Setter;

/**
 * @author YY
 *
 */
@Getter
@Setter
public class ThingBonus {
	private int item_type;
	// 加成值
	private int bonus;
	// 效果 PrivilegeEffectType
	private String effect;
}
