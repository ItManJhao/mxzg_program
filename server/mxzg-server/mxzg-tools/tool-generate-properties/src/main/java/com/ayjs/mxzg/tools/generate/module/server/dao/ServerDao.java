package com.ayjs.mxzg.tools.generate.module.server.dao;

import com.ayjs.mxzg.tools.generate.module.server.domain.Server;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ServerDao extends JpaRepository<Server, Long> {
}
