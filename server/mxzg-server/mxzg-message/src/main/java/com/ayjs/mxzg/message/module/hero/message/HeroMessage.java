/**
 * 
 */
package com.ayjs.mxzg.message.module.hero.message;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

/**
 * @author YY
 *
 */
public class HeroMessage {
	
	@Builder
	@Getter
	@Setter
	public static class ResHeroMessage {
		private long heroId;	//英雄ID
		private int heroType;	//英雄类型
		private int level;		//英雄等级
		private int stage;		//英雄品阶
		private int star;		//英雄星级
		private int fighting;	//战斗力
		private int pos;		//位置
		private int fashionId;	//皮肤(时装)id
		private long hp;		//当前血量
		private int evolveType;//进化类型
		private int evolveLevel;//进化等级
	}
}
