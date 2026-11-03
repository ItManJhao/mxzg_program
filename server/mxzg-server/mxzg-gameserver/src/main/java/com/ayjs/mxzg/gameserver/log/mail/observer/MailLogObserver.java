/**
 * 
 */
package com.ayjs.mxzg.gameserver.log.mail.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.gameserver.log.mail.domain.MailLog;
import com.ayjs.mxzg.gameserver.log.mail.domain.MailSomeLog;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.domain.MailSome;
import com.ayjs.mxzg.gameserver.module.mail.event.MailDeleteEvent;
import com.ayjs.mxzg.template.log.LogEntityFactory;
import com.ayjs.mxzg.template.log.LogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author YY
 *
 */
@Observer
@Service
public class MailLogObserver {

	@Autowired
	private LogService logService;
	@Autowired
    private LogEntityFactory logEntityFactory;
	
	@Subscribe(async = Subscribe.AsyncType.AsyncLog)
	private void listen(MailDeleteEvent event) {
		for(Mail mail : event.getMails()) {
			MailLog log = logEntityFactory.create(MailLog.class);
			MailLog.copyMail(log, mail);
			logService.addLog(log);
		}
    }
	
	public void deleteMailSome(List<MailSome> mailSomeList) {
		for(MailSome mail : mailSomeList) {
			MailSomeLog log = logEntityFactory.create(MailSomeLog.class);
			MailSomeLog.copyMail(log, mail);
			logService.addLog(log);
		}
	}
}
