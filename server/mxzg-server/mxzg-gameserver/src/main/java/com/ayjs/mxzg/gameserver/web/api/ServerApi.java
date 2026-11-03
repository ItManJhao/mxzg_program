package com.ayjs.mxzg.gameserver.web.api;

import com.alibaba.fastjson.JSON;
import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.excel.ExcelLoader;
import com.ayjs.mxzg.common.util.SymbolConstants;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.MailSysCache;
import com.ayjs.mxzg.config.excel.entity.CMail;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.module.clan.domain.Clan;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanService;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.mail.service.MailSomeService;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.sensitive.service.SensitiveWordService;
import com.ayjs.mxzg.gameserver.module.server.constant.ServerParamType;
import com.ayjs.mxzg.gameserver.module.server.domain.ServerParam;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.gameserver.module.shop.constant.ShopType;
import com.ayjs.mxzg.gameserver.module.shop.service.ShopService;
import com.ayjs.mxzg.gameserver.web.constant.WebErrorCode;
import com.ayjs.mxzg.gameserver.web.event.ServerOpenTimeResetEvent;
import com.ayjs.mxzg.gameserver.web.support.WebResult;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.Level;
import org.apache.logging.log4j.core.Logger;
import org.apache.logging.log4j.core.LoggerContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * @Author: CWJ
 * @Date: 2019/11/3
 **/
@RestController
@RequestMapping("/server")
@Slf4j
public class ServerApi {

    @Autowired
    private ServerParamService serverParamService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private SensitiveWordService sensitiveWordService;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private RoleService roleService;
    @Autowired
    private ShopService shopService;
    @Autowired
    private MailService mailService;
    @Autowired
    private MailSomeService mailSomeService;
    @Autowired
    private ClanService clanService;
    @Autowired
    private MailSysCache mailSysCache;

    @RequestMapping(value = "/setOpenTime", method = RequestMethod.GET)
    public String server(int time) {
        log.info("服务器开服时间重置，开始");
        ServerParam serverParam = serverParamService.get(ServerParamType.OPEN_SERVER_TIME);
        if (serverParam == null) {
            serverParam = new ServerParam();
            serverParam.setSpKey(ServerParamType.OPEN_SERVER_TIME.getValue());
            serverParam.setSpValue(time + "");
            serverParamService.add(serverParam);
        } else {
            if (DateTimeUtil.isSameDate(ConvertUtils.toInt(serverParam.getSpValue()), time)) {
                return JSON.toJSONString(WebResult.of(200, ""));
            }
            serverParam.setSpValue(time + "");
            serverParamService.update(serverParam);
        }
        eventBus.post(ServerOpenTimeResetEvent.of(time));
        log.info("服务器开服时间重置，结束");
        return JSON.toJSONString(WebResult.of(200, ""));
    }

    /**
     * 聊天敏感词
     * @param words
     * @return
     */
    @RequestMapping(value = "/sensitiveWord", method = RequestMethod.GET)
    public String sensitiveWord(String words) {
        if (Objects.isNull(words)) {
            log.warn("sensitiveWord is null");
            return "FAIL";
        }
        String[] split = words.split(SymbolConstants.COMMA);
        List<String> list = Arrays.stream(split).collect(Collectors.toList());
        sensitiveWordService.replaceSensitiveWord(list);
        return JSON.toJSONString(WebResult.of(200, ""));
    }

    /**
     * 重新加载配置
     *
     * @param configs
     * @return
     */
    @RequestMapping(value = "/reloadConfig", method = RequestMethod.GET)
    public String reloadConfig(@RequestParam(name = "configs", required = false) String configs) {
        try {
            if (configs != null && !"".equals(configs)) {
                if ("all".equals(configs)) {
                    //刷新所有配置
                    ExcelLoader.load(serverConfig.getConfigPath());
                    return JSON.toJSONString(WebResult.of(WebErrorCode.SUCCESS.getCode(), ""));
                } else {
                    String[] configNames = configs.split(",");
                    boolean success = ExcelLoader.loadSome(serverConfig.getConfigPath(), configNames);
                    if (!success) {
                        return JSON.toJSONString(WebResult.of(WebErrorCode.FAIL.getCode(), "配置文件不存在", "配置文件不存在"));
                    } else {
                        return JSON.toJSONString(WebResult.of(WebErrorCode.SUCCESS.getCode(), "热更成功", "热更成功"));
                    }
                }
            } else {
                return JSON.toJSONString(WebResult.of(WebErrorCode.EXCEPTION.getCode(), "请设置需要加载的配置表", "请设置需要加载的配置表"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            return JSON.toJSONString(WebResult.of(WebErrorCode.EXCEPTION.getCode(), e.getMessage(), "配置加载异常"));
        }
    }

    /**
     * 测试接口
     *
     * @param level
     * @return
     */
    @RequestMapping(value = "/logLevel", method = RequestMethod.GET)
    public String logLevel(@RequestParam(name = "level", required = false) String level) {
        Level newLevel = Level.valueOf(level);
        if (Objects.isNull(newLevel)) {
            return JSON.toJSONString(WebResult.of(WebErrorCode.FAIL.getCode(), "level is error [" + level + "]"));
        }
        Collection<Logger> current = LoggerContext.getContext(false).getLoggers();
        Collection<org.apache.logging.log4j.core.Logger> notcurrent = LoggerContext.getContext().getLoggers();
        Collection<org.apache.logging.log4j.core.Logger> allConfig = current;
        allConfig.addAll(notcurrent);
        for (org.apache.logging.log4j.core.Logger log : allConfig) {
            log.setLevel(newLevel);
        }
        return JSON.toJSONString(WebResult.of(WebErrorCode.SUCCESS.getCode(), ""));
    }

    /**
     * /server/gc
     *
     * @param args
     * @return
     */
    @RequestMapping(value = "/gc", method = RequestMethod.GET)
    public String gc(@RequestParam(name = "args", required = true) String args) {
        if ("yes".equals(args)) {
            System.gc();
            log.info("gc end.");
        }
        return JSON.toJSONString(WebResult.of(WebErrorCode.SUCCESS.getCode(), ""));
    }

    @RequestMapping(value = "/test", method = RequestMethod.GET)
    public String test(@RequestParam(name = "args", required = false) String args) {
        log.debug("test ");

        return JSON.toJSONString(WebResult.of(WebErrorCode.SUCCESS.getCode(), ""));
    }

    @RequestMapping(value = "/refreshShop", method = RequestMethod.GET)
    public String refreshShop(@RequestParam(name = "shops", required = true) String shops) {

        if (StringUtils.isBlank(shops)) {
            return JSON.toJSONString(WebResult.of(WebErrorCode.FAIL.getCode(), "参数不能为空", "参数不能为空"));
        }
        String[] shopTypeId = shops.split(",");
        if (shopTypeId.length <= 0) {
            return JSON.toJSONString(WebResult.of(WebErrorCode.FAIL.getCode(), "参数不能为空", "参数不能为空"));
        }

        roleService.getAllRole().forEach(role -> {
            Stream.of(shopTypeId).forEach(shopId -> {
                try {
                    ShopType shopType = ShopType.of(ConvertUtils.toInt(shopId));
                    shopService.refreshShopItem(shopService.getShop(role.getId(), shopType));
                } catch (Exception e) {
                    e.printStackTrace();
                }
            });
        });
        log.debug("refresh shop. {}", shops);
        return JSON.toJSONString(WebResult.of(WebErrorCode.SUCCESS.getCode(), ""));
    }

    /***
     * 合服后添加改名卡功能
     * @return
     */
    @RequestMapping(value = "/merge/addItem", method = RequestMethod.GET)
    public String mergeAddItem() {
        ServerParam serverParam = serverParamService.getOrCreate(ServerParamType.MERGE_COMPENSATE, () -> 0);
        if (serverParam.parseJson(int.class) == 1) {
            return JSON.toJSONString(WebResult.of(WebErrorCode.FAIL.getCode(), "已经补偿过了"));
        }
        boolean mailRole = true;
        boolean mailClan = true;
        try {
            //玩家改名卡
            CMail cmail = mailSysCache.getOrThrow(MailScene.MERGE_ROLE.getId());
            String title = "";
            String context = "";
            if (cmail != null) {
                title = mailService.formatParamStr(cmail.getTitle_lang(), cmail.getTitle_param(), null);
                context = mailService.formatParamStr(cmail.getContent_lang(), cmail.getContent_param(), null);
            }
            ImmutableThing roleReward = ImmutableThing.of(902044, 1);
            mailSomeService.saveNewMail(1, title, context, null, GsonUtils.toJson(Arrays.asList(roleReward)));

        } catch (Exception e) {
            mailRole = false;
            log.error("发送玩家改名卡失败", e);
        }
        try {
            //公会改名卡
            List<Clan> clans = clanService.selectAll();

            ImmutableThing clanReward = ImmutableThing.of(902045, 1);
            List<Mail> mails = new ArrayList<>();
            clans.forEach(clan -> {
                Mail mail = mailService.newSimpleMail(clan.getClanHeadRid(), MailScene.MERGE_CLAN, Arrays.asList(clanReward), GameEvent.MERGE_SERVER);
                mails.add(mail);
            });
            mailService.insertMails(mails);
            serverParam.saveJson(1);
            serverParamService.update(serverParam);

        } catch (Exception e) {
            mailClan = false;
            log.error("发送公会改名卡失败", e);
        }
        if (mailClan && mailRole) {
            return JSON.toJSONString(WebResult.of(WebErrorCode.SUCCESS.getCode(), ""));
        }
        StringBuilder message = new StringBuilder();
        if (mailRole) {
            message.append("玩家改名卡发送失败");
        }
        if (mailClan) {
            message.append("公会改名卡发送失败");
        }

        return JSON.toJSONString(WebResult.of(WebErrorCode.FAIL.getCode(), message.toString()));
    }

    /***
     * 清除合服邮件记录
     * @return
     */
    @RequestMapping(value = "/merge/clear", method = RequestMethod.GET)
    public String mergeAddClear() {
        ServerParam serverParam = serverParamService.getOrCreate(ServerParamType.MERGE_COMPENSATE, () -> 0);
        serverParam.saveJson(0);
        serverParamService.update(serverParam);
        return JSON.toJSONString(WebResult.of(WebErrorCode.SUCCESS.getCode(), "清除成功"));
    }
}
