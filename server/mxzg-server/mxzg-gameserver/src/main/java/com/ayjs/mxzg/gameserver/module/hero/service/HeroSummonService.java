/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.hero.service;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.LotteryTypeSysCache;
import com.ayjs.mxzg.config.excel.entity.CLotteryType;
import com.ayjs.mxzg.gameserver.module.hero.dao.HeroSummonDao;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroSummon;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

/**
 * @author YY
 *
 */
@Service
public class HeroSummonService {
	
	@Autowired
	private HeroSummonDao heroSummonDao;
	@Autowired
	private LotteryTypeSysCache lotteryTypeSysCache;
	
	public HeroSummon getHeroSummon(long rid) {
		HeroSummon heroSummon = heroSummonDao.get(rid);
        if(heroSummon == null) {
            heroSummon = new HeroSummon();
            heroSummon.setRid(rid);
            heroSummon.setProphetMissTimes(new HashMap<>());
            heroSummon.setSeniorLowerUpper(new HashMap<>());
            heroSummon.setLevelResetTimes(0);
            heroSummon.setLevelResetDateTime(DateTimeUtil.tomorrowBreak());
            heroSummonDao.add(heroSummon);
        } else {
            int dayBreak = DateTimeUtil.dayBreak();
            if (dayBreak >= heroSummon.getLevelResetDateTime()) {
                heroSummon.setLevelResetTimes(0);
                heroSummon.setLevelResetDateTime(DateTimeUtil.tomorrowBreak());
                updateHeroSummon(heroSummon);
            }
        }
		return heroSummon;
	}
	
	public void updateHeroSummon(HeroSummon heroSummon) {
		heroSummonDao.update(heroSummon);
	}


	public List<CLotteryType> getByTypeAndStarLimit(int type, Map<Integer, Integer> seniorLowerUpper) {
		List<CLotteryType> result = new ArrayList<>();
		List<CLotteryType> cLotteryTypeList = lotteryTypeSysCache.getByType(type);
		if (CollectionUtil.isEmpty(cLotteryTypeList)) {
			return cLotteryTypeList;
		}
		// 先判断必出部分
		for (CLotteryType cLotteryType : cLotteryTypeList) {
			if (cLotteryType.getHappen_upper_times() > 0) {
				Integer upperTimes = seniorLowerUpper.get(cLotteryType.getStar());
				if (Objects.isNull(upperTimes)) {
					continue;
				}
				if (upperTimes >= cLotteryType.getHappen_upper_times()) {
					result.add(cLotteryType);
					break;
				}
			}
		}
		// 有必出
		if (CollectionUtil.isNotEmpty(result)) {
			return result;
		}
		// 返回没有限制的和超过最少次数的部分
		for (CLotteryType cLotteryType : cLotteryTypeList) {
			if (cLotteryType.getHappen_lower_times() > 0) {
				Integer lowerTimes = seniorLowerUpper.get(cLotteryType.getStar());
				if (Objects.isNull(lowerTimes)) {
					continue;
				}
				if (lowerTimes >= cLotteryType.getHappen_lower_times()) {
					result.add(cLotteryType);
				}
			} else {
				result.add(cLotteryType);
			}
		}
		return result;
	}
	
}
