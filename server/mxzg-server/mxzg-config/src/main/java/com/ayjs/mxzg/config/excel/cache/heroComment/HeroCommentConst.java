package com.ayjs.mxzg.config.excel.cache.heroComment;

import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;
import lombok.Getter;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2020/6/11
 **/
@Component
@Getter
public class HeroCommentConst extends ExcelDictionaryCache {

    private int heroCommentMaxCount;
    private int heroCommentCount;
    private int heroCommentContextLength;

    @Override
    protected void loadSpecialDictionary(Map<String, ? extends IDictionaryStruct> map) {
        heroCommentMaxCount = parseInt(map, "hero_comment_max_count");

        if (heroCommentMaxCount < 1) {
            throw new RuntimeException("最大保留数不能小于1");
        }

        heroCommentCount = parseInt(map, "hero_comment_count");
        heroCommentContextLength = parseInt(map, "hero_comment_context_length");
    }
}
