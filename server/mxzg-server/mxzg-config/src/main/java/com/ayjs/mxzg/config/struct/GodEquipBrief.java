/**
 * 
 */
package com.ayjs.mxzg.config.struct;

import java.util.ArrayList;
import java.util.List;

/**
 * @author YY
 *
 */
public class GodEquipBrief {
	private int sysId;
	private List<GodAttr> attrs = new ArrayList<>();
	public int getSysId() {
		return sysId;
	}
	public void setSysId(int sysId) {
		this.sysId = sysId;
	}
	public List<GodAttr> getAttrs() {
		return attrs;
	}
	public void setAttrs(List<GodAttr> attrs) {
		this.attrs = attrs;
	}
}
