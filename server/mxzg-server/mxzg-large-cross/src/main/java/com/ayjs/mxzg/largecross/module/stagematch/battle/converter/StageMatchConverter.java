package com.ayjs.mxzg.largecross.module.stagematch.battle.converter;

import cn.hutool.core.util.RandomUtil;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.config.excel.cache.NickSysCache;
import com.ayjs.mxzg.config.excel.cache.XingSysCache;
import com.ayjs.mxzg.config.excel.constant.StageMatchConst;
import com.ayjs.mxzg.config.excel.entity.CNick;
import com.ayjs.mxzg.config.excel.entity.CRobotFormation;
import com.ayjs.mxzg.config.excel.entity.CXing;
import com.ayjs.mxzg.largecross.module.stagematch.battle.domain.Opponent;
import com.ayjs.mxzg.message.module.stagematch.dto.OpponentDto;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.mxzg.template.language.LanguageHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Objects;
import java.util.Set;

/**
 * 段位赛转换器
 */
@Component
public class StageMatchConverter {

    @Autowired
    private XingSysCache xingSysCache;
    @Autowired
    private NickSysCache nickSysCache;
    @Autowired
    private LanguageHelper languageHelper;

    /**
     * 转换dto
     * @param opponent
     * @return
     */
    public OpponentDto convertFrom(Opponent opponent){
        OpponentDto opponentDto = new OpponentDto();
        opponentDto.setRid(opponent.getRid());
        opponentDto.setIntegral(opponent.getIntegral());
        opponentDto.setEliteIntegral(opponent.getEliteIntegral());
        opponentDto.setLastStageId(opponent.getStageId());
        opponentDto.setName(opponent.getName());
        opponentDto.setBattlerVo(opponent.getBattlerVo());
        opponentDto.setRank(opponent.getRank());
        opponentDto.setServerId(opponent.getServerId());
        opponentDto.setStageId(opponent.getStageId());
        opponentDto.setImage_id(opponent.getImage_id());
        opponentDto.setFighting(opponent.getFighting());
        return opponentDto;
    }

    /**
     * 随机名字
     *
     * @param filterNick 过滤的字符
     * @return
     */
    public String randomNick(Set<String> filterNick) {
        String nick = "";
        for (int i = 0; i < 100; i++) {
            CXing cXing = RandomUtil.randomEle(xingSysCache.getAll());
            CNick cNick = RandomUtil.randomEle(nickSysCache.getAll());

            nick = languageHelper.getLanguageBy(cXing) + languageHelper.getLanguageBy(cNick);
            if (Objects.isNull(filterNick) || !filterNick.contains(nick)) {
                break;
            }
        }
        Asserts.notNull(nick, ErrorCode.CONFIG_NOT_EXISTS.getValue(),
                () -> "nick not random:" + GJsonUtils.toJson(filterNick));
        return nick;
    }

    /**
     * 根据机器人阵容构建对手
     * @param robotFormation
     * @param challenger
     * @return
     */
    public Opponent buildOpponent(CRobotFormation robotFormation, Opponent challenger, int serverId){
        String name = randomNick(null);
        long baseFighting = challenger.getMaxFighting() == 0 ? robotFormation.getFighting() : challenger.getMaxFighting();
        long fighting = com.ayjs.mxzg.common.util.RandomUtil.getRandomInt(StageMatchConst.ROBOT_ATTRIBUTE_RANGE_MINIMUM, StageMatchConst.ROBOT_ATTRIBUTE_RANGE_MAXIMUM) * baseFighting / 10000L;
        return Opponent.createRobotOf(-1, challenger.getIntegral(), challenger.getEliteIntegral(), challenger.getStageId(), name, robotFormation.getFormation(), serverId, (int)fighting);
    }

}
