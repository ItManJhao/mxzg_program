package com.ayjs.mxzg.common.config;

import com.ayjs.mxzg.common.config.reader.FileMeta;
import com.ayjs.mxzg.common.config.reader.IReader;
import com.google.common.base.Preconditions;
import lombok.extern.slf4j.Slf4j;

import java.io.File;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.Objects;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.Collectors;

@Slf4j
public class ConfigLoaderImpl implements ConfigLoader {

    private final String configPath;
    private final IReader reader;
    private final Function<String, IConfig<?>> configFunction;

    public ConfigLoaderImpl(String configPath, IReader reader, Function<String, IConfig<?>> configFunction) {
        this.configPath = configPath;
        this.reader = reader;
        this.configFunction = configFunction;
    }

    /**
     * 加载配置文件
     */
    @Override
    public void load() {
        log.info("配置目录: {}", configPath);
        log.info("开始加载配置文件...");
        File dir = new File(configPath);
        File[] _files = dir.listFiles();
        Preconditions.checkNotNull(_files, "配置文件路径错误");
        List<File> files = Arrays.stream(_files)
                .filter(File::isFile)
                .filter(file -> checkState(matchReaderType(file.getName()), "配置{{}}不符合读取文件类型", file.getName()))
                .collect(Collectors.toList());
        loadAllConfigs(files);
        log.info("所有配置文件加载完毕...");
    }

    /**
     * 重新加载指定配置文件
     *
     * @param filenameList 文件名(有扩展名)列表
     */
    @Override
    public void reload(List<String> filenameList) {
        log.info("重新加载配置{}", filenameList);
        List<File> files = newReloadFileList(filenameList);
        requireReloadFilesValid(files);
        reloadAllConfigs(files);
        log.info("配置{}重新加载完毕", filenameList);
    }

    private List<File> newReloadFileList(List<String> filenameList) {
        return filenameList.stream().map(this::newReloadFile).collect(Collectors.toList());
    }

    private File newReloadFile(String filename) {
        return new File(configPath + File.separator + filename);
    }

    private void requireReloadFilesValid(List<File> files) {
        files.forEach(this::requireReloadFileValid);
    }

    private void requireReloadFileValid(File file) {
        Preconditions.checkArgument(file.exists(), "配置{%s}不存在", file.getName());
        Preconditions.checkArgument(file.isFile(), "配置{%s}不是文件", file.getName());
        Preconditions.checkArgument(matchReaderType(file.getName()), "配置{%s}不符合读取文件类型", file.getName());
    }

    private boolean matchReaderType(String filename) {
        return reader.matchType(filename);
    }

    private boolean requireHasConfigStructure(FileMeta fileMeta) {
        Preconditions.checkArgument(hasConfigStructure(fileMeta), "配置{%s}没有对应的数据结构", fileMeta.getName());
        return true;
    }

    private boolean warnWithoutConfigStructure(FileMeta fileMeta) {
        return checkState(hasConfigStructure(fileMeta), "配置{{}}没有对应的数据结构", fileMeta.getName());
    }

    private boolean hasConfigStructure(FileMeta fileMeta) {
        return configFunction.apply(fileMeta.getName()) != null;
    }

    private void loadAllConfigs(List<File> files) {
        List<FileMeta> metas = loadAllFiles(files, this::warnWithoutConfigStructure);
        loadAllFileMetas(metas);
    }

    private void reloadAllConfigs(List<File> files) {
        List<FileMeta> metas = loadAllFiles(files, this::requireHasConfigStructure);
        loadAllFileMetas(metas);
    }

    private List<FileMeta> loadAllFiles(List<File> files, Predicate<FileMeta> checkConfigStructure) {
        return files.stream()
                .sorted(Comparator.comparing(File::getName))
                .map(file -> readFile(file, checkConfigStructure))
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
    }

    private void loadAllFileMetas(List<FileMeta> fileMetas) {
        fileMetas.forEach(this::loadConfig);
    }

    private FileMeta readFile(File file, Predicate<FileMeta> checkConfigStructure) {
        log.info("读取配置文件: {}", file.getName());
        FileMeta fileMeta = reader.handlerData(file);
        Preconditions.checkNotNull(fileMeta, "配置文件{%s}读取失败", file.getName());
        return checkConfigStructure.test(fileMeta) ? fileMeta : null;
    }

    private void loadConfig(FileMeta fileMeta) {
        IConfig<?> config = configFunction.apply(fileMeta.getName());
        log.info("加载配置: {}", fileMeta.getName());
        try {
            config.loadCache(fileMeta.getHead(), fileMeta.getData(), fileMeta.getReadType());
        } catch (Exception e) {
            log.error("加载配置{{}}出现异常", fileMeta.getName());
            throw e;
        }
    }

    private boolean checkState(boolean b, String format, Object... arguments) {
        if (!b) log.warn(format, arguments);
        return b;
    }
}
