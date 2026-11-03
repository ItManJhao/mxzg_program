package com.ayjs.mxzg.gameserver.module.promotionNew.struct;

import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/6/4
 **/
@Getter
@Setter
public class CustomRewardData {

    private int productId;
    private int buyCount;
    private List<Integer> customRewardIds = new ArrayList<>();
}
