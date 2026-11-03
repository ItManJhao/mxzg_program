package com.ayjs.mxzg.config;

import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.google.common.reflect.TypeToken;
import lombok.Getter;
import lombok.Setter;

import java.util.Properties;
import java.util.Set;

/**
 * @Author: CWJ
 * @Date: 2020/8/20
 **/
@Getter
@Setter
public class Config {

    private static Config instance;

    public static Config getInstance() {
        if (instance == null) {
            instance = new Config();
        }
        return instance;
    }

    /***
     * 配置根目录
     */
    private String resourcePath;

    /***
     * 合服的主服
     */
    private int target;

    /***
     * 子服
     */
    private Set<Integer> source;

    private String jdbcUrl;
    private String platformUser;
    private String platformPwd;

    boolean startWithFile = true;

//    /***
//     * 数据库用户
//     */
//    private String dbUser;
//
//    /***
//     * 数据库密码
//     */
//    private String dbPass;

    /***
     * 数据库连接模板
     * @throws Exception
     */
    private Properties dbTemplate;

    private String platform = "platform";

    public void parseMergeProperties() throws Exception {
        if (startWithFile) {
            Properties load = ConfigLoaderUtil.load(resourcePath + "merge.properties");
            target = Integer.parseInt(load.getProperty("merge.target"));
            source = GsonUtils.fromJson(load.getProperty("merge.source"), new TypeToken<Set<Integer>>() {
            });
        }
        dbTemplate = ConfigLoaderUtil.load(resourcePath + "platform-db.properties");
    }

    public boolean isMergeServer(int id) {
        for (int child : source) {
            if (child == id) {
                return true;
            }
        }
        return false;
    }

}
