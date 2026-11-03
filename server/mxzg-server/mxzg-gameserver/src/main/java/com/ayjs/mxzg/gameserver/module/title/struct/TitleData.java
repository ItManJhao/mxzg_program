/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.title.struct;

/**
 * @author YY
 *
 */
public class TitleData {
	private int id;
	//称号的失效时间，-1永久，大于等于0是具体的失效时间
	private int endTime;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getEndTime() {
		return endTime;
	}
	public void setEndTime(int endTime) {
		this.endTime = endTime;
	}

	/**
	 * 是否是永久称号
	 * @return
	 */
	public boolean isPerpetual(){
		return  endTime == -1;
	}

	/**
	 * 是否过期
	 * @param now
	 * @return
	 */
	public boolean isExpired(int now){
		return this.endTime < now;
	}
}
