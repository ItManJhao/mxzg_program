package com.ayjs.mxzg.gameserver.module.sensitive.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

/**
 * @Author CJX
 * @Date 2021/6/5
 */


@Getter
@Setter
@Table(name = "language_sensitive_words", comment = "后台添加的语言敏感词")
public class LanguageSensitiveWords extends AbstractEntity {
    @Id
    @LongIdGenerate
    @Column(name = "id")
    private long id;

    @Column(name = "word", length = 64, comment = "敏感词")
    private String word;

    @Column(name = "language", comment = "语言")
    private List<Integer> languages;

}
