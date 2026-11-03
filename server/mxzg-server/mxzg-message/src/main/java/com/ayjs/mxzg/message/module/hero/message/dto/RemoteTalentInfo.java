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
public class RemoteTalentInfo {
	private int sort;
	private int skillId;
	private int level;
}
