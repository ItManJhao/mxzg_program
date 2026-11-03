/**
 * 
 */
package com.ayjs.mxzg.gameserver.infrastructure.intercepter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.ayjs.mxzg.common.util.JsonUtil;

import lombok.extern.slf4j.Slf4j;

/**
 * @author YY
 *
 */
@Slf4j
public class VisitInterceptor extends HandlerInterceptorAdapter {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		log.info("accept http request " + request.getRequestURL().toString() + " from " + request.getRemoteAddr()
				+ " with content " + JsonUtil.toJson(request.getParameterMap()));
		return super.preHandle(request, response, handler);
	}
}
