package com.ayjs.mxzg.tools.client.stresstest.handler.req;

import com.ayjs.mxzg.common.util.MessageUtils;
import com.ayjs.mxzg.protocol.HeroGMsg;
import com.ayjs.mxzg.tools.client.client.ClientCMD;
import com.ayjs.mxzg.tools.client.client.base.BackPack;
import com.ayjs.mxzg.tools.client.client.base.ClientRequestHandler;
import com.ayjs.mxzg.tools.client.client.network.ClientSession;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 请求一键穿戴
 *
 * @Author: CWJ
 * @Date: 2019/12/7
 **/
public class ReqHeroOneKeyWearHandler implements ClientRequestHandler<HeroGMsg.GReqHeroEquipOneKeyWear.Builder> {
    @Override
    public int getMessageId() {
        return ClientCMD.HERO_ONE_KEY_WEAR;
    }

    @Override
    public void customHandler(ClientSession client, HeroGMsg.GReqHeroEquipOneKeyWear.Builder builder) {
        List<Integer> list = new ArrayList<>();
        List<BackPack> hadEquips = new ArrayList<>(client.getBackpackDataMap().values());


        Map<EquipIdRange, List<BackPack>> rangeMap = new HashMap<>();
        hadEquips.stream().forEach(equip -> {
            EquipIdRange range = EquipIdRange.getRange(equip.getType());
            if (range != null) {
                List<BackPack> equips = rangeMap.computeIfAbsent(range, key -> new ArrayList<>());
                equips.add(equip);
            }
        });
        rangeMap.values().forEach(rangeEquips -> {
            Collections.sort(rangeEquips, new Comparator<BackPack>() {
                @Override
                public int compare(BackPack o1, BackPack o2) {
                    return o2.getType() - o1.getType();
                }
            });
        });

        builder.getSysIdList().forEach(equipId -> {
            EquipIdRange range = EquipIdRange.getRange(equipId);
            List<BackPack> rangeEquips = rangeMap.get(range);
            if (rangeEquips != null && rangeEquips.size() > 0) {
                list.add(rangeEquips.remove(0).getType());
            }

        });
        MessageUtils.setMessageBuilderFieldValue(builder, "sys_id", list);
    }


    public enum EquipIdRange {
        WEAPON(1001000, 1002000),
        HELMET(1002000, 1003000),
        CLOTHING(1003000, 1004000),
        SHOE(1004000, 1005000);

        private int min;
        private int max;

        EquipIdRange(int min, int max) {
            this.min = min;
            this.max = max;
        }

        public int getMin() {
            return min;
        }

        public int getMax() {
            return max;
        }

        public boolean inRange(int idx) {
            if (getMin() <= idx && getMax() > idx) {
                return true;
            }
            return false;
        }

        public static EquipIdRange getRange(int idx) {
            for (EquipIdRange range : EquipIdRange.values()) {
                if (range.inRange(idx)) {
                    return range;
                }
            }
            return null;
        }

    }

}

