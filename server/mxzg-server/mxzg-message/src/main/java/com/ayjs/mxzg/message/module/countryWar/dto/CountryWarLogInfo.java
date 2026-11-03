package com.ayjs.mxzg.message.module.countryWar.dto;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2021/4/25
 **/
@Getter
@Setter
public class CountryWarLogInfo {
    private LocalDateTime logTime;
    private List<String> params = new ArrayList<>();
    private long rid;
    private int type;
}
