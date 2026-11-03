package com.ayjs.mxzg.tools.generate;

import javafx.util.Pair;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

/***
 * 生成插入平台服务器信息的sql语句
 */
public class GenerateServerSql {
    private static int firstId = 210;
    private static List<Pair<String, String>> innerIpList = new ArrayList<>();
    private static List<String> dbHosts = new ArrayList<>();
    private static int serverNum = 31;
    private static int dbNum = 40;
    private static int game_port = 18000;
    private static int http_port = 10000;

    static {

//        innerIpList.add(new Pair<>("qyzh-game-s1.hihiplay.com", "192.168.0.208"));
//        innerIpList.add(new Pair<>("qyzh-game-s2.hihiplay.com", "192.168.0.207"));
//        innerIpList.add(new Pair<>("qyzh-game-s3.hihiplay.com", "192.168.0.215"));
//        innerIpList.add(new Pair<>("qyzh-game-s4.hihiplay.com", "192.168.0.212"));
//        innerIpList.add(new Pair<>("qyzh-game-s5.hihiplay.com", "192.168.0.213"));
//        innerIpList.add(new Pair<>("qyzh-game-s6.hihiplay.com", "192.168.0.214"));
//        innerIpList.add(new Pair<>("qyzh-game-s7.hihiplay.com", "192.168.0.216"));
//        innerIpList.add(new Pair<>("qyzh-game-s8.hihiplay.com", "192.168.0.219"));
//        innerIpList.add(new Pair<>("qyzh-game-s9.hihiplay.com", "192.168.0.220"));
//        innerIpList.add(new Pair<>("qyzh-game-s10.hihiplay.com", "192.168.0.222"));
//        innerIpList.add(new Pair<>("qyzh-game-s11.hihiplay.com", "192.168.0.221"));
//        innerIpList.add(new Pair<>("qyzh-game-s12.hihiplay.com", "192.168.0.223"));
        innerIpList.add(new Pair<>("8.210.35.82", "192.168.0.220"));
        innerIpList.add(new Pair<>("8.210.35.82", "192.168.0.220"));
        innerIpList.add(new Pair<>("8.210.34.32", "192.168.0.223"));
        innerIpList.add(new Pair<>("8.210.34.32", "192.168.0.223"));
//        innerIpList.add(new Pair<>("8.210.82.108", "192.168.0.227"));
//        innerIpList.add(new Pair<>("8.210.11.222", "192.168.0.216"));
//        innerIpList.add(new Pair<>("8.210.82.108", "192.168.0.227"));
//        innerIpList.add(new Pair<>("8.210.72.157", "192.168.0.228"));

//        dbHosts.add("rr-j6c6g99oss55gka69.mysql.rds.aliyuncs.com");
        dbHosts.add("rr-j6c6g99oss55gka69.mysql.rds.aliyuncs.com");
        dbHosts.add("rr-j6c6g99oss55gka69.mysql.rds.aliyuncs.com");
        dbHosts.add("rr-j6c6g99oss55gka69.mysql.rds.aliyuncs.com");
        dbHosts.add("rr-j6c6g99oss55gka69.mysql.rds.aliyuncs.com");
        dbHosts.add("rr-j6c6g99oss55gka69.mysql.rds.aliyuncs.com");

    }

    public static int getIpIndex(int serverId) {
        int index = serverId / 20;
        int index2 = serverId % 20;
        int index3 = index2 / 6;
        index3 = index3 % 2;
        return Math.min(index * 2 + index3, innerIpList.size() - 1);
    }

    public static void main(String[] args) throws IllegalAccessException {
        for (int serverId = 0; serverId < serverNum; serverId++) {
            DefaultServer def = new DefaultServer();
            int realServerId = serverId + firstId;
            def.setId(realServerId);
            int index = getIpIndex(serverId);
            Pair<String, String> ip = innerIpList.get(index);
            def.setExtranet_host(ip.getKey());
            def.setIntranet_host(ip.getValue());

            def.setDb_host(dbHosts.get(Math.min(serverId / dbNum, dbHosts.size() - 1)));
            def.setGame_port(game_port + realServerId);
            def.setHttp_port(http_port + realServerId);

            System.out.println(toSql(def));

        }
    }

    public static String toSql(DefaultServer defaultServer) throws IllegalAccessException {
        StringBuffer fieldName = new StringBuffer();
        StringBuffer fieldValue = new StringBuffer();
        Field[] fields = DefaultServer.class.getDeclaredFields();
        for (Field field : fields) {
            field.setAccessible(true);
            fieldName.append("`");
            fieldName.append(field.getName());
            fieldName.append("`");
            fieldName.append(",");
            if (field.getType() == String.class) {
                fieldValue.append("'");
                fieldValue.append(field.get(defaultServer));
                fieldValue.append("'");
            } else {
                fieldValue.append(field.get(defaultServer));
            }
            fieldValue.append(",");
        }

        StringBuffer sqlBuffer = new StringBuffer();
        sqlBuffer.append("insert into server ( ");
        sqlBuffer.append(fieldName.substring(0, fieldName.length() - 1));
        sqlBuffer.append(" ) values ( ");
        sqlBuffer.append(fieldValue.substring(0, fieldValue.length() - 1));
        sqlBuffer.append(" );");
        return sqlBuffer.toString();
    }

    static class DefaultServer {
        private long id = 1;
        private String extranet_host;
        private String intranet_host;
        private int game_port = 18001;
        private int http_port = 10001;
        private String server_name = "夢境" + id + "服";
        private String note = "";
        private int is_new = 1;
        private int type = 0;
        private int status = 0;
        private int defend_end_time = 0;
        private int open_time = 1621440000;
        private int heart_beat_time = 0;
        private String db_host = "rr-j6c6g99oss55gka69.mysql.rds.aliyuncs.com";
        private int db_port = 3306;
        private String db_user = "qyzh_select";
        private String db_password = "^-^qyzh_select&201912";
        private String msg = "";
        private String db_game_database = "mxzg_" + id + "_data";
        private String db_log_database = "mxzg_" + id + "_log";
        private int role_nums = 0;
        private int role_nums_limit = 1100;
        private int group_id = 1;
        private int created_at = 1589959900;
        private int updated_at = 1589959900;

        public void setId(long id) {
            db_game_database = db_game_database.replace(String.valueOf(this.id), String.valueOf(id));
            db_log_database = db_log_database.replace(String.valueOf(this.id), String.valueOf(id));
            server_name = server_name.replace(String.valueOf(this.id), String.valueOf(id));

            this.id = id;
        }

        public void setExtranet_host(String extranet_host) {
            this.extranet_host = extranet_host;
        }

        public void setIntranet_host(String intranet_host) {
            this.intranet_host = intranet_host;
        }

        public void setDb_host(String db_host) {
            this.db_host = db_host;
        }

        public void setGame_port(int game_port) {
            this.game_port = game_port;
        }

        public void setHttp_port(int http_port) {
            this.http_port = http_port;
        }
    }
}
