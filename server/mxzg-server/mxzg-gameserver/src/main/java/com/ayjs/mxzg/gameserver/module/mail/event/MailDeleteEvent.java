/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.mail.event;

import java.util.List;

import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;

import lombok.Value;

/**
 * @author YY
 *
 */
@Value(staticConstructor = "of")
public class MailDeleteEvent {
	private List<Mail> mails;
}
