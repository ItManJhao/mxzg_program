package com.ayjs.mxzg.gameserver.module.clan.service;

import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.common.util.InternerPool;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.ClanBossRankRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.ClanBossSysCache;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.entity.CClanBoss;
import com.ayjs.mxzg.config.excel.entity.CClanBossRankReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.clan.constant.ClanConstant;
import com.ayjs.mxzg.gameserver.module.clan.constant.ClanLock;
import com.ayjs.mxzg.gameserver.module.clan.dao.ClanBossBattleInfoDao;
import com.ayjs.mxzg.gameserver.module.clan.dao.ClanBossDao;
import com.ayjs.mxzg.gameserver.module.clan.domain.Clan;
import com.ayjs.mxzg.gameserver.module.clan.domain.ClanBoss;
import com.ayjs.mxzg.gameserver.module.clan.domain.ClanBossBattleInfo;
import com.ayjs.mxzg.gameserver.module.clan.domain.ClanMember;
import com.ayjs.mxzg.gameserver.module.clan.struct.ClanDungeonDamageData;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.mail.struct.MailParams;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

@Service
public class ClanBossService {

    @Autowired
    private ClanBossBattleInfoDao clanBossBattleInfoDao;
    @Autowired
    private ClanBossDao clanBossDao;
    @Autowired
    private ClanBossSysCache clanBossSysCache;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private ClanBossRankRewardSysCache clanBossRankRewardSysCache;
    @Autowired
    private MailService mailService;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private ClanService clanService;

    /**
     * 查询公会副本挑战次数
     *
     * @param rid
     * @return
     */
    public ClanBossBattleInfo selectClanBossBattleNum(long rid) {
        ClanBossBattleInfo battleNum = clanBossBattleInfoDao.get(rid);
        if (battleNum == null) {
            battleNum = new ClanBossBattleInfo();
            battleNum.setRid(rid);
            battleNum.setNowBattle(systemSysCache.getClanBossFreeTimes());
            battleNum.setPurchaseNum(0);
            battleNum.setUseBattle(0);
            clanBossBattleInfoDao.add(battleNum);
        }
        return battleNum;
    }

    /**
     * 更新公会副本挑战次数
     *
     * @param clanBossBattleInfo
     */
    public void updateClanBossBattleInfo(ClanBossBattleInfo clanBossBattleInfo) {
        clanBossBattleInfoDao.update(clanBossBattleInfo);
    }

    public void updateClanBossBattleInfoAll(List<ClanBossBattleInfo> list) {
        clanBossBattleInfoDao.update(list);
    }

    public ClanBossBattleInfo remakeClanBossBattleInfo(ClanBossBattleInfo clanBossBattleInfo) {
        clanBossBattleInfo.setNowBattle(systemSysCache.getClanBossFreeTimes());
        clanBossBattleInfo.setPurchaseNum(0);
        clanBossBattleInfo.setUseBattle(0);
        clanBossBattleInfo.setBattleTime(DateTimeUtil.currentSecond());
        return clanBossBattleInfo;
    }

    public List<ClanBossBattleInfo> selectClanBattleAll(long clanId) {
        List<ClanBossBattleInfo> clanBossBattleInfoList = new ArrayList<>();
        for (ClanMember clanMember : clanService.selectClanMember(clanId)) {
            clanBossBattleInfoList.add(selectClanBossBattleNum(clanMember.getRid()));
        }
        return clanBossBattleInfoList;
    }


    /**
     * 初始化公会副本
     *
     * @param clanId
     */
    private ClanBoss insertClanBoss(long clanId) {
        CClanBoss clanBoss = clanBossSysCache.getOrThrow(1);
        ClanBoss model = new ClanBoss();
        model.setClanId(clanId);
        model.setBossIdx(clanBoss.getBoss());
        model.setNowHp(ClanConstant.HP_RATE);
        //构建初始副本vo
        List<CClanBoss> clanBossList = new ArrayList<>();
        clanBossList.add(clanBossSysCache.getAll().stream().min(Comparator.comparingInt(CClanBoss::getBoss)).get());
        BattlerVo battlerVo = battleHelper.queryNpcBattler(clanBossList, "公会副本BOSS").toBattlerVo();
        model.setBattlerVo(battlerVo);

        model.setStatus(1);
        clanBossDao.add(model);
        return model;
    }

    /**
     * 公会BOSS
     *
     * @param clanId
     * @return
     */
    public ClanBoss selectClanBoss(long clanId) {
        ClanBoss clanBoss = clanBossDao.get(clanId);
        if (clanBoss == null) {
            synchronized (InternerPool.intern(ClanLock.CLAN_DUNGEON_LOCK, clanId)) {
                clanBoss = clanBossDao.get(clanId);
                if (clanBoss == null) {
                    clanBoss = this.insertClanBoss(clanId);
                }
            }
        }

        //战斗改版重置VO
        if (clanBoss.getStatus() == 0) {
            synchronized (InternerPool.intern(ClanLock.CLAN_DUNGEON_LOCK, clanId)) {
                if (clanBoss.getStatus() == 0) {
                    clanBoss.setStatus(1);
                    clanBoss.setNowHp(ClanConstant.HP_RATE);
                    //构建初始副本vo
                    List<CClanBoss> clanBossList = new ArrayList<>();
                    clanBossList.add(clanBossSysCache.getOrThrow(clanBoss.getBossIdx()));
                    BattlerVo battlerVo = battleHelper.queryNpcBattler(clanBossList, "公会副本BOSS").toBattlerVo();
                    clanBoss.setBattlerVo(battlerVo);

                    this.updateClanBoss(clanBoss);
                }
            }
        }

        return clanBoss;
    }

    /**
     * 更新公会BOSS
     *
     * @param clanBoss
     */
    public void updateClanBoss(ClanBoss clanBoss) {
        clanBossDao.update(clanBoss);
    }

    /**
     * 更新公会副本伤害
     *
     * @param rid
     * @param damage
     */
    public void updateClanDungeonDamage(Clan clan, long rid, long damage) {
        ClanDungeonDamageData clanDungeonDamageData = null;
        for (ClanDungeonDamageData model : clan.getClanDungeonDamageList()) {
            if (model.getRid() == rid) {
                clanDungeonDamageData = model;
            }
        }
        if (clanDungeonDamageData == null) {
            clanDungeonDamageData = new ClanDungeonDamageData();
            clanDungeonDamageData.setRid(rid);
            clan.getClanDungeonDamageList().add(clanDungeonDamageData);
        }
        clanDungeonDamageData.setBossHp(clanDungeonDamageData.getBossHp() + damage);
        clanService.updateClan(clan);
    }

    /**
     * 公会副本挑战后刷新数据
     *
     * @param clan
     * @param role
     * @param damage
     * @param cModel
     */
    public List<ImmutableThing> updateClanBossDamage(Clan clan, Role role, long damage, CClanBoss cModel) {
        //更新玩家副本伤害
        this.updateClanDungeonDamage(clan, role.getId(), damage);
        //更新排行榜
        updateClanDamageRank(clan);
        thingService.add(role.getId(), cModel.getPlay_reward(), GameEvent.CLAN_BOSS_BATTLE, NoticeType.SLIENT);
        //加公会经验
        thingService.add(role.getId(), ImmutableThingUtil.fromJson(systemSysCache.getClanBossPlayExp()),
                GameEvent.CLAN_BOSS_BATTLE, NoticeType.SLIENT);

        return cModel.getPlay_reward();
    }

    /**
     * 副本击杀奖励
     *
     * @param rid
     * @param clanBoss
     */
    public void getClanBossKillReward(long rid, CClanBoss clanBoss) {
        ClanBossBattleInfo clanBossBattleInfo = clanBossBattleInfoDao.get(rid);

        if (!clanBossBattleInfo.getClanKillList().contains(clanBoss.getBoss())) {
            clanBossBattleInfo.getClanKillList().add(clanBoss.getBoss());
            clanBossBattleInfoDao.update(clanBossBattleInfo);

            Mail mail = mailService.newMailNoTitle(rid, MailScene.CLAN_DUNGEON_BOSS, null,
                    clanBoss.getKiller_reward(), GameEvent.CLAN_BOSS_KILL);

            mailService.insert(mail);
        }
    }

    /**
     * 发送公会副本排行榜奖励
     *
     * @param clan
     * @param bossId
     */
    public void getClanBossRankReward(Clan clan, int bossId) {
        CClanBoss clanBoss = clanBossSysCache.getOrThrow(bossId);
        List<CClanBossRankReward> rankRewardList = new ArrayList<>();
        for (CClanBossRankReward cModel : clanBossRankRewardSysCache.getAll()) {
            if (cModel.getBoss_id() == clanBoss.getBoss()) {
                rankRewardList.add(cModel);
            }
        }
        List<Mail> mailList = new ArrayList<>();
        for (ClanDungeonDamageData model : clan.getClanDungeonDamageList()) {
            ClanBossBattleInfo clanBossBattleInfo = clanBossBattleInfoDao.get(model.getRid());
            if (clanBossBattleInfo.getClanRankRewardList().contains(bossId)) {
                continue;
            }
            for (CClanBossRankReward cModel : rankRewardList) {
                if (model.getRank() >= cModel.getRank_low() && model.getRank() <= cModel.getRank_up()) {
                    Mail mail = mailService.newMailNoTitle(model.getRid(), MailScene.CLAN_DUNGEON_BOSS_RANK,
                            MailParams.build(model.getRank()), cModel.getRank_reward(), GameEvent.CLAN_DUNGEON_BOSS_RANK);
                    mailList.add(mail);
                    clanBossBattleInfo.getClanRankRewardList().add(bossId);
                    updateClanBossBattleInfo(clanBossBattleInfo);
                }
            }
        }
        mailService.insertMails(mailList);
        //清除公会伤害排行榜数据
        clan.getClanDungeonDamageList().clear();
        clanService.updateClan(clan);
    }


    /**
     * 更新公会Boss伤害排行榜
     *
     * @param clan
     */
    public void updateClanDamageRank(Clan clan) {
        List<ClanDungeonDamageData> list = clan.getClanDungeonDamageList();
        Collections.sort(list, new Comparator<ClanDungeonDamageData>() {
            @Override
            public int compare(ClanDungeonDamageData o1, ClanDungeonDamageData o2) {
                long diff = o1.getBossHp() - o2.getBossHp();
                if (diff < 0) return 1;//前面的数小于后面的数
                if (diff > 0) return -1;//前面的数大于后面的数
                return 0;//相等的情况
            }
        });
        int rank = 1;
        for (ClanDungeonDamageData model : list) {
            model.setRank(rank);
            rank++;
        }
        clanService.updateClan(clan);
    }

}
