package com.ayjs.mxzg.gameserver.module.title.receiver;

import com.ayjs.mxzg.battle.command.QueryBattleCommand;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.command.Receivers;
import com.ayjs.mxzg.common.command.annotation.Invoker;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.TitleSysCache;
import com.ayjs.mxzg.config.excel.entity.CTitle;
import com.ayjs.mxzg.gameserver.module.hero.command.CreateBattlerCommand;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHeroCommand;
import com.ayjs.mxzg.gameserver.module.title.domain.Title;
import com.ayjs.mxzg.gameserver.module.title.service.TitleService;
import com.ayjs.mxzg.gameserver.module.title.struct.TitleData;
import com.google.common.collect.Lists;
import org.apache.commons.collections4.MapUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class TitleReceiver implements Receivers {

    @Autowired
    private TitleService titleService;
    @Autowired
    private TitleSysCache titleSysCache;

    @Invoker
    public void onQueryBattleHeroCommand(QueryBattleCommand command) {
        setAttribute(command.getPlayerId(), command.getHeros());
    }

    @Invoker
    public void onCreateBattlerCommand(CreateBattlerCommand command) {
        setAttribute(command.getPlayerId(), command.getHeroDos());
    }

    @Invoker
    public void onQueryHeroCommand(QueryHeroCommand command) {
        setAttribute(command.getHero().getRid(), Lists.newArrayList(command.getHeroDo()));
    }

    /**
     * 设置称号属性
     * @param rid
     * @param heros
     */
    private void setAttribute(long rid, List<HeroDo> heros){
        Title title = titleService.getTitle(rid);
        if(title != null && MapUtils.isNotEmpty(title.getTitles())){
            int now = TimeDateUtil.getCurrentTimeInt();
            for (TitleData data : title.getTitles().values()) {
                if(data.isPerpetual() || !data.isExpired(now)){
                    CTitle ctitle = titleSysCache.getOrThrow(data.getId());
                    for (HeroDo hero : heros) {
                        hero.getAttributeInfo().addAllAttribute(ctitle.getAbility());
                    }
                }
            }
        }
    }
}
