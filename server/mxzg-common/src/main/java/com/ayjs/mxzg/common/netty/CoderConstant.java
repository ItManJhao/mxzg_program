package com.ayjs.mxzg.common.netty;

public interface CoderConstant {

	/** 消息头 */
	byte PACKET_HEAD = 0x7c;
	
	/** 发送packet的最大长度 */
	int PACKET_MAX_LENGTH = 4 * 1024 * 1024;
	
	/** 消息头的字节数 */
	int HEAD_BYTE_LENGTH = 1;
	
	/** cmd指令的字节长度 */
	int CMD_BYTE_LENGTH = 2;
	
	/** 消息体的长度值占的字节长度 */
	int BODY_LENGTH_BYTE_LENGTH = 4;
	
	/** 消息体除外的字节长度  */
	int BODY_EXCEPT_BYTE_LENGTH = HEAD_BYTE_LENGTH + BODY_LENGTH_BYTE_LENGTH + CMD_BYTE_LENGTH;
	
	/** UTF-8编码 */
	String CHARTSET_UTF8 = "UTF-8";
}
