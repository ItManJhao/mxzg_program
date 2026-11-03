package com.ayjs.mxzg.tools.client.simulator;

import cn.hutool.http.HttpUtil;
import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.google.common.collect.Maps;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 服务器列表
 *
 * @author tangyangbo 2019/10/9 11:39
 */
@Slf4j
public class ServerInfoService {
    //    private static String SERVER_URL= "http://127.0.0.1:19104/infocenter/static/setting/serverList.json";
    private static String SERVER_URL1 = "http://182.254.197.214:8070/?action=Platform.serverPage&big_server_id=";
    private static String SERVER_URL2 = "&c_id=1&c_son_id=100001&device_type=1&time=1576312316&uid=10000834";

    public static String ALL_SERVE = "http://182.254.197.214:8070/?action=Platform.serverAll&c_id=1&c_son_id=100001&device_type=1&time=1576312568";

    private final static ServerInfoService serverInfoService = new ServerInfoService();


    @Getter
    private static Map<Integer, ServerDetail> serverMap = new ConcurrentHashMap<>();

    public static ServerInfoService getInstance() {
        return serverInfoService;
    }

    public static void init() {

        String allBigServer = doGet(ALL_SERVE);
        if (allBigServer == null) {
            log.warn("@@reloadServerList获取服务器列表失败 ，获取内容是空");
            return;
        }

//        HashMap tepAllServer = JsonUtil.parseJson(allBigServer, HashMap.class);
//        String cb = StrUtil.toString(tepAllServer.get("cb"));
//        String allServerStr = Base64.decodeStr(cb.substring(11), CharsetUtil.CHARSET_UTF_8);

        BigServerData bigServerData = JsonUtil.parseJson(allBigServer, BigServerData.class);
        if (bigServerData == null) {
            log.warn("@@reloadServerList服务器配置有误，转换服务器列表师表");
            return;
        }

        Map<Integer, ServerDetail> tempServerMap = Maps.newHashMap();
        bigServerData.getData().forEach(bigServerInfo -> {
            StringBuffer stringBuffer = new StringBuffer();
            stringBuffer.append(SERVER_URL1);
            stringBuffer.append(bigServerInfo.getId());
            stringBuffer.append(SERVER_URL2);

            String hcRsp = doGet(stringBuffer.toString());
//            HashMap tempStr = JsonUtil.parseJson(hcRsp, HashMap.class);
//            String tempCb = StrUtil.toString(tempStr.get("cb"));

//            String serverDataStr = Base64.decodeStr(tempCb.substring(11), CharsetUtil.CHARSET_UTF_8);
//            if (hcRsp == null) {
//                log.warn("@@reloadServerList获取服务器列表失败 ，获取内容是空");
//                return;
//            }

            ServerData serverData = JsonUtil.parseJson(hcRsp, ServerData.class);
            if (serverData == null) {
                log.warn("@@reloadServerList服务器配置有误，转换服务器列表师表");
                return;
            }
            ServerInfo serverInfo = serverData.getData();
            List<ServerDetail> serverList = serverInfo.getData();
            if (serverList == null) {
                log.warn("@@reloadServerList服务器配置有误，转换服务器列表师表");
                return;
            }
            for (ServerDetail server : serverList) {
//                String url = server.getServer_url();
//                String[] split = url.split(":");
//                if (split.length != 2) {
//                    log.error("url is error:{}", url);
//                    continue;
//                }
//                server.setAddress(split[0]);
//                server.setPort(Integer.parseInt(split[1]));
                tempServerMap.put(ConvertUtils.toInt(server.getSid()), server);
            }
        });

//        if (!tempServerMap.containsKey(1005)) {
        ServerDetail serverDetail = new ServerDetail();
        serverDetail.setSid(1005);
        serverDetail.setS_name("localhost");
        serverDetail.setS_u("192.168.1.47");
        serverDetail.setS_p(9902);
        tempServerMap.put(serverDetail.getSid(), serverDetail);
//        }

        serverMap.clear();
        serverMap.putAll(tempServerMap);

    }

    private static String doGet(String url) {
        try {

            return HttpUtil.get(url, 3000);
        } catch (Exception e) {
            log.error("获取服务器列表报错！", e);
        }
        return null;
    }
}
