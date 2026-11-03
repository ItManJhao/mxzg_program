/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CMail;

import lombok.extern.slf4j.Slf4j;

/**
 * @author YY
 *
 */
@Slf4j
@Component
public class MailSysCache extends BaseExcelCache<CMail> {

	@Autowired
	private LanguageSysCache languageSysCache;
	
	@Override
	public String getFileName() {
		return "mail";
	}

	@Override
	public boolean check(CMail t) {
		try {
			languageSysCache.getByKey(t.getTitle_lang());
		} catch (Exception e) {
			log.error("邮件表{}检测时没有找到语言表{}", t.getIdx(), t.getTitle_lang());
		}
		try {
			languageSysCache.getByKey(t.getContent_lang());
		} catch (Exception e) {
//			e.printStackTrace();
			log.error("邮件表{}检测时没有找到语言表{}", t.getIdx(), t.getContent_lang());
		}
		return true;
	}
}
