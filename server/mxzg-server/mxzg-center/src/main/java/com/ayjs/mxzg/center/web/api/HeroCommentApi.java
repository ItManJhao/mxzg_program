package com.ayjs.mxzg.center.web.api;


import com.ayjs.mxzg.center.module.crossHeroComment.domain.CrossHeroTypeComment;
import com.ayjs.mxzg.center.module.crossHeroComment.service.CrossHeroCommentService;
import com.ayjs.mxzg.center.web.constant.WebErrorCode;
import com.ayjs.mxzg.center.web.support.WebResult;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * @Author: CWJ
 * @Date: 2019/11/3
 **/
@RestController
@RequestMapping("/heroComment")
@Slf4j
public class HeroCommentApi {

    @Autowired
    private CrossHeroCommentService crossHeroCommentService;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;

    /**
     * @return
     */
    @RequestMapping(value = "/delete", method = RequestMethod.GET)
    public String reloadConfig(@RequestParam(name = "heroType") int heroType, @RequestParam(name = "commentId") String commentId) {
        log.info("删除评论");
        try {
            heroTypeSysCache.getOrThrow(heroType);
            CrossHeroTypeComment crossHeroTypeComment = crossHeroCommentService.load(heroType);
            crossHeroTypeComment.getCommentDetailMap().remove(commentId);
            crossHeroCommentService.update(crossHeroTypeComment);

            return GJsonUtils.toJson(WebResult.of(WebErrorCode.SUCCESS.getCode(),
                    String.format("请求参数：{%s},{%s}", heroType, commentId)));
        } catch (Exception e) {
            log.error("删除评论失败", e);
            return GJsonUtils.toJson(WebResult.of(WebErrorCode.EXCEPTION.getCode(),
                    String.format("请求参数：{%s},{%s}", heroType, commentId)));
        }
    }
}
