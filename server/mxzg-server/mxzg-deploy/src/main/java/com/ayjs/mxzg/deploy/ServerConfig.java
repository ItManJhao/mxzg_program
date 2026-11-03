/**
 *
 */
package com.ayjs.mxzg.deploy;

import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.annotation.JSONType;

/**
 * @author YY
 *
 */
@JSONType(orders = {"id", "tcpPort", "webPort", "webPort", "battleReportPath", "patchClassPath", "configPath", "ipRegionFile",
        "gameDbUrl", "gameUserName", "gamePassword", "logDbUrl", "logUserName", "logPassword", "resourcesPath",
        "sensitiveServerLang", "serverLang", "serverPlatformId", "serverPlatformSonId", "centerServerHost",
        "centerServerPort", "largeServerHost", "largeServerPort", "platformUri", "managementUrl", "springRedisHost",
        "springRedisPassword"})
public class ServerConfig {
    @DeployValue("serverId")
    private int id;
    @DeployValue("tcpPort")
    private int tcpPort;
    @DeployValue("webPort")
    private int webPort;
    @DeployValue("webSocket")
    private int webSocket;
    @DeployValue("battleReportPath")
    private String battleReportPath = "";
    @DeployValue("patchClassPath")
    private String patchClassPath = "";
    @DeployValue("configPath")
    private String configPath = "";
    @DeployValue("ipRegionFile")
    private String ipRegionFile = "";

    @DeployValue("gameDbUrl")
    private String gameDbUrl = "";
    @DeployValue("gameUserName")
    private String gameUserName = "";
    @DeployValue("gamePassword")
    private String gamePassword = "";

    @DeployValue("logDbUrl")
    private String logDbUrl = "";
    @DeployValue("logUserName")
    private String logUserName = "";
    @DeployValue("logPassword")
    private String logPassword = "";
    @DeployValue("resourcesPath")
    private String resourcesPath = "";
    @DeployValue("sensitiveServerLang")
    private String sensitiveServerLang = "";
    @DeployValue("serverLang")
    private String serverLang = "";
    @DeployValue("serverPlatformId")
    private String serverPlatformId = "";
    @DeployValue("serverPlatformSonId")
    private String serverPlatformSonId = "";
    @DeployValue("centerServerHost")
    private String centerServerHost = "";
    @DeployValue("centerServerPort")
    private String centerServerPort = "";
    @DeployValue("largeServerHost")
    private String largeServerHost = "";
    @DeployValue("largeServerPort")
    private String largeServerPort = "";
    @DeployValue("platformUri")
    private String platformUri = "";
    @DeployValue("managementUrl")
    private String managementUrl = "";
    @DeployValue("springRedisHost")
    private String springRedisHost = "";
    @DeployValue("springRedisPassword")
    private String springRedisPassword = "";

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getTcpPort() {
        return tcpPort;
    }

    public void setTcpPort(int tcpPort) {
        this.tcpPort = tcpPort;
    }

    public int getWebPort() {
        return webPort;
    }

    public void setWebPort(int webPort) {
        this.webPort = webPort;
    }

    public int getWebSocket() {
        return webSocket;
    }

    public void setWebSocket(int webSocket) {
        this.webSocket = webSocket;
    }

    public String getBattleReportPath() {
        return battleReportPath;
    }

    public void setBattleReportPath(String battleReportPath) {
        this.battleReportPath = battleReportPath;
    }

    public String getPatchClassPath() {
        return patchClassPath;
    }

    public void setPatchClassPath(String patchClassPath) {
        this.patchClassPath = patchClassPath;
    }

    public String getConfigPath() {
        return configPath;
    }

    public void setConfigPath(String configPath) {
        this.configPath = configPath;
    }

    public String getIpRegionFile() {
        return ipRegionFile;
    }

    public void setIpRegionFile(String ipRegionFile) {
        this.ipRegionFile = ipRegionFile;
    }

    public String getGameDbUrl() {
        return gameDbUrl;
    }

    public void setGameDbUrl(String gameDbUrl) {
        this.gameDbUrl = gameDbUrl;
    }

    public String getGameUserName() {
        return gameUserName;
    }

    public void setGameUserName(String gameUserName) {
        this.gameUserName = gameUserName;
    }

    public String getGamePassword() {
        return gamePassword;
    }

    public void setGamePassword(String gamePassword) {
        this.gamePassword = gamePassword;
    }

    public String getLogDbUrl() {
        return logDbUrl;
    }

    public void setLogDbUrl(String logDbUrl) {
        this.logDbUrl = logDbUrl;
    }

    public String getLogUserName() {
        return logUserName;
    }

    public void setLogUserName(String logUserName) {
        this.logUserName = logUserName;
    }

    public String getLogPassword() {
        return logPassword;
    }

    public void setLogPassword(String logPassword) {
        this.logPassword = logPassword;
    }

    public void setResourcesPath(String resourcesPath) {
        this.resourcesPath = resourcesPath;
    }

    public String getResourcesPath() {
        return resourcesPath;
    }

    public String getSensitiveServerLang() {
        return sensitiveServerLang;
    }

    public void setSensitiveServerLang(String sensitiveServerLang) {
        this.sensitiveServerLang = sensitiveServerLang;
    }

    public String getServerLang() {
        return serverLang;
    }

    public void setServerLang(String serverLang) {
        this.serverLang = serverLang;
    }

    public String getServerPlatformId() {
        return serverPlatformId;
    }

    public void setServerPlatformId(String serverPlatformId) {
        this.serverPlatformId = serverPlatformId;
    }

    public String getServerPlatformSonId() {
        return serverPlatformSonId;
    }

    public void setServerPlatformSonId(String serverPlatformSonId) {
        this.serverPlatformSonId = serverPlatformSonId;
    }

    public String getCenterServerHost() {
        return centerServerHost;
    }

    public void setCenterServerHost(String centerServerHost) {
        this.centerServerHost = centerServerHost;
    }

    public String getCenterServerPort() {
        return centerServerPort;
    }

    public void setCenterServerPort(String centerServerPort) {
        this.centerServerPort = centerServerPort;
    }

    public String getLargeServerHost() {
        return largeServerHost;
    }

    public void setLargeServerHost(String largeServerHost) {
        this.largeServerHost = largeServerHost;
    }

    public String getLargeServerPort() {
        return largeServerPort;
    }

    public void setLargeServerPort(String largeServerPort) {
        this.largeServerPort = largeServerPort;
    }

    public String getPlatformUri() {
        return platformUri;
    }

    public void setPlatformUri(String platformUri) {
        this.platformUri = platformUri;
    }

    public String getManagementUrl() {
        return managementUrl;
    }

    public void setManagementUrl(String managementUrl) {
        this.managementUrl = managementUrl;
    }

    public String getSpringRedisHost() {
        return springRedisHost;
    }

    public void setSpringRedisHost(String springRedisHost) {
        this.springRedisHost = springRedisHost;
    }

    public String getSpringRedisPassword() {
        return springRedisPassword;
    }

    public void setSpringRedisPassword(String springRedisPassword) {
        this.springRedisPassword = springRedisPassword;
    }

    public static void main(String[] args) {
        ServerConfig config = new ServerConfig();
        System.out.println(JSONObject.toJSONString(config));
    }
}
