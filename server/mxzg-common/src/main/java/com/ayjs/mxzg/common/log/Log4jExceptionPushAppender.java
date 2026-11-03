package com.ayjs.mxzg.common.log;

import org.apache.logging.log4j.core.Filter;
import org.apache.logging.log4j.core.Layout;
import org.apache.logging.log4j.core.LogEvent;
import org.apache.logging.log4j.core.appender.AbstractAppender;
import org.apache.logging.log4j.core.config.Property;
import org.apache.logging.log4j.core.config.plugins.Plugin;
import org.apache.logging.log4j.core.config.plugins.PluginAttribute;
import org.apache.logging.log4j.core.config.plugins.PluginElement;
import org.apache.logging.log4j.core.config.plugins.PluginFactory;
import org.slf4j.Logger;

import java.io.Serializable;


@Plugin(name = "PushExceptionAppender", category = "Core", elementType = "appender", printObject = true)
public class Log4jExceptionPushAppender extends AbstractAppender {

    private static final long serialVersionUID = -35896346656831211L;

    private static final Logger log = org.slf4j.LoggerFactory.getLogger(Log4jExceptionPushAppender.class);

    protected Log4jExceptionPushAppender(String name, Filter filter, Layout<? extends Serializable> layout,
                                         boolean ignoreExceptions,
                                         Property[] properties) {
        super(name, filter, layout, ignoreExceptions, properties);
    }

    public void append(LogEvent event) {
        try {
            Log4jExceptionsPush.getInstance().add(event);
        } catch (Exception e){
            e.printStackTrace();
        }
    }

    @PluginFactory
    public static Log4jExceptionPushAppender createAppender(@PluginAttribute("name") String name,
                                                            @PluginElement("Filter") Filter filter,
                                                            @PluginElement("Layout") Layout<? extends Serializable> layout) {
        return new Log4jExceptionPushAppender(name, filter, layout, false, null);
    }
}
