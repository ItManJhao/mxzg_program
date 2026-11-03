/**
 *
 */
package com.ayjs.mxzg.gameserver.web.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.gameserver.module.marquee.constant.NoticeIdx;
import com.ayjs.mxzg.gameserver.module.marquee.service.MarqueeService;
import com.ayjs.mxzg.gameserver.module.marquee.struct.ObjParam;
import com.ayjs.mxzg.gameserver.web.constant.WebErrorCode;
import com.ayjs.mxzg.gameserver.web.support.WebResult;

/**
 * @author YY
 *
 */
@RestController
@RequestMapping("/marquee")
public class MarqueeApi {

    @Autowired
    private MarqueeService marqueeService;

    /**
     * 添加平台跑马灯
     * /marquee/sendMarquee
     * @param content 内容
     * @param loopCount 循环次数
     * @param platformId 后台唯一ID
     * @param space 间隔时间
     * @return
     */
    @RequestMapping(value = "/sendMarquee", method = RequestMethod.GET)
    public String sendMarquee(@RequestParam("content") String content, @RequestParam("loopCount") int loopCount,
                              @RequestParam("platformId") long platformId, @RequestParam("space") int space) {
        if (marqueeService.hasPlatformMarquee(platformId)) {
            return GJsonUtils.toJson(WebResult.of(WebErrorCode.SUCCESS.getCode(), ""));
        }
        //最少30秒
        space = Math.max(space, 30);
        marqueeService.addMarquee(NoticeIdx.SYSTEM, 0, loopCount, platformId, space, ObjParam.build(content));
        return GJsonUtils.toJson(WebResult.of(WebErrorCode.SUCCESS.getCode(), ""));
    }

    /**
     * 取消平台跑马灯
     * /marquee/cancelMarquee
     * @param platformId
     * @return
     */
    @RequestMapping(value = "/cancelMarquee", method = RequestMethod.GET)
    public String cancelMarquee(@RequestParam("platformId") long platformId) {
        marqueeService.cancelPlatformMarquee(platformId);
        return GJsonUtils.toJson(WebResult.of(WebErrorCode.SUCCESS.getCode(), ""));
    }

}
