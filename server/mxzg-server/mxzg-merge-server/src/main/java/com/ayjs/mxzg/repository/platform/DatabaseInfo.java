package com.ayjs.mxzg.repository.platform;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2020/12/5
 **/
@Table(name = "database_info")
@Setter
@Getter
public class DatabaseInfo extends AbstractEntity {

    @Id
    @Column(name = "id")
    private int id;

    @Column(name = "master_db", comment = "主库地址")
    private String masterDb;

    @Column(name = "slave_db", comment = "从库地址")
    private String slaveDb;
    @Column(name = "master_db_user", comment = "主库账号")
    private String masterDbUser;

    @Column(name = "master_db_password", comment = "主库密码")
    private String masterDbPassword;

    @Column(name = "slave_db_user", comment = "从库账号")
    private String salveDbUser;

    @Column(name = "slave_db_password", comment = "从库密码")
    private String salveDbPassword;
}
