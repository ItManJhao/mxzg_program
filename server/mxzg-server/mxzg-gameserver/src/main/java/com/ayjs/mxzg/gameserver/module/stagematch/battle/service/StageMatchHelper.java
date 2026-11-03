package com.ayjs.mxzg.gameserver.module.stagematch.battle.service;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.config.excel.cache.LanguageSysCache;
import com.ayjs.mxzg.config.excel.cache.RewardGroupSysCache;
import com.ayjs.mxzg.config.excel.cache.SuperStageRankSysCache;
import com.ayjs.mxzg.config.excel.cache.SuperStageSysCache;
import com.ayjs.mxzg.config.excel.entity.CLanguage;
import com.ayjs.mxzg.config.excel.entity.CSuperStage;
import com.ayjs.mxzg.config.excel.entity.CSuperStageRank;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.TitleType;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.mail.struct.MailParams;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.dao.RoleStageMatchDao;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.domain.RoleStageMatch;
import com.ayjs.mxzg.gameserver.module.title.event.IssueTitleEvent;
import com.ayjs.mxzg.message.module.stagematch.dto.BattleResultType;
import com.ayjs.mxzg.template.language.LanguageHelper;
import com.google.common.collect.ImmutableList;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * 段位赛
 */
@Slf4j
@Service
public class StageMatchHelper {

    @Autowired
    private EventBus eventBus;
    @Autowired
    private MailService mailService;
    @Autowired
    private RewardGroupSysCache rewardGroupSysCache;
    @Autowired
    private SuperStageSysCache superStageSysCache;
    @Autowired
    private RoleStageMatchDao roleStageMatchDao;
    @Autowired
    private LanguageSysCache languageSysCache;
    @Autowired
    private SuperStageRankSysCache superStageRankSysCache;
    @Autowired
    private LanguageHelper languageHelper;
    /**
     * 开启赛季
     */
    public void openNewSeason(){
        List<RoleStageMatch> roles = roleStageMatchDao.listAll();
        try{
            for(RoleStageMatch roleStageMatch : roles){
                try{
                    CSuperStage superStage = superStageSysCache.getOrThrow(roleStageMatch.getStageId());
                    roleStageMatch.seasonReset(superStage.getInherit_stage());
                    roleStageMatchDao.update(roleStageMatch);
                } catch (Exception ex){
                    log.error("段位赛角色{}赛季重置失败", roleStageMatch.getRid());
                    ex.printStackTrace();
                }
            }
        } catch (Exception ex){
            log.error("段位赛结算失败!!!!");
            ex.printStackTrace();
        }
    }


    /**
     * 根据赛季结算
     */
    public void settlement(){
        List<RoleStageMatch> roles = roleStageMatchDao.listAll();
        try{
            for(RoleStageMatch roleStageMatch : roles){
                try{
                    roleSettlement(roleStageMatch);
                } catch (Exception ex){
                    log.error("段位赛角色{}结算失败", roleStageMatch.getRid());
                    ex.printStackTrace();
                }
            }
        } catch (Exception ex){
            log.error("段位赛结算失败!!!!");
            ex.printStackTrace();
        }
    }

    /**
     * 结算单个角色
     * @param roleStageMatch
     */
    public void roleSettlement(RoleStageMatch roleStageMatch){
        if(roleStageMatch.getTotalMatches() <= 0){
            log.info("角色结算{}，当前赛季没有参加段位赛，不发放结算奖励", roleStageMatch.getRid());
            return;
        }

        roleStageMatch.setSettlement(true);
        roleStageMatchDao.update(roleStageMatch);
        CSuperStage superStage = superStageSysCache.getOrThrow(roleStageMatch.getStageId());
        CLanguage language = languageSysCache.getByKey(superStage.getName_lang());
        Mail mail = mailService.newMailNoTitle(roleStageMatch.getRid(), MailScene.STAGE_MATCH_REWARD,
                MailParams.build(languageHelper.getLanguageBy(language)), superStage.getStage_reward(), GameEvent.STAGE_SETTLEMENT_REWARD);

        mailService.insert(mail);
    }

    /**
     * 赛季排名结算
     * @param rid
     * @param rank
     */
    public void rankSettlement(long rid, int rank){
        try{
            CSuperStageRank superStageRank = superStageRankSysCache.getOrThrow(rank);
            IssueTitleEvent event = IssueTitleEvent.createOf(rid, TitleType.SUPER_STAGE, superStageRank.getTitle_id());
            eventBus.post(event);

            Mail mail = mailService.newMailNoTitle(rid, MailScene.STAGE_MATCH_RANK, MailParams.build(rank), null, GameEvent.STAGE_SETTLEMENT_RANK);
            mailService.insert(mail);

            log.error("排名称号奖励发送完毕rid={},rank={},title={}", rid, rank, superStageRank.getTitle_id());
        } catch (Exception ex){
            ex.printStackTrace();
            log.error("排名奖励发送失败rid={}, rank={}", rid, rank);
        }
    }

    /**
     * 根据结果获取奖励
     * @param resultType
     * @param stageId
     * @return
     */
    public List<ImmutableThing> getThingByResult(int resultType, int stageId){
        CSuperStage superStage = superStageSysCache.getOrThrow(stageId);
        List<Integer> rewardGroupIds = resultType == BattleResultType.VICTORY ? superStage.getVictory_reward() : superStage.getFailure_reward();
        List<ImmutableThing> things = new ArrayList<>();
        for(int groupId : rewardGroupIds){
            ImmutableList<ImmutableThing> immutableThing = rewardGroupSysCache.getRewardGroupThing(groupId);
            things.addAll(immutableThing);
        }
        return things;
    }

}
