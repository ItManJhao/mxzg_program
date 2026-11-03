package com.ayjs.mxzg.gameserver.web.druid;

import com.alibaba.druid.support.http.StatViewServlet;
import com.alibaba.druid.support.http.WebStatFilter;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.boot.web.servlet.ServletRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Druid配置
 */
@Configuration
public class DruidStatConfig {
    /**
     * 注册ServletRegistrationBean
     *
     * @return
     */
    @Bean
    public ServletRegistrationBean registrationBean() {
        ServletRegistrationBean bean = new ServletRegistrationBean(new StatViewServlet(), "/druid/*");
        /** 初始化参数配置，initParams**/
//        //白名单
//        bean.addInitParameter("allow", "127.0.0.1");
//        //黑名单 (存在共同时，deny优先于allow) :
//        //如果满足deny的话提示:Sorry, you are not permitted to view this page.
//        bean.addInitParameter("deny", "127.0.0.1");
        //登录查看信息的账号密码.
        bean.addInitParameter("loginUsername", "mxzg");
        bean.addInitParameter("loginPassword", "mxzg(123456!@#$%^)");
        //是否能够重置数据.
        bean.addInitParameter("resetEnable", "true");
        return bean;
    }

    /**
     * 注册FilterRegistrationBean
     *
     * @return
     */
    @Bean
    public FilterRegistrationBean druidStatFilter() {
        FilterRegistrationBean bean = new FilterRegistrationBean(new WebStatFilter());
        //添加过滤规则.
        bean.addUrlPatterns("/druidStat/*");
        //添加不需要忽略的格式信clan_task息.
        bean.addInitParameter("exclusions", "*.js,*.gif,*.jpg,*.png,*.css,*.ico,/druid/*");
        return bean;
    }
//
//    @Bean
//    public DruidStatInterceptor druidStatInterceptor() {
//        DruidStatInterceptor dsInterceptor = new DruidStatInterceptor();
//        return dsInterceptor;
//    }
//
//    @Bean
//    @Scope("prototype")
//    public JdkRegexpMethodPointcut druidStatPointcut() {
//        JdkRegexpMethodPointcut pointcut = new JdkRegexpMethodPointcut();
//        pointcut.setPattern("com.ayjs.mxzg.*");
//        return pointcut;
//    }
//
//    @Bean
//    public DefaultPointcutAdvisor druidStatAdvisor(DruidStatInterceptor druidStatInterceptor, JdkRegexpMethodPointcut druidStatPointcut) {
//        DefaultPointcutAdvisor defaultPointAdvisor = new DefaultPointcutAdvisor();
//        defaultPointAdvisor.setPointcut(druidStatPointcut);
//        defaultPointAdvisor.setAdvice(druidStatInterceptor);
//        return defaultPointAdvisor;
//    }
}
