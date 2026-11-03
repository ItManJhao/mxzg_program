/**
 * 
 */
package com.ayjs.mxzg.message.module.hero.message.dto;

import lombok.Builder;
import lombok.Data;

/**
 * @author YY
 *
 */
@Builder
@Data
public class RemoteGodAttr {
	/**
	 * 槽位号
	 */
	private int sort;
	/**
	 * 属性类型（ability_type）
	 */
	private int sysId;
	private int level;
}
