/**
 * 
 */
package com.ayjs.mxzg.message.module.hero.message.dto;

import java.util.List;

import lombok.Builder;
import lombok.Data;

/**
 * @author YY
 *
 */
@Builder
@Data
public class RemoteGodEquip {
	private int sysId;
	private List<RemoteGodAttr> attrs;
}
