/**
 * 
 */
package com.ayjs.mxzg.common.netty;

/**
 * @author YY
 * |4|4|body
 */
public class GameMessage {
	private int cmd;
	private byte[] msg;
	public byte[] getMsg() {
		return msg;
	}
	public void setMsg(byte[] msg) {
		this.msg = msg;
	}
	public int getCmd() {
		return cmd;
	}
	public void setCmd(int cmd) {
		this.cmd = cmd;
	}
}
