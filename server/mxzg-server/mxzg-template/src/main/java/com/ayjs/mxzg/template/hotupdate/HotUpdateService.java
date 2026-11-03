package com.ayjs.mxzg.template.hotupdate;

import cn.hutool.core.io.FileUtil;
import com.ayjs.agent.Agent;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.sun.tools.attach.VirtualMachine;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;

import java.io.File;
import java.lang.management.ManagementFactory;
import java.net.URL;
import java.net.URLDecoder;
import java.util.stream.Stream;

@Slf4j
@Component
@Configuration
public class HotUpdateService {

    @Value("${patch.class.path:}")
    private String patchClassPath;

    /**
     * 加载Agent
     *
     * @throws Exception
     */
    public void loadAgent() throws Exception {

        File[] files = FileUtil.ls(patchClassPath);
        if (files != null && files.length > 0) {
            Stream.of(files).forEach(file -> System.out.println(file.getAbsolutePath()));
        }

        String pid = getPid();
        String path = getJarPath();
        VirtualMachine vm = VirtualMachine.attach(pid);// 虚拟机加载
        vm.loadAgent(path, patchClassPath);
        vm.detach();

        Stream.of(files).forEach(file -> {
            // 备份已更新的文件
            if (file.getAbsolutePath().endsWith("class")) {
                FileUtil.rename(file, file.getAbsolutePath() + "." + DateTimeUtil.currentSecond(), false, true);
            }
        });
    }

    /**
     * 获取程序pid
     *
     * @return
     */
    private String getPid() {
        String name = ManagementFactory.getRuntimeMXBean().getName();
        return name.split("@")[0];
    }

    /**
     * 获取jar包路径
     *
     * @return
     */
    private String getJarPath() {
        // StringUtils是jar文件内容
        URL url = Agent.class.getProtectionDomain().getCodeSource().getLocation();
        String filePath = null;
        try {
            // 转化为utf-8编码
            filePath = URLDecoder.decode(url.getPath(), "utf-8");
        } catch (Exception e) {
            e.printStackTrace();
        }
        File file = new File(filePath);
        filePath = file.getAbsolutePath();
        return filePath;
    }

}
