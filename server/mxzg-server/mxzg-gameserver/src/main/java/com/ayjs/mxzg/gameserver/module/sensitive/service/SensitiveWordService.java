package com.ayjs.mxzg.gameserver.module.sensitive.service;

import cn.hutool.core.collection.CollectionUtil;
import cn.hutool.core.util.StrUtil;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Ordinal;
import com.ayjs.mxzg.common.lifecycle.Priority;
import com.ayjs.mxzg.common.util.SymbolConstants;
import com.ayjs.mxzg.common.util.tuple.Tuple2;
import com.ayjs.mxzg.config.excel.cache.SensitiveSysCache;
import com.ayjs.mxzg.config.struct.Language;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.sensitive.dao.LanguageSensitiveWordsDao;
import com.ayjs.mxzg.gameserver.module.sensitive.dao.SensitiveWordDao;
import com.ayjs.mxzg.gameserver.module.sensitive.domain.LanguageSensitiveWords;
import com.ayjs.mxzg.gameserver.module.sensitive.domain.SensitiveWord;
import com.ayjs.mxzg.template.language.LanguageHelper;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.Maps;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Slf4j
@Service
public class SensitiveWordService implements Lifecycle {

    /**
     * 替换的字符
     */
    private static final String REPLACE_CHAR = "*";

    /**
     * 敏感字词缓存Map(第一个字符，其余字符的List)
     */
    private final Map<Integer, Map<String, Set<String>>> configSensitiveMap = new ConcurrentHashMap<>();

    /**
     * 后台添加的敏感词
     */
    private final Map<Integer, Map<String, Set<String>>> dbSensitiveMap = new ConcurrentHashMap<>();

    /**
     * 过滤字符缓存 字符长度--> * 个数
     */
    private final Map<Integer, String> filterCharMap = new HashMap<>();

    /**
     * 临时敏感字词的敏感字集合
     */
    private volatile ImmutableList<Pattern> dbSensitiveList;

    private ImmutableList<Pattern> speciallySensitiveList;
    @Autowired
    private SensitiveSysCache sensitiveSysCache;
    @Autowired
    private LanguageHelper languageHelper;
    @Autowired
    private SensitiveWordDao sensitiveWordDao;
    @Autowired
    private ServerConfig serverConfig;

    @Autowired
    private LanguageSensitiveWordsDao languageSensitiveWordsDao;


    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf(Priority.MEDIUM, Ordinal._12, "SENSITIVE WORD");
    }

    @Override
    public void start() throws Exception {
        loadSpeciallySensitive();
        loadSpeciallySensitivePattern();
        loadConfigSensitive();
        loadDBSensitive();
        loadLanguageSensitive();
    }


    private void loadConfigSensitive() {
        sensitiveSysCache.getAll().forEach(bean -> {
            try {
                for (Language language : Language.values()) {
                    String languageStr = languageHelper.getLanguageBy(bean, language.getCode());
                    if (StringUtils.isNotBlank(languageStr)) {
                        Tuple2<String, String> tuple = SensitiveSupport.splitSensitiveWord(languageHelper.getLanguageBy(bean, language.getCode()));
                        configSensitiveMap.computeIfAbsent(language.getCode(), key -> Maps.newConcurrentMap())
                                .computeIfAbsent(tuple._1, key -> ConcurrentHashMap.newKeySet()).add(tuple._2);
                    }
                }
            } catch (Exception e) {
                log.debug("敏感字库解析有问题，配置id:" + bean.getIdx() + "--，内容：" + languageHelper.getLanguageBy(bean));
                e.printStackTrace();
            }
        });
    }


    /**
     * 系统用特殊字符的过滤
     */
    private void loadSpeciallySensitive() {
        for (Language language : Language.values()) {
            configSensitiveMap.computeIfAbsent(language.getCode(), key -> Maps.newConcurrentMap()).put(SymbolConstants.DIAMOND, buildEmptyWords());
            configSensitiveMap.computeIfAbsent(language.getCode(), key -> Maps.newConcurrentMap()).put(SymbolConstants.STAR, buildEmptyWords());
            configSensitiveMap.computeIfAbsent(language.getCode(), key -> Maps.newConcurrentMap()).put(SymbolConstants.CIRCLE, buildEmptyWords());
            configSensitiveMap.computeIfAbsent(language.getCode(), key -> Maps.newConcurrentMap()).put(SymbolConstants.SOLID_DOT, buildEmptyWords());
            configSensitiveMap.computeIfAbsent(language.getCode(), key -> Maps.newConcurrentMap()).put(SymbolConstants.VERTICAL_BAR, buildEmptyWords());
            configSensitiveMap.computeIfAbsent(language.getCode(), key -> Maps.newConcurrentMap()).put(SymbolConstants.UNDERSCORE, buildEmptyWords());
            configSensitiveMap.computeIfAbsent(language.getCode(), key -> Maps.newConcurrentMap()).put(SymbolConstants.LESS, buildEmptyWords());
            configSensitiveMap.computeIfAbsent(language.getCode(), key -> Maps.newConcurrentMap()).put(SymbolConstants.GREATER, buildEmptyWords());
        }
    }

    private void loadSpeciallySensitivePattern() {
        List<Pattern> list = new ArrayList<>();
//        list.add(Pattern.compile("[]"));
        list.add(Pattern.compile("([+=＋＝0123456789１２３４５６７８９０㈠㈡㈢㈣㈤㈥㈦㈧㈨⑴⑵⑶⑷⑸⑹⑺⑻⑼⒈⒉⒊⒋⒌⒍⒎⒏⒐①②④⑤⑥⑦⑧⑨〇一二三四五六七八九百佰千仟万亿壹貳叁肆陸柒捌汣].*){6,}"));
//        list.add(Pattern.compile("([0-9].*){6,}"));
        speciallySensitiveList = ImmutableList.copyOf(list);
    }

    /**
     * 用于取名，设置公告等
     */
    public boolean wordCanUse(String word, Role role) {
        return !containsConfigSensitiveWord(word, role);
    }

    /**
     * 用于聊天
     */
    public boolean wordCanUseChat(String word) {
        return !containsDBSensitiveWord(word) && !containsSpeciallySensitiveWord(word);
    }

    /**
     * 过滤敏感字词,把敏感字用 * 代替
     */
    public String filterSensitiveWord(String context, Role role) {
        context = _filterSensitiveWord(context, role, configSensitiveMap);
        context = _filterSensitiveWord(context, role, dbSensitiveMap);
        return context;
    }

    // 玩家修改昵称判断屏蔽字
    public boolean checkMaskedWord(String word, Role role) {
        String newStr = _filterSensitiveWord(word, role, dbSensitiveMap);
        return newStr.equals(word);
    }

    public String _filterSensitiveWord(String context, Role role) {
       return  _filterSensitiveWord(context, role, dbSensitiveMap);
    }

    private String _filterSensitiveWord(String context, Role role, Map<Integer, Map<String, Set<String>>> sensitiveMap) {
        try {
            String[] strs = context.trim().split("");
            int index = 0;
            while (index < strs.length) {
                String temp = strs[index];
                Set<String> words = new HashSet<>();
                if (Objects.nonNull(role)) {
                    Set<String> tempSet = null;
                    if (Objects.nonNull(sensitiveMap.get(role.getLang()))) {
                        tempSet = sensitiveMap.get(role.getLang()).get(temp.toLowerCase());
                        if (CollectionUtil.isNotEmpty(tempSet)) {
                            words.addAll(tempSet);
                        }
                    }
                }

                int serverLang = serverConfig.getServerLang();
                if (serverLang != 0) {
                    if (role == null || serverLang != role.getLang()) {
                        Set<String> tempSet = null;
                        if (Objects.nonNull(sensitiveMap.get(serverLang))) {
                            tempSet = sensitiveMap.get(serverLang).get(temp.toLowerCase());
                            if (CollectionUtil.isNotEmpty(tempSet)) {
                                words.addAll(tempSet);
                            }
                        }
                    }
                }

                if (Objects.nonNull(serverConfig.getSensitiveLang())) {
                    for (int language : serverConfig.getSensitiveLang()) {
                        if (role == null || language != role.getLang() || language != serverLang) {
                            Set<String> tempSet = null;
                            if (Objects.nonNull(sensitiveMap.get(language))) {
                                tempSet = sensitiveMap.get(language).get(temp.toLowerCase());
                                if (CollectionUtil.isNotEmpty(tempSet)) {
                                    words.addAll(tempSet);
                                }
                            }
                        }
                    }
                }

                if (CollectionUtil.isEmpty(words)) {
                    index++;
                } else {
                    int j = index + 1;
                    boolean isReplace = false;
                    for (String word : words) {
                        if (j + word.length() > strs.length) {
                            continue;
                        }
                        if (j + word.length() > context.length()) {
                            continue;
                        }
                        if (word.equalsIgnoreCase(context.substring(j, j + word.length()))) {
                            context = StrUtil.replace(context, temp + word, buildFilter(temp + word), true);
                            j += word.length();
                            isReplace = true;
                            break;
                        }
                    }
                    // 匹配到就加字段长度，没有匹配到就加1
                    if (isReplace) {
                        index = j;
                    } else {
                        index++;
                    }
                }
            }
        } catch (Exception e) {
            log.error("filterSensitiveWord error", e);
        }
        return context;
    }

    /**
     * 组装屏蔽字符
     */
    private String buildFilter(String word) {
        if (filterCharMap.containsKey(word.length())) {
            return filterCharMap.get(word.length());
        }
        StringBuilder builder = new StringBuilder();
        for (int i = 0; i < word.length(); i++) {
            builder.append(REPLACE_CHAR);
        }
        String filter = builder.toString();
        filterCharMap.put(word.length(), filter);
        return filter;
    }

    /**
     * 匹配数据库中的正则表达式，用于聊天模块
     *
     * @param context
     * @return
     */
    private boolean containsDBSensitiveWord(String context) {
        return dbSensitiveList.stream().anyMatch(word -> word.matcher(context).find());
    }

    private boolean containsSpeciallySensitiveWord(String context) {
        return speciallySensitiveList.stream().anyMatch(word -> word.matcher(context).find());
    }

    /**
     * 匹配配置文件的敏感字，用于取名和聊天模块
     *
     * @param context
     * @return
     */
    private boolean containsConfigSensitiveWord(String context, Role role) {
        return findConfigSensitiveWord(context, role) != null;
    }

    /**
     * 匹配配置文件中敏感字,用于取名和聊天
     */
    public String findConfigSensitiveWord(String context, Role role) {
        String firstSensitiveWord = null;
        if (role != null) {
            firstSensitiveWord = SensitiveSupport.findFirstSensitiveWord(context, configSensitiveMap.get(role.getLang()));
        }
        if (firstSensitiveWord == null && serverConfig.getSensitiveLang() != null) {
            for (int language : serverConfig.getSensitiveLang()) {
                if (role == null || role.getLang() != language) {
                    firstSensitiveWord = SensitiveSupport.findFirstSensitiveWord(context, configSensitiveMap.get(language));
                    if (firstSensitiveWord != null) {
                        break;
                    }
                }
            }
        }

        return firstSensitiveWord;
    }

    /**
     * 后台添加敏感词
     *
     * @param addlanguages
     * @param word
     */
    public void addSensitiveToDB(String word, List<Integer> addlanguages) {
        LanguageSensitiveWords languageSensitiveWords = getDbDataByWord(word);
        if (Objects.isNull(languageSensitiveWords)) {
            languageSensitiveWords = new LanguageSensitiveWords();
            languageSensitiveWords.setWord(word);
            languageSensitiveWords.setLanguages(addlanguages);
            languageSensitiveWordsDao.add(languageSensitiveWords);
        } else {
            List<Integer> languages = languageSensitiveWords.getLanguages();
            languages.removeAll(addlanguages);
            languages.addAll(addlanguages);
            languageSensitiveWords.setLanguages(languages);
            languageSensitiveWordsDao.update(languageSensitiveWords);
        }

        addWordToDbSensitiveMap(word, languageSensitiveWords.getLanguages());
    }

    private void addWordToDbSensitiveMap(String word, List<Integer> languages) {
//        sensitiveSysCache.getAll().forEach(config -> {
//            try {
//                for (Language language : Language.values()) {
//                    String str = languageHelper.getLanguageBy(config, language.getCode());
//                    if(StringUtils.isNotBlank(str)) {
//                        Tuple2<String, String> tuple = SensitiveSupport.splitSensitiveWord(str);
//                        dbSensitiveMap.computeIfAbsent(language.getCode(), key -> Maps.newConcurrentMap())
//                                .computeIfAbsent(tuple._1, key -> ConcurrentHashMap.newKeySet()).add(tuple._2);
//                    }
//                }
//            }catch (Exception e) {
//                e.printStackTrace();
//            }
//        });
        for (Integer language : languages) {
            Tuple2<String, String> tuple = SensitiveSupport.splitSensitiveWord(word);
            dbSensitiveMap.computeIfAbsent(language, key -> Maps.newConcurrentMap())
                    .computeIfAbsent(tuple._1, key -> ConcurrentHashMap.newKeySet()).add(tuple._2);
        }
    }


    private LanguageSensitiveWords getDbDataByWord(String word) {
        List<LanguageSensitiveWords> words = languageSensitiveWordsDao.listAll();
        for (LanguageSensitiveWords dbWord : words) {
            if (word.equals(dbWord.getWord())) {
                return dbWord;
            }
        }
        return null;
    }

    /**
     * 更新过滤正则表达式
     */
    public void replaceSensitiveWord(List<String> words) {
        sensitiveWordDao.deleteAll();
        List<SensitiveWord> wordList = words.stream().map(SensitiveWord::new).collect(Collectors.toList());
        sensitiveWordDao.add(wordList);

        List<Pattern> patternList = wordList.stream().map(word -> stringTOPattern(word.getWord()))
                .collect(Collectors.toList());
        setDbSensitiveList(patternList);
    }

    private Set<String> buildEmptyWords() {
        Set<String> words = ConcurrentHashMap.newKeySet(1);
        words.add(StringUtils.EMPTY);
        return words;
    }

    private void loadDBSensitive() {
        List<Pattern> words = sensitiveWordDao.listAll().stream()
                .map(SensitiveWord::getWord)
                .map(this::stringTOPattern)
                .collect(Collectors.toList());
        setDbSensitiveList(words);
    }

    private void loadLanguageSensitive() {
        List<LanguageSensitiveWords> languageSensitiveWords = languageSensitiveWordsDao.listAll();
        for (LanguageSensitiveWords languageSensitiveWord : languageSensitiveWords) {
            addWordToDbSensitiveMap(languageSensitiveWord.getWord(), languageSensitiveWord.getLanguages());
        }
    }

    private Pattern stringTOPattern(String str) {
        return Pattern.compile(str);
    }

    private void setDbSensitiveList(List<Pattern> words) {
        dbSensitiveList = ImmutableList.copyOf(words);
    }

}
