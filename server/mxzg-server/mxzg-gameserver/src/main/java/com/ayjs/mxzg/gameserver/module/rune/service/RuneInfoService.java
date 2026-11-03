/**
 *
 */
package com.ayjs.mxzg.gameserver.module.rune.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.RuneSkill;
import com.ayjs.mxzg.config.struct.RunesVo;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.rune.dao.RuneInfoDao;
import com.ayjs.mxzg.gameserver.module.rune.domain.RuneInfo;
import com.ayjs.mxzg.gameserver.module.rune.event.RuneAddEvent;
import com.ayjs.mxzg.gameserver.module.rune.event.RuneDeleteEvent;
import com.ayjs.mxzg.protocol.RuneGMsg.GResRune;
import com.ayjs.mxzg.protocol.RuneGMsg.PSRuneSkill;
import com.ayjs.mxzg.protocol.RuneGMsg.RuneData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author YY
 *
 */
@Observer
@Service
public class RuneInfoService {

    @Autowired
    private RuneInfoDao runeInfoDao;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private EventBus eventBus;

    public List<RuneInfo> getRunes(long rid) {
        return runeInfoDao.list("rid", rid);
    }

    public RuneInfo getRune(long rid, long runeId) {
        List<RuneInfo> runes = getRunes(rid);
        for (RuneInfo rune : runes) {
            if (rune.getId() == runeId) {
                return rune;
            }
        }
        return null;
    }

    /**
     * 获取英雄身上指定位置的符文
     * @param rid
     * @param heroId
     * @param place
     * @return
     */
    public RuneInfo getRuneOnHero(long rid, long heroId, int place) {
        for (RuneInfo rune : getRunes(rid)) {
            if (rune.getHeroId() == heroId && rune.getPlace() == place) {
                return rune;
            }
        }
        return null;
    }

    public List<RuneInfo> getRuneOnHero(long rid, long heroId) {
        if (heroId == 0) {
            //在新增英雄计算战力的时候，heroId会是0
            return Collections.emptyList();
        }
        List<RuneInfo> runeList = new ArrayList<>();
        for (RuneInfo rune : getRunes(rid)) {
            if (rune.getHeroId() == heroId) {
                runeList.add(rune);
            }
        }
        return runeList;
    }

    /**
     * 根据英雄获取符文信息
     * @param rid
     * @param heroId
     * @return
     */
    public List<RunesVo> getRuneByHero(long rid, long heroId) {
        List<RuneInfo> runeInfos = getRuneOnHero(rid, heroId);
        return runeInfos.stream().map(this::converFrom).collect(Collectors.toList());
    }

    /**
     * 将RuneInfo 转换为RunesVo
     * @param runeInfo
     * @return
     */
    private RunesVo converFrom(RuneInfo runeInfo) {
        RunesVo runesVo = new RunesVo();
        runesVo.setAbilityType(runeInfo.getAbilityId());
        runesVo.setPos(runeInfo.getPlace());
        runesVo.setRunesId(runeInfo.getTypeId());
        runesVo.setSkill(runeInfo.getSkills());
        return runesVo;
    }

    public void addRunes(List<RuneInfo> list) {
        runeInfoDao.add(list);
    }

    public void updateRune(RuneInfo runeInfo) {
        runeInfoDao.update(runeInfo);
    }

    public void updateRunes(List<RuneInfo> runeInfos) {
        runeInfoDao.update(runeInfos);
    }

    private void deleteRune(RuneInfo runeInfo) {
        runeInfoDao.remove(runeInfo);
    }

    private void deleteRunes(List<RuneInfo> runeInfos) {
        runeInfoDao.remove(runeInfos);
    }

    public void deleteRune(RuneInfo runeInfo, GameEvent gameEvent) {
        deleteRune(runeInfo);
        eventBus.post(RuneDeleteEvent.of(Collections.singletonList(runeInfo), gameEvent));
    }

    public void deleteRunes(List<RuneInfo> runeInfos, GameEvent gameEvent) {
        deleteRunes(runeInfos);
        eventBus.post(RuneDeleteEvent.of(runeInfos, gameEvent));
    }

    public void clearHeroRunes(long rid, List<Hero> heroList) {
        List<RuneInfo> allList = new ArrayList<>();
        for (Hero hero : heroList) {
            allList.addAll(getRuneOnHero(rid, hero.getId()));
        }
        if (!allList.isEmpty()) {
            GResRune.Builder builder = GResRune.newBuilder();
            for (RuneInfo runeInfo : allList) {
                runeInfo.setHeroId(0);
                builder.addRuneData(serialize(runeInfo));
            }
            this.updateRunes(allList);
            contextManager.write(rid, CmdCode._29011, builder.build());
        }
    }

    public void clearPlaceHeroRunes(long rid, List<Hero> heroList, int place) {
        List<RuneInfo> allList = new ArrayList<>();
        for (Hero hero : heroList) {
            allList.addAll(getRuneOnHero(rid, hero.getId()).stream().filter(runeInfo -> runeInfo.getPlace() == place).collect(Collectors.toList()));
        }
        if (!allList.isEmpty()) {
            GResRune.Builder builder = GResRune.newBuilder();
            for (RuneInfo runeInfo : allList) {
                runeInfo.setHeroId(0);
                builder.addRuneData(serialize(runeInfo));
            }
            this.updateRunes(allList);
            contextManager.write(rid, CmdCode._29011, builder.build());
        }
    }


    public RuneData serialize(RuneInfo runeInfo) {
        RuneData.Builder builder = RuneData.newBuilder();
        builder.setItemId(runeInfo.getId());
        builder.setItemType(runeInfo.getTypeId());
        builder.setAbilityId(runeInfo.getAbilityId());
        for (RuneSkill runeSkill : runeInfo.getSkillMap().values()) {
            builder.addSkill(serializeRuneSkill(runeSkill));
        }
        builder.setExp(runeInfo.getExp());
        builder.setWashAbilityId(runeInfo.getWashAbilityId());
        for (RuneSkill runeSkill : runeInfo.getWashSkillMap().values()) {
            builder.addWashSkill(serializeRuneSkill(runeSkill));
        }
        builder.setHeroId(runeInfo.getHeroId());
        builder.setPlace(runeInfo.getPlace());
        return builder.build();
    }

    public static PSRuneSkill serializeRuneSkill(RuneSkill runeSkill) {
        PSRuneSkill.Builder builder = PSRuneSkill.newBuilder();
        builder.setSort(runeSkill.getSort());
        builder.setSkillId(runeSkill.getSkillId());
        builder.setLevel(runeSkill.getLevel());
        return builder.build();
    }

    public void sendUpdateBackPackRunes(long rid, List<RuneInfo> runeList) {
        GResRune.Builder builder = GResRune.newBuilder();
        for (RuneInfo runeInfo : runeList) {
            builder.addRuneData(serialize(runeInfo));
        }
        contextManager.write(rid, CmdCode._29011, builder.build());
    }

    @Subscribe
    private void listen(RuneAddEvent event) {
        sendUpdateBackPackRunes(event.getRid(), event.getRunes());
    }
}
