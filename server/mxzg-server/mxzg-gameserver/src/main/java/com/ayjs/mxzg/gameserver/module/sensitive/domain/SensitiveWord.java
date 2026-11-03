package com.ayjs.mxzg.gameserver.module.sensitive.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Table(name = "sensitive_word", comment = "聊天敏感字词")
public class SensitiveWord extends AbstractEntity {

    @Id
    @Column(name = "word", length = 64, comment = "字词")
    private String word;

    public SensitiveWord() {

    }

    public SensitiveWord(String word) {
        this.word = word;
    }
}
