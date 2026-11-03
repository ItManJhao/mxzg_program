/**
 * 
 */
package com.ayjs.mxzg.gameserver.infrastructure.intercepter;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * @author YY
 *
 */
@Configuration
public class WebApiConfig implements WebMvcConfigurer {

	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		registry.addInterceptor(new VisitInterceptor()).addPathPatterns("/**").excludePathPatterns("/error");
	}
}
