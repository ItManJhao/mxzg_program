package com.ayjs.mxzg.gameserver.module.promotionNew.promotion076.converter;

import com.ayjs.mxzg.gameserver.module.hero.domain.HeroFashion;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroFashionService;
import com.ayjs.mxzg.gameserver.module.hero.struct.FashionData;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion076.domain.Promotion076;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion076.service.Promotion076Service;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion076ExchangeRewardConfig;
import com.ayjs.mxzg.protocol.Promotion076GMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/9/22
 **/
@Component
public class Promotion076PB {

    @Autowired
    private HeroFashionService heroFashionService;
    @Autowired
    private Promotion076Service promotion076Service;

    public Promotion076GMsg.GResMidFashionGetDataInfo buildData(Promotion076 promotionInfo) {
        Promotion076GMsg.GResMidFashionGetDataInfo.Builder builder = Promotion076GMsg.GResMidFashionGetDataInfo.newBuilder();
        builder.addAllFashionCountReward(promotionInfo.getFashionCountRecord());
        HeroFashion heroFashion = heroFashionService.selectAndRefresh(promotionInfo.getRid());
        List<Promotion076ExchangeRewardConfig> collect = promotion076Service.getAllConfig().stream().filter(config -> {
            FashionData fashionData = heroFashionService.selectFashionData(heroFashion, config.getFashion_id());
            return fashionData != null && fashionData.getStatus() == 0;
        }).collect(Collectors.toList());
        ArrayList<Integer> activeIds = collect.stream().mapToInt(Promotion076ExchangeRewardConfig::getIdx).
                collect(ArrayList::new, ArrayList::add, ArrayList::addAll);
        builder.addAllForeverActive(activeIds);
        return builder.build();
    }

    public Promotion076GMsg.GResMidFashionGetFashionCount buildGetFashionCount(int idx) {
        Promotion076GMsg.GResMidFashionGetFashionCount.Builder builder = Promotion076GMsg.GResMidFashionGetFashionCount.newBuilder();
        builder.setIdx(idx);
        return builder.build();
    }

    public Promotion076GMsg.GResMidFashionExchangeFashion buildExchange(Promotion076 promotion076) {
        Promotion076GMsg.GResMidFashionExchangeFashion.Builder builder = Promotion076GMsg.GResMidFashionExchangeFashion.newBuilder();
        builder.addAllFashionCountReward(promotion076.getFashionCountRecord());
        return builder.build();
    }
}
