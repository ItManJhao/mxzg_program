package com.ayjs.mxzg.gameserver.module.prophetSummon.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.config.excel.cache.ProphecyGuaranteeSysCache;
import com.ayjs.mxzg.config.excel.cache.ProphecyTypeSysCache;
import com.ayjs.mxzg.config.excel.entity.CProphecyGuarantee;
import com.ayjs.mxzg.config.excel.entity.CProphecyType;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroSummon;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroSummonService;

/**
 * 先知召唤
 */
@Service
public class ProphetSummonService {

    @Autowired
    private ProphecyTypeSysCache prophecyTypeSysCache;
    @Autowired
    private ProphecyGuaranteeSysCache prophecyGuaranteeSysCache;
    @Autowired
    private HeroSummonService heroSummonService;

    public CProphecyType prophetSummon(long rid, int prophecyType) {
        HeroSummon heroSummon = heroSummonService.getHeroSummon(rid);
        
        List<CProphecyType> randomList = null;
        //首抽机制
        if(heroSummon.getProphetNum() <= 0) {
        	randomList = prophecyTypeSysCache.getProphecyTypeList(ProphecyTypeSysCache.FIRST, prophecyType);
        	
        	heroSummon.setProphetNum(heroSummon.getProphetNum() + 1);
        } else {
        	CProphecyGuarantee cProphecyGuarantee = prophecyGuaranteeSysCache.getCProphecyGuarantee(prophecyType);
        	int missTimes = heroSummon.getProphetMissTimes(prophecyType, 1);
        	if (missTimes >= cProphecyGuarantee.getGuarantee_times()) {
        		
        		randomList = prophecyTypeSysCache.getProphecyTypeList(ProphecyTypeSysCache.LUCKY, prophecyType);
        	} else {
        		
        		randomList = prophecyTypeSysCache.getProphecyTypeList(ProphecyTypeSysCache.NORMAL, prophecyType);
        	}
        }
        
        CProphecyType cProphecyType = DropUtil.randomDrop(randomList);
        if(cProphecyType.getKind() > 0) {
        	heroSummon.resetProphetMissTimes(prophecyType, 1);
        } else {
        	heroSummon.incrementProphetMissTimes(prophecyType, 1);
        }
        heroSummonService.updateHeroSummon(heroSummon);
        return cProphecyType;
    }
}
