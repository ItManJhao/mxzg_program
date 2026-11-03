package com.ayjs.mxzg.gameserver.module.monsterCheck;

import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.common.base.IRegister;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.config.struct.HeroConfig;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.config.struct.MonsterTeamCheck;
import com.ayjs.mxzg.gameserver.infrastructure.gm.GMCommand;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.GMCmdCode;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Stream;

/**
 * @Author: CWJ
 * @Date: 2020/5/9
 **/
@Service
@Slf4j
public class MonsterCheckService extends ProtocolHandler implements IRegister<MonsterTeamCheck> {

    private Map<String, MonsterTeamCheck> allCheck = new HashMap<>();

    @Autowired
    private BattleHelper battleHelper;

    @Override
    public void registerBean(MonsterTeamCheck bean) {
        allCheck.put(bean.getClass().getSimpleName(), bean);
    }

    @GMCommand(command = GMCmdCode.MONSTER_TEAM_CHECK)
    public void checkNpc(Role role, List<String> param) {
        allCheck.forEach((className, monsterTeamCheck) -> {
            monsterTeamCheck.getAllTeams().forEach(teamConfigs -> {
                if (teamConfigs.size() > 0) {
                    try {
                        BattlerDo monsterDo = battleHelper.queryNpcBattler(teamConfigs, "test-" + className);
                        BattlerDo playerVO = battleHelper.queryPlayerBattler(LineUpType.MAIN, role.getId(), Faction.ATTACKER);
                        battleHelper.invokeBattle(BattleType.MAIN, playerVO, monsterDo);
                    } catch (Exception e) {
                        HeroConfig oneConfig = teamConfigs.get(0);
                        try {
                            Method[] methods = oneConfig.getClass().getDeclaredMethods();
                            Method getExcelId = Stream.of(methods).filter(method -> method.getName().equals("getExcelId")).findFirst().orElse(null);
                            int id = 0;
                            if (getExcelId != null) {
                                id = (int) getExcelId.invoke(oneConfig);
                                log.error("怪物阵容异常，其中一个配置id为:" + id + "，----类名：" + oneConfig.getClass().getSimpleName(), e);
                            } else {
                                log.error("怪物阵容异常，其中一个配置id为:" + JsonUtil.toJson(oneConfig) + "，----类名："
                                        + oneConfig.getClass().getSimpleName(), e);
                            }
                        } catch (Exception ex) {
                            log.error("怪物阵容异常，其中一个配置id为:" + JsonUtil.toJson(oneConfig) + "，----类名："
                                    + oneConfig.getClass().getSimpleName(), e);
                        }

                    }
                }
            });
        });

    }

}
