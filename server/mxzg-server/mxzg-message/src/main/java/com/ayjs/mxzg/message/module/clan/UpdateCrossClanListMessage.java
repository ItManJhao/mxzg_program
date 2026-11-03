package com.ayjs.mxzg.message.module.clan;

import com.ayjs.mxzg.message.cross.CrossMessage;
import lombok.Value;

import java.util.List;

@Value(staticConstructor = "of")
public class UpdateCrossClanListMessage implements CrossMessage {
    private List<UpdateCrossClanMessage> list;
}
