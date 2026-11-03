1.打包mxzg-merge-server项目（只支持同平台合服）
2.配置说明
    1.platform-db.properties 连接平台服的配置
    2.log4j.properties 日志打印文件
  #  3.merge.properties合服配置
  # 说明: 1.merge.target = 7  合服目标服
  #       2.merge.source  =[7,8,9,10] 源服务器
  #          注：源服务器必须包含目标服务器
        
3.启动 
  启动类：com.ayjs.mxzg.MergeServerStartUp 
  启动参数：配置文件夹路径 合并服务器列表（第一个当作目标服） 平台数据库url 数据库用户 数据库密码
  实例
  java -Djava.ext.dirs=%server_folder%\jar\ com.ayjs.mxzg.MergeServerStartUp %server_folder%\config\ [1,2] "jdbc:mysql://127.0.0.1:3306/mxzg_platform?rewriteBatchedStatements=true&autoReconnect=true&useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=false&serverTimezone=GMT%2B8" root root

4.将源服的游戏入口指向目标服（改变平台server里面的配置）

目标服服务器启动配置修改：
application.properties文件：
    1.新增字段sub.server.id=[7,8,9,10]
    
平台入口修改：修改后台数据库信息
将源服器里面平台接口改成目标服的接口 （server表包括extranet_host，intranet_host，game_port，http_port，game_db和log_db改成跟目标服一样）
