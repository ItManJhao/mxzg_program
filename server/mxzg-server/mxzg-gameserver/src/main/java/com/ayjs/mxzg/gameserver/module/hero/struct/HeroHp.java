/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.hero.struct;

/**
 * @author YY
 * 英雄血量记录
 */
public class HeroHp {
	private long heroId;
	private int hp;
	public long getHeroId() {
		return heroId;
	}
	public void setHeroId(long heroId) {
		this.heroId = heroId;
	}
	public int getHp() {
		return hp;
	}
	public void setHp(int hp) {
		this.hp = hp;
	}
}
