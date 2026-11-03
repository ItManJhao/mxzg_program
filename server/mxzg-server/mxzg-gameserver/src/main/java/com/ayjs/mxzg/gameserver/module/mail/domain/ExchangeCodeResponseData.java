package com.ayjs.mxzg.gameserver.module.mail.domain;

import com.ayjs.mxzg.config.struct.ImmutableThing;
import lombok.Data;

import java.util.List;

@Data
public class ExchangeCodeResponseData {
    private long role_id;
    private String code;
    private List<ImmutableThing> gift_item;
}
