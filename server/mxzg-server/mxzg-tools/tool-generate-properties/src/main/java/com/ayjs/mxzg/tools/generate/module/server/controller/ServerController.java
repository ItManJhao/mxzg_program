package com.ayjs.mxzg.tools.generate.module.server.controller;

import com.ayjs.mxzg.tools.generate.module.server.dao.ServerDao;
import com.ayjs.mxzg.tools.generate.module.server.domain.Server;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/server")
public class ServerController {
    @Autowired
    private ServerDao serverDao;

    @RequestMapping(value = "/getAll", method = RequestMethod.GET)
    public List<Server> getAll() {
        List<Server> servers = serverDao.findAll();
        log.info("server:{}", servers);
        return servers;
    }
}
