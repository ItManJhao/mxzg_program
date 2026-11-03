package com.ayjs.rpc.server;

import com.ayjs.rpc.ErrorCodeMessage;
import com.ayjs.rpc.RemoteMessage;
import com.ayjs.rpc.client.Request;
import com.ayjs.rpc.forward.MessageForwarderHolder;
import com.ayjs.rpc.invoker.InvokerHolder;
import com.ayjs.rpc.invoker.MessageInvoker;
import io.netty.util.concurrent.DefaultThreadFactory;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * RPC分发器
 *
 * @author Alias
 * @date 2017年12月11日 下午4:03:51
 */
@Slf4j
@Component
public class RpcDispatcher {

    @Autowired
    private InvokerHolder invokerHolder;
    @Autowired
    private ConnectionManager connectionManager;
    @Autowired
    private MessageForwarderHolder forwarderHolder;

    /** 业务线程池 */
    private ExecutorService[] executors;

    @PostConstruct
    private void start() {
        int cpus = Runtime.getRuntime().availableProcessors();
        executors = new ExecutorService[cpus];
        for (int i = 0; i < cpus; i++) {
            executors[i] = Executors.newSingleThreadExecutor(new DefaultThreadFactory("RpcHandler"));
        }
    }

    /**
     * 分发请求
     *
     * @param request
     */
    public void dispatch(Request request, Connection session) {
        if (forwarderHolder.tryForwardRequest(request, session)) {
            return;
        }

        ExecutorService executor = executors[session.getClientId() % executors.length];
        executor.execute(new Handler(session, request));
    }

    /**
     * 业务处理任务
     *
     * @author Alias
     * @date 2017年12月13日 下午2:13:59
     */
    class Handler implements Runnable {

        private final Connection session;

        private final Request request;

        Handler(Connection session, Request request) {
            this.session = session;
            this.request = request;
        }

        @Override
        public void run() {
            RemoteMessage ret = null;
            Response response = new Response();
            response.setRequestId(request.getRequestId());
            connectionManager.currentConnection(session);
            long start = System.currentTimeMillis();

            MessageInvoker invoker = invokerHolder.getInvoker(request.getMessage().getClass());

            try {
                ret = invoker.invoke(request.getMessage(), this.session);
                long costTime = System.currentTimeMillis() - start;
                if (costTime > 300 && log.isWarnEnabled()) {
                    log.warn("{} cost time {}", request.getMessage(), costTime);
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.setException(e);
                if (e.getCause() != null) {
                    response.setException(e.getCause());
                }
                log.error(request.getMessage().getClass().getName(), e);
            }

            if (ret != null) {
                if(ret instanceof ErrorCodeMessage){
                    this.session.send(ret);
                }
                response.setResult(ret);
                session.sendResponse(response);
            }
            connectionManager.removeCurrentConnection();
        }
    }
}
