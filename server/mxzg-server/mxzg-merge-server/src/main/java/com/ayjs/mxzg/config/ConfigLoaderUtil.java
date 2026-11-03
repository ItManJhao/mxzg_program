package com.ayjs.mxzg.config;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.Properties;

/**
 * @Author: CWJ
 * @Date: 2020/8/20
 **/
public class ConfigLoaderUtil {

    public static Properties load(String path) throws Exception {
        Properties properties = new Properties();
        properties.load(new BufferedReader(new FileReader(path)));
        return properties;
    }
}
