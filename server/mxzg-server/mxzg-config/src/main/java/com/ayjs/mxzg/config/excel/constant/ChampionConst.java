/**
 * 
 */
package com.ayjs.mxzg.config.excel.constant;

import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;
import com.ayjs.mxzg.common.excel.ExcelDictionaryField;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.google.common.collect.ImmutableList;

/**
 * @author YY
 * 冠军赛常量
 */
@Component
public class ChampionConst extends ExcelDictionaryCache {
	/**
	 * 淘汰赛小组数
	 */
	public static final int GROUP_COUNT = 4;
	/**
	 * 跨服淘汰赛小组数
	 */
	public static final int CROSS_GROUP_COUNT = 8;
	/**
	 * 每个小组多少人
	 */
	public static final int GROUP_SIZE = 8;
	/**
	 * 选拔赛最多人数
	 */
	public static final int TRIALS_PLAYER = 128;
	/**
	 * 跨服选拔赛入选人数
	 */
	public static final int TRIALS_CROSS_PLAYER = 256;
	
	/**
	 * 在结束的时候，竞猜币兑换的道具类型
	 */
	@ExcelDictionaryField("champion_guess_reward_type")
	public static int GUESS_REWARD_TYPE = 901301;
	/**
	 * 兑换道具的比率（万分比）
	 */
	@ExcelDictionaryField("champion_guess_reward_rate")
	public static int GUESS_REWARD_RATE	= 10000;
	/**
	 * 冠军赛每天点赞次数上限
	 */
	@ExcelDictionaryField("champion_max_like")
	public static int MAX_LIKE = 10;
	/**
	 * 冠军赛首次距离开服N天开启
	 */
	@ExcelDictionaryField("champion_open_day")
	public static int OPEN_DAY = 0;
	/**
	 * 冠军赛原始积分为竞技场积分的万分比多少
	 */
	@ExcelDictionaryField("champion_oripoint_rate")
	public static int ORIPOINT_RATE	= 800;
	/**
	 * 冠军赛竞猜币赔率参数
	 */
	public static float[] GUESS_COUNT_FACTER = new float[] {1.5f, 0.5f, 1.0f, 100.0f, 100.0f, 1.50f, 2.00f, 3.5f};
	/**
	 * 冠军赛选拔赛阶段前N轮战斗为强战力对弱战力，不能超过6
	 */
	@ExcelDictionaryField("champion_trials_win_round")
	public static int TRIALS_WIN_ROUND = 3;
	/**
	 * 冠军赛竞猜最大投注额
	 */
	@ExcelDictionaryField("champion_max_guess")
	public static int MAX_GUESS	= 1500;
	/**
	 * 点赞奖励
	 */
	public static ImmutableList<ImmutableThing> LIKE_REWARD;
	/**
	 * 发弹幕消耗
	 */
	public static ImmutableList<ImmutableThing> BIU_COST;
	
	/**
	 * 跨服点赞奖励
	 */
	public static ImmutableList<ImmutableThing> CROSS_LIKE_REWARD;
	/**
	 * 跨服冠军赛每天点赞次数上限
	 */
	@ExcelDictionaryField("champion_cross_max_like")
	public static int CROSS_MAX_LIKE = 3;
	/**
	 * 跨服冠军赛在结束的时候，竞猜币兑换的道具类型
	 */
	@ExcelDictionaryField("champion_cross_guess_reward_type")
	public static int CROSS_GUESS_REWARD_TYPE = 901901;
	/**
	 * 跨服冠军赛兑换道具的比率（万分比）
	 */
	@ExcelDictionaryField("champion_cross_guess_reward_rate")
	public static int CROSS_GUESS_REWARD_RATE = 10000;
	

	@Override
	protected void loadSpecialDictionary(Map<String, ? extends IDictionaryStruct> map) {
		String[] facterStr = map.get("champion_guess_count_facter").getValue().split("_");
		float[] guessCountFacter = new float[facterStr.length];
		for(int i = 0; i < facterStr.length; i++) {
			guessCountFacter[i] = Float.parseFloat(facterStr[i]);
		}
		GUESS_COUNT_FACTER = guessCountFacter;
		LIKE_REWARD = ImmutableThingUtil.fromJson(map.get("champion_like_reward").getValue());
		BIU_COST = ImmutableThingUtil.fromJson(map.get("champion_barrage_cost").getValue());
		
		CROSS_LIKE_REWARD = ImmutableThingUtil.fromJson(map.get("champion_cross_like_reward").getValue());
	}
	
}
