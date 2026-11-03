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
public class RemoteJewelInfo {
	/** 位置 */
	private int pos;
	/** 装备id */
	private int jewelType;
}
