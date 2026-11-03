package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.common.excel.ConfigNotFoundException;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.excel.entity.CBuffArt;
import com.ayjs.mxzg.config.excel.entity.CHeroSkill;
import com.ayjs.mxzg.config.struct.ActiveType;
import com.ayjs.mxzg.config.struct.BuffType;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

@Slf4j
@Component
public class HeroSkillSysCache extends BaseExcelCache<CHeroSkill> {

	@Autowired
	private BuffSysCache buffSysCache;
	@Autowired
	private BuffArtSysCache buffArtSysCache;

	@Override
	public String getFileName() {
		return "heroskill";
	}

	/**
	 * 根据技能id和等级获取英雄技能
	 * 
	 * @param skillId
	 * @param level
	 * @return
	 */
	public CHeroSkill getHeroSkillByOrThrow(int skillId, int level) {
		List<CHeroSkill> all = getAll();
		for (CHeroSkill skill : all) {
			if (skill.getType() == skillId && skill.getLevel() == level) {
				return skill;
			}
		}
		throw new ConfigNotFoundException(String.format("CHeroSkill配置数据不存在skillId{%s}Level:{%s}", skillId, level));
	}

	@Override
	public void loadAfterAllReady() {
		List<CHeroSkill> skills = getAll();
		for (CHeroSkill skill : skills) {
			try {
				if (skill.getCount_stats()) {
					checkSkillAttribute(skill);
				} else if(skill.getActive_type() == ActiveType.SKILL || skill.getActive_type() == ActiveType.ORDINARY) {
					checkFirstSkill(skill);
				} else {
					checkSkillBuffValues(skill);
				}
			} catch (Exception exception) {
				log.error("CHeroSkill格式填写错误skillId:{}", skill.getIdx());
				throw exception;
			}
		}
	}

	/**
	 * 检查技能面板属性，该方法会预处理被动属性，不能删除
	 * 
	 * @param skill
	 */
	public void checkSkillAttribute(CHeroSkill skill) {
		for (Integer artId : skill.getArt_list()) {
			CBuffArt cBuffArt = buffArtSysCache.getOrThrow(artId);
			try {
				for (Integer buffType : cBuffArt.getBuff_list()) {
					CBuff cBuff = buffSysCache.getOrThrow(buffType);
					try {
						if(cBuff.isAttributeType()){
							cBuff.getAttributeType();
							if(!cBuff.getType().stateAttributeBuff()){	// 状态类buff需要执行
								cBuff.setPassive();
							}
						}
					} catch (Exception exception) {
						log.info("CBuff计算面板属性的Buff属性格式填写错误buffId:{}", cBuff.getIdx());
						throw exception;
					}
				}
			} catch (Exception exception) {
				log.info("CBuffArt计算面板属性的Buff属性格式填写错误artId:{}", cBuffArt.getIdx());
				throw exception;
			}
		}

	}
	
	/**
	 * 检查先手技能
	 * @param skill
	 */
	public void checkFirstSkill(CHeroSkill skill){
		for(int artId : skill.getArt_list()){
			CBuffArt cBuffArt = buffArtSysCache.getOrThrow(artId);
			for(int buffId : cBuffArt.getBuff_list()){
				CBuff buff = buffSysCache.getOrThrow(buffId);
				if(buff.getType() == BuffType.BT_FIRST_SKILL){
					skill.setFirst(true);
				}
			}
		}
	}

	/**
	 * 检查buff的Value参数
	 * 
	 * @param skill
	 */
	public void checkSkillBuffValues(CHeroSkill skill) {
		for (Integer artId : skill.getArt_list()) {
			checkBuffArt(artId);
		}
	}

	/**
	 * 检查bufArt
	 * 
	 * @param artId
	 */
	private void checkBuffArt(int artId) {
		CBuffArt cBuffArt = buffArtSysCache.getOrThrow(artId);
		for (Integer buffId : cBuffArt.getBuff_list()) {
			try {
				checkBuff(artId, buffId);
			} catch (Exception e) {
				logger.error("buffart=" + artId + "检查buff的时候出现异常，异常的buffid=" + buffId);
				throw e;
			}
		}
	}

	/**
	 * 检查buff
	 * 
	 * @param buffId
	 */
	private void checkBuff(int buffArtId, int buffId) {
		CBuff cBuff = buffSysCache.getOrThrow(buffId);
		ConfigAsserts.isTrue(!cBuff.getArt_list().contains(buffArtId), String.format("buffArt循环配置%s", buffArtId));
		if (cBuff.getType().triggerArt()) {
			for (int artId : cBuff.getArt_list()) {
				checkBuffArt(artId);
			}
		}
	}

}