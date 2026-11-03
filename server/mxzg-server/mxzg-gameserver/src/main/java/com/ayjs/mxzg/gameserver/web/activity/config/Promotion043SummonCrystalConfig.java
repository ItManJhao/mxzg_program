package com.ayjs.mxzg.gameserver.web.activity.config;


import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Promotion043SummonCrystalConfig implements IActivityConfig {

    private int idx;

    private int elem;

    private int star;

    private int num;

    private String reward;

    @Override
    public int getId() {
        return idx;
    }
}
