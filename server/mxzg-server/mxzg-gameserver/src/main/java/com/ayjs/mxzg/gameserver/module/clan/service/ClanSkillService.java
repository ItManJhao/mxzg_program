/**
 *
 */
package com.ayjs.mxzg.gameserver.module.clan.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ayjs.mxzg.config.struct.HeroJobType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.config.excel.cache.ClanSkillBaseSysCache;
import com.ayjs.mxzg.config.excel.entity.CClanSkillBase;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.module.clan.constant.ClanConstant;
import com.ayjs.mxzg.gameserver.module.clan.dao.ClanSkillDao;
import com.ayjs.mxzg.gameserver.module.clan.domain.ClanSkill;
import com.ayjs.mxzg.gameserver.module.clan.struct.ClanSkillData;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.mail.struct.MailParams;

/**
 * @author YY
 *
 */
@Service
public class ClanSkillService {

    @Autowired
    private ClanSkillDao clanSkillDao;
    @Autowired
    private ClanSkillBaseSysCache clanSkillBaseSysCache;
    @Autowired
    private MailService mailService;

    public ClanSkill selectClanSkill(long rid) {
        ClanSkill clanSkill = clanSkillDao.get(rid);
        if (clanSkill == null) {//新增公会技能
            clanSkill = new ClanSkill();
            clanSkill.setRid(rid);
            clanSkill.setSkillReset(1);
            for (HeroJobType heroJobType : HeroJobType.values()) {
                clanSkill.getSkillList().put(heroJobType.getJobType(), addClanSkillData(heroJobType.getJobType()));
            }
            //新账号不需要进行数据修复，因此设置版本重置标记为1
            clanSkill.setVersionReset(1);
            clanSkillDao.add(clanSkill);
        }
        if (clanSkill.getVersionReset() == 0) {
            // 去掉了职业游侠5的设定，需要进行数据修复
            ClanSkillData clanSkillData = clanSkill.getSkillList().get(5);
            if (clanSkillData != null) {
                clanSkill.getSkillList().remove(5);
                List<ImmutableThing> rewardList = new ArrayList<>();
                for (CClanSkillBase cModel : clanSkillBaseSysCache.getAll()) {
                    if (cModel.getLevel() < clanSkillData.getLevel()) {
                        rewardList.addAll(cModel.getCost_res());
                    } else if (cModel.getLevel() == clanSkillData.getLevel()
                            && cModel.getAttr_type() <= clanSkillData.getSkillType()) {
                        rewardList.addAll(cModel.getCost_res());
                    }
                }
                rewardList = ImmutableThingUtil.mergeThing(rewardList);
                if (!rewardList.isEmpty()) {
                    Mail mail = mailService.newMail(rid, MailScene.SYS_MAIL, MailParams.build("系统邮件"),
                            MailParams.build("因英雄职业改版，原[刺客]职业调整为[坦克]，原[游侠]职业删除，以下是回退[游侠]职业科技提升的培养材料，请注意查收"), rewardList,
                            GameEvent.CLAN_SKILL_VERSION);
                    mailService.insert(mail);
                }
            }
            clanSkill.setVersionReset(1);
            clanSkillDao.update(clanSkill);
        }

        if (clanSkill.getSkillList().size() < HeroJobType.values().length) {
            for (HeroJobType heroJobType : HeroJobType.values()) {
                if (clanSkill.getSkillList().get(heroJobType.getJobType()) == null) {
                    clanSkill.getSkillList().put(heroJobType.getJobType(), addClanSkillData(heroJobType.getJobType()));
                }
            }
            this.updateClanSkill(clanSkill);
        }
        return clanSkill;
    }

    public ClanSkillData addClanSkillData(int profession) {
        ClanSkillData clanSkillData = new ClanSkillData();
        clanSkillData.setLevel(1);
        clanSkillData.setProfession(profession);
        clanSkillData.setSkillType(0);
        return clanSkillData;
    }

    /**
     * 	更新公会技能
     * @param model
     */
    public void updateClanSkill(ClanSkill model) {
        clanSkillDao.update(model);
    }


    /**
     *	获取公会技能属性加成
     * @param clanSkill
     * @return Map<职业 ， Map < 公会技能类型 ， 技能等级>>
     */
    public Map<Integer, Map<Integer, Integer>> getClanSkillLevel(ClanSkill clanSkill) {
        Map<Integer, Map<Integer, Integer>> map = new HashMap<>();

        List<ClanSkillData> skillList = new ArrayList<>(clanSkill.getSkillList().values());
        skillList.forEach(clanSkillData -> {

            Map<Integer, Integer> skillTypeMap = new HashMap<>();
            for (int skillType = 1; skillType <= ClanConstant.CLAN_SKILL; skillType++) {
                if (skillType <= clanSkillData.getSkillType()) {
                    skillTypeMap.put(skillType, clanSkillData.getLevel());
                } else {
                    if (clanSkillData.getLevel() - 1 > 0) {
                        skillTypeMap.put(skillType, clanSkillData.getLevel() - 1);
                    }
                }
            }

            map.put(clanSkillData.getProfession(), skillTypeMap);
        });

        return map;
    }

}
