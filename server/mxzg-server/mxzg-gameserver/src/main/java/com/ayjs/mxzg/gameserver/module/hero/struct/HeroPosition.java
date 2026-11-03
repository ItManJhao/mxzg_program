/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.hero.struct;

/**
 * @author YY
 *
 */
public class HeroPosition {
	private int pos;
	private long heroId;
	private int heroType;
	private long ownerId;
	public int getPos() {
		return pos;
	}
	public void setPos(int pos) {
		this.pos = pos;
	}
	public long getHeroId() {
		return heroId;
	}
	public void setHeroId(long heroId) {
		this.heroId = heroId;
	}
	public int getHeroType() {
		return heroType;
	}
	public void setHeroType(int heroType) {
		this.heroType = heroType;
	}
	public long getOwnerId() {
		return ownerId;
	}
	public void setOwnerId(long ownerId) {
		this.ownerId = ownerId;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + (int) (heroId ^ (heroId >>> 32));
		result = prime * result + heroType;
		result = prime * result + (int) (ownerId ^ (ownerId >>> 32));
		result = prime * result + pos;
		return result;
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		HeroPosition other = (HeroPosition) obj;
		if (heroId != other.heroId)
			return false;
		if (heroType != other.heroType)
			return false;
		if (ownerId != other.ownerId)
			return false;
		if (pos != other.pos)
			return false;
		return true;
	}
	
}
