/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.marquee.struct;

/**
 * @author YY
 *
 */
public class ObjParam {
	
	private final Object[] params;
	
	private ObjParam(Object[] params) {
		this.params = params;
	}
	
	public static ObjParam build(Object... params) {
		return new ObjParam(params);
	}

	public Object[] getParams() {
		return params;
	}
}
