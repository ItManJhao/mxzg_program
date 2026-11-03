package com.ayjs.mxzg;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.config.Config;
import com.ayjs.mxzg.processor.DataProcessorProxy;
import com.ayjs.mxzg.repository.manager.MergeRepositoryManager;
import com.ayjs.mxzg.repository.manager.TableMetaManager;
import com.ayjs.mxzg.repository.persister.DataSourceInitializer;
import com.ayjs.mxzg.repository.persister.MergeRepository;
import com.ayjs.mxzg.repository.platform.DatabaseInfo;
import com.ayjs.mxzg.repository.platform.Server;
import com.ayjs.mxzg.service.DataProcessorMetaManager;
import com.ayjs.mxzg.service.MergeService;
import com.google.common.reflect.TypeToken;
import lombok.extern.slf4j.Slf4j;

import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * Hello world!
 */
@Slf4j
public class MergeServerStartUp {
    public static void main(String[] args) throws Exception {

        log.info("启动参数：" + GsonUtils.toJson(args));
        if (args == null || args.length == 0) {
            Config.getInstance().setResourcePath(MergeServerStartUp.class.getResource("/").getPath());
        } else {
            Config.getInstance().setResourcePath(args[0]);
            if (args.length >= 2) {
                Config.getInstance().setStartWithFile(false);
                Config.getInstance().setResourcePath(args[0]);
                Integer[] sources = GsonUtils.fromJson(args[1], new TypeToken<Integer[]>() {
                });
                Config.getInstance().setSource(Stream.of(sources).collect(Collectors.toSet()));
                Config.getInstance().setTarget(sources[0]);
            }
            if (args.length >= 5) {
                Config.getInstance().setJdbcUrl(args[2]);
                Config.getInstance().setPlatformUser(args[3]);
                Config.getInstance().setPlatformPwd(args[4]);
            }


        }

        log.info("启动配置路劲：" + Config.getInstance().getResourcePath());

        Map<String, Set<Class<? extends AbstractEntity>>> allTables = ReflectionUtil.scannerRepository("com.ayjs.mxzg");
        TableMetaManager.getInstance().init(allTables);
        //初始化TableMerge
        DataProcessorMetaManager.getInstance().registerMeta(allTables);
        //MergeHandler初始化处理类
        DataProcessorProxy.getInstance();

        //初始化平台数据库
        Config.getInstance().parseMergeProperties();

        log.info("合并服务器源服务器：{}，目标服务器：{}", GsonUtils.toJson(Config.getInstance().getSource()), Config.getInstance().getTarget());

        DataSourceInitializer.initPlatform();
        MergeRepositoryManager.getInstance().initPlatform();

        //初始化游戏数据库
        MergeRepository repository = MergeRepositoryManager.getInstance().getPlatform();
        List<Server> servers = repository.listAll(Server.class);

        servers = servers.stream().filter(server -> Config.getInstance().isMergeServer(server.getId())).collect(Collectors.toList());

        //过滤掉已经是子服务器的服务器
        servers = servers.stream().filter(server -> server.getParentId() == 0).collect(Collectors.toList());

        Config.getInstance().setSource(servers.stream().mapToInt(Server::getId).boxed().collect(Collectors.toSet()));
        log.info("实际合服的服务器id：{}", GsonUtils.toJson(Config.getInstance().getSource()));

        if (servers.size() == 0) {
            log.error("合服服务器{}不存在！", GsonUtils.toJson(Config.getInstance().getSource()));
            return;
        }

        repository.execute(repository.buildCreateSQL(TableMetaManager.getInstance().get(DatabaseInfo.class)));

        Map<String, DatabaseInfo> dataBaseInfos = repository.listAll(DatabaseInfo.class).stream().collect(Collectors.toMap(DatabaseInfo::getSlaveDb, Function.identity()));
        servers.forEach(server -> DataSourceInitializer.initDBSource(server, dataBaseInfos));
        MergeRepositoryManager.getInstance().initServerGame(servers);

        MergeService.merge();

    }

}
