package com.ayjs.mxzg.common.base;

import org.springframework.core.io.DefaultResourceLoader;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.core.io.support.PropertiesLoaderUtils;

import java.io.IOException;
import java.util.Properties;

/**
 * Properties loader
 */
public class PropertiesLoader {

    public static Properties loadProperties(String location) {
        try {
            ResourceLoader loader = new DefaultResourceLoader();
            Resource resource = loader.getResource(location);
            return PropertiesLoaderUtils.loadProperties(resource);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
