package com.ayjs.mxzg.gameserver.web.api;

import com.alibaba.fastjson.JSONObject;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.gameserver.module.sensitive.service.SensitiveWordService;
import com.ayjs.mxzg.gameserver.web.constant.WebErrorCode;
import com.ayjs.mxzg.gameserver.web.support.WebResult;
import com.google.common.reflect.TypeToken;
import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

/**
 * @Author CJX
 * @Date 2021/6/4
 */

@Slf4j
@RestController
@RequestMapping("/sensitive")
public class SensitiveApi {

    @Autowired
    private SensitiveWordService sensitiveWordService;

    /**
     * 新增敏感词
     * /sensitive/addLanguageSensitive
     * @param strJson
     * @return
     */
    @RequestMapping(value = "/addLanguageSensitive", method = {RequestMethod.GET, RequestMethod.POST})
    public String addSensitive(@RequestParam("strJson") String strJson) {
        log.info(strJson);
        List<LanguageSensitive> languageSensitives = null;
        languageSensitives = JSONObject.parseArray(strJson, LanguageSensitive.class);
        for (LanguageSensitive languageSensitive : languageSensitives) {
            sensitiveWordService.addSensitiveToDB(languageSensitive.getWord(),languageSensitive.getLanguage());
        }

        return GJsonUtils.toJson(WebResult.of(WebErrorCode.SUCCESS.getCode(), ""));
    }

}

@Getter
@Setter
class LanguageSensitive{
    private List<Integer> language;
    private String word;
}