package com.ayjs.mxzg.tools.client.stresstest;

import com.ayjs.mxzg.common.util.NamesThreadFactory;
import com.ayjs.mxzg.tools.client.client.network.ClientSession;
import lombok.extern.slf4j.Slf4j;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.TimeUnit;

/**
 * 客户端模拟器
 *
 * @author tangyangbo 2019/8/30 14:29
 */
@Slf4j
public class ClientManager {

    private final static ClientManager instance = new ClientManager();
    // 所有的玩家
    private volatile Map<Integer, ClientSession> players = new ConcurrentHashMap<>();
    // 所有的任务
    private volatile Map<Integer, ScheduledFuture> taskFutureMap = new ConcurrentHashMap<>();

    private ScheduledExecutorService executeTaskExecutor = Executors.newScheduledThreadPool(Runtime.getRuntime().availableProcessors() * 2,
            new NamesThreadFactory("TASK-EXECUTOR-EXECUTOR"));

    public ClientManager() {
    }

    public static ClientManager getInstance() {
        return instance;
    }

    /**
     * 删除玩家
     *
     * @param number 编号
     */
    public void removePlayers(int number) {
        ScheduledFuture future = taskFutureMap.get(number);
        if (future != null)
            future.cancel(true);
        ClientSession client = players.get(number);
        if (client != null) {
            client.getChannel().close();
            players.remove(number);
        }
    }

    /**
     * 加入玩家
     *
     * @param number 编号
     * @param client 客户端
     */
    public void addPlayers(int number, ClientSession client) {
        players.put(number, client);
    }

    public Map<Integer, ClientSession> getPlayers() {
        return players;
    }


    public void startClient(ClientSession client, int period, int number) {
        taskFutureMap.put(number, executeTaskExecutor.scheduleWithFixedDelay(new ClientTask(client), 100,
                period, TimeUnit.MILLISECONDS));
        executeTaskExecutor.scheduleWithFixedDelay(client::sendHeartBeat, 20000,
                30000, TimeUnit.MILLISECONDS);
    }

    public ScheduledFuture getTaskScheduledFuture(int number) {
        return taskFutureMap.get(number);
    }

    public void shutdown() {
        try {
            executeTaskExecutor.shutdown();
        } catch (Exception e) {
            log.error("task shutdown failure!", e);
        }
    }
}
