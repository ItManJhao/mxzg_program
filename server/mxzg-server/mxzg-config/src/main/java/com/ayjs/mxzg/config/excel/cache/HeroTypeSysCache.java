package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CHeroStar;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.config.struct.HeroInfo;
import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.HashBasedTable;
import com.google.common.collect.Multimap;
import com.google.common.collect.Table;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class HeroTypeSysCache extends BaseExcelCache<CHeroType> {

	@Autowired
	private HeroBaseSysCache heroBaseSysCache;
	@Autowired
	private HeroUpGradeSysCache heroUpGradeSysCache;
	@Autowired
	private HeroStarSysCache heroStarSysCache;
	@Autowired
	private SkinSysCache skinSysCache;
	
	@Override
	public String getFileName() {
		return "herotype";
	}

	@Override
	public void loadAfterAllReady() {
		List<CHeroType> heros = getAll();
		for(CHeroType heroType : heros){
			List<Integer> starList = heroType.getStars();
			List<HeroInfo> heroInfos = new ArrayList<>();
			for(int star : starList){
				CHeroStar heroStar = heroStarSysCache.getOrThrow(star);
				heroBaseSysCache.getTypeStarOrThrow(heroType.getType(), star);
				heroUpGradeSysCache.getHeroUpGradeOrThrow(heroStar.getLevel_limit());
				HeroInfo heroInfo = HeroInfo.valueOf(0L, heroType.getType(), star, heroStar.getLevel_limit(), 0, 1);
				heroInfos.add(heroInfo);
			}
		}
	}
	
	/**
	 * 查询所有的英雄信息
	 * @return
	 */
	public Multimap<Integer, HeroInfo> getHeroInfos(){
		List<CHeroType> heros = getAll();
		Multimap<Integer, HeroInfo> heroInfos = ArrayListMultimap.create();
		for(CHeroType heroType : heros){
			List<Integer> starList = heroType.getStars();
			for(int star : starList){
				CHeroStar heroStar = heroStarSysCache.getOrThrow(star);
				heroBaseSysCache.getTypeStarOrThrow(heroType.getType(), star);
				heroUpGradeSysCache.getHeroUpGradeOrThrow(heroStar.getLevel_limit());
				HeroInfo heroInfo = HeroInfo.valueOf(0L, heroType.getType(), star, heroStar.getLevel_limit(), 0, 1);
				heroInfos.put(heroInfo.getHeroId(), heroInfo);
			}
		}
		return heroInfos;
	}
	
	/**
	 * 获取所有英雄信息
	 * @return
	 */
	public Table<Integer, Integer, HeroInfo> getHeroTable(){
		List<CHeroType> heros = getAll();
		Table<Integer, Integer, HeroInfo> heroTable = HashBasedTable.create();
		for(CHeroType heroType : heros){
			List<Integer> starList = heroType.getStars();
			for(int star : starList){
				CHeroStar heroStar = heroStarSysCache.getOrThrow(star);
				heroBaseSysCache.getTypeStarOrThrow(heroType.getType(), star);
				heroUpGradeSysCache.getHeroUpGradeOrThrow(heroStar.getLevel_limit());
				HeroInfo heroInfo = HeroInfo.valueOf(0L, heroType.getType(), star, heroStar.getLevel_limit(), 0, 1);
				heroTable.put(heroInfo.getHeroId(), heroInfo.getStar(), heroInfo);
			}
		}
		return heroTable;
	}

	@Override
	public boolean check(CHeroType t) {
		try {
			skinSysCache.getOrThrow(t.getType());
		} catch (Exception e) {
			System.out.println(t.getType());
		}
		return true;
	}

	/**
	 * 是否能升星
	 * @param type
	 * @param targetStar
	 * @return
	 */
	public boolean isCanUpStar(int type, int targetStar){
		CHeroType heroType = getOrThrow(type);
		return StringUtils.isNotBlank(heroType.getTo_10_star()) && !"[]".trim().equals(heroType.getTo_10_star());
	}

}