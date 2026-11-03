//
//  Utils.cpp
//  ClickerHeroes
//
//  Created by Conix on 16-3-2.
//
//

#include "Utils.h"
//#include <CommonCrypto/CommonDigest.h>
#include "../Config/LanguageTable.h"

string StringUtil::lTrim(const string& str)
{
    if (str.compare("") == 0) {
        return "";
    }
    return str.substr(str.find_first_not_of(" \n\r\t"));
}

string StringUtil::rTrim(const string& str)
{
    if (str.compare("") == 0) {
        return "";
    }
    return str.substr(0, str.find_last_not_of(" \n\r\t") + 1);
}

string StringUtil::trim(const string& str)
{
    return lTrim(rTrim(str));
}

int StringUtil::length(const char* s) {
    int len = (int)strlen(s);
    if (len < 3) {
        return len;
    }

    int ret = 0;

    for (int i = 0; i < len;) {
        int a = (int) s[i];

        if (a < 0 || a > 128) {
            ret += 2;
            i += 3;
        } else {
        	ret += 1;
            i += 1;
        }
    }
    return ret;
}

string StringUtil::left(const char* s, int length) {
    int l = (int)strlen(s);
    if (length >= l) {
        return s;
    }
    
    char* buf = (char*)malloc(length + 1);
    memset(buf, 0, length + 1);
    
    for (int i = 0; i < l;) {
        int a = s[i];
        
        if (a < 0 || (int)a > 128) {
            if (i + 3 > length || i + 3 > l) {
                break;
            }
            
            buf[i] = s[i];
            buf[i + 1] = s[i + 1];
            buf[i + 2] = s[i + 2];
            
            i += 3;
        } else {
            if (i + 1 > length || i + 1 > l) {
                break;
            }
            buf[i] = s[i];
            i += 1;
        }
    }
    string ret = buf;
    free(buf);
    return ret;
}

/* 將一個數字按時間的進制法以秒數算，轉換為時間最大的前兩位顯示為字符串 */
string StringUtil::convertIntToTime(uint32_t num, const char* space) {
//    LanguageConfigTable* language_table = LanguageConfigTable::instance();
//    const char* s = language_table->getLanguage(417);
//    const char* m = language_table->getLanguage(416);
//    const char* h = language_table->getLanguage(415);
//    const char* d = language_table->getLanguage(414);
    const char* s = "s";
    const char* m = "m";
    const char* h = "h";
    const char* d = "d";
    if (num <= 0) {
        return StringUtils::format("0%s", s);
    } else if (num < 60) {
        return StringUtils::format("%d%s", num, s);
    } else if (num < 3600) {
        if (num % 60 == 0) {
            return StringUtils::format("%d%s", num/60, m);
        } else {
            return StringUtils::format("%d%s%s%d%s", num/60, m, space, num % 60, s);
        }
    } else if (num < 86400) {
        if ((num % 3600) / 60 == 0) {
            return StringUtils::format("%d%s", num/3600, h);
        } else {
            return StringUtils::format("%d%s%s%d%s", num / 3600, h, space, (num % 3600) / 60, m);
        }
    } else {
        if ((num % 86400) / 3600 == 0) {
            return StringUtils::format("%d%s", num / 86400, d);
        } else {
            return StringUtils::format("%d%s%s%d%s", num / 86400, d, space, (num % 86400) / 3600, h);
        }
    }
}

string StringUtil::convertToMinute(const char* format, int32_t time) {
    int min = time % 3600 / 60;
    int16_t sec = time % 60;
    return StringUtils::format(format , min, sec);
}

string StringUtil::convertIntToMinute(const char* format, int32_t time) {
    int min = time / 60;
    int16_t sec = time % 60;
    return StringUtils::format(format , min, sec);
}


string StringUtil::convertIntToTimeCN(uint32_t num, const char* space) {
    LanguageTable* language_table = LanguageTable::instance();
    const char* s = language_table->getLanguage(34);
    const char* m = language_table->getLanguage(33);
    const char* h = language_table->getLanguage(32);
    const char* d = language_table->getLanguage(31);
    if (num <= 0) {
        return StringUtils::format("0%s", s);
    } else if (num < 60) {
        return StringUtils::format("%d%s", num, s);
    } else if (num < 3600) {
        if (num % 60 == 0) {
            return StringUtils::format("%d%s", num/60, m);
        } else {
            return StringUtils::format("%d%s%s%d%s", num/60, m, space, num % 60, s);
        }
    } else if (num < 86400) {
        if ((num % 3600) / 60 == 0) {
            return StringUtils::format("%d%s", num/3600, h);
        } else {
            return StringUtils::format("%d%s%s%d%s", num / 3600, h, space, (num % 3600) / 60, m);
        }
    } else {
        if ((num % 86400) / 3600 == 0) {
            return StringUtils::format("%d%s", num / 86400, d);
        } else {
            return StringUtils::format("%d%s%s%d%s", num / 86400, d, space, (num % 86400) / 3600, h);
        }
    }
}

string StringUtil::convertIntToTimeTest(uint32_t num, const char* space) {
   // const char* s = "s";
    const char* m = ":";
    const char* h = ":";
    const char* d = ":";
    if (num <= 0) {
        return StringUtils::format("00:00");
    } else if (num < 60) {
        return StringUtils::format("00:%02d", num);
    } else if (num < 3600) {
        if (num % 60 == 0) {
            return StringUtils::format("%02d%s%s", num/60, m, "00");
        } else {
            return StringUtils::format("%02d%s%s%02d", num/60, m, space, num % 60);
        }
    } else if (num < 86400) {
        if ((num % 3600) / 60 == 0) {
            return StringUtils::format("%02d%s", num/3600, h);
        } else {
            return StringUtils::format("%02d%s%s%02d%s", num / 3600, h, space, (num % 3600) / 60, m);
        }
    } else {
        if ((num % 86400) / 3600 == 0) {
            return StringUtils::format("%02d%s", num / 86400, d);
        } else {
            return StringUtils::format("%02d%s%s%02d%s", num / 86400, d, space, (num % 86400) / 3600, h);
        }
    }
}

/* 將一個數字按時間的進制法以秒數算，轉換為時間最大的前兩位顯示為字符串 */
string StringUtil::convertIntToTimeWithColon(uint32_t num)
{
    char buf[30];
    if (num <= 0) {
        sprintf(buf, "00:00");
    } else if (num<60) {
        sprintf(buf, "00:%02d",num);
    } else if(num<3600) {
        sprintf(buf, "%02d:%02d", num/60, num%60);
    } else if(num<86400) {
        sprintf(buf, "%02d:%02d",num/3600, (num%3600)/60);
    } else{
        sprintf(buf, "%02d:%02d", num/86400, (num%86400)/3600);
    }
    return buf;
}

/* 將一個數字按時間的進制法以秒數算，轉換為准确时间顯示為字符串 */
string StringUtil::convertIntToDetailTime(uint32_t num, const char* space) {
    char buf[30];
//    LanguageConfigTable* language_table = LanguageConfigTable::instance();
//    const char* s = language_table->getLanguage(417);
//    const char* m = language_table->getLanguage(416);
//    const char* h = language_table->getLanguage(415);
//    const char* d = language_table->getLanguage(414);
    const char* s = "s";
    const char* m = "m";
    const char* h = "h";
    const char* d = "d";
    if (num <= 0) {
        sprintf(buf, "0%s", s);
    } else if (num<60) {
        sprintf(buf, "%d%s",num, s);
    } else if(num<3600) {
        sprintf(buf, "%d%s%s%d%s", num/60, m, space, num%60, s);
        if (num%60 == 0) {
            sprintf(buf, "%d%s", num/60, m);
        }
    } else if(num<86400) {
        sprintf(buf, "%d%s%s%d%s%s%d%s",num/3600, h, space, (num%3600)/60, m, space, num%60, s);
        if (num%3600 == 0) {
            sprintf(buf, "%d%s", num/3600, h);
        } else if (num%60 == 0) {
            sprintf(buf, "%d%s%s%d%s",num/3600, h, space, (num%3600)/60, m);
        }
    } else{
        sprintf(buf, "%d%s%s%d%s%s%d%s%s%d%s", num/86400, d, space, (num%86400)/3600, h, space, (num%3600)/60, m, space, num%60, s);
        if (num%86400 == 0) {
            sprintf(buf, "%d%s", num/86400, d);
        } else if (num%3600 == 0) {
            sprintf(buf, "%d%s%s%d%s", num/86400, d, space, (num%86400)/3600, h);
        } else if (num%60 == 0) {
            sprintf(buf, "%d%s%s%d%s%s%d%s", num/86400, d, space, (num%86400)/3600, h, space, (num%3600)/60, m);
        }
    }
    return buf;
}

// 将一个数字按时间的进制法计算，保留两位，如果有秒则忽略秒
string StringUtil::convertIntToAboutTime(uint32_t num) {
    char buf[20] = {0};
//    LanguageConfigTable* language_table = LanguageConfigTable::instance();
//    const char* m = language_table->getLanguage(416);
//    const char* h = language_table->getLanguage(415);
//    const char* d = language_table->getLanguage(414);
    const char* m = "m";
    const char* h = "h";
    const char* d = "d";
    if (num<60) {
        // sprintf(buf, "");
    } else if(num<3600){
        sprintf(buf, "%d%s", num/60, m);
    } else if(num<86400){
        sprintf(buf, "%d%s %d%s", num/3600, h, (num%3600)/60, m);
    } else{
        sprintf(buf, "%d%s %d%s", num/86400, d, (num%86400)/3600, h);
    }
    return buf;
}

//int64_t StringUtil::convertIntToAboutInt(int64_t num, int top_num) {
//    int length_int = (int)itoa(num).length();
//    
//    if (length_int <= top_num) {
//        return num;
//    }
//    
//    return num / (10 ^ length_int) * (10 ^ length_int);
//}


/* 将一个整数型时间转换成距离现在的时间有多久了*/
string StringUtil::convertToHowLong(const char* format1,const char* format2,const char* format3,const char* format4,int64_t time)
{
    char buf[20] = {0};
    if (time < 60) {
        sprintf(buf,format1, time);
    } else if(time < 3600){
        sprintf(buf,format2, time / 60);
    } else if(time < 86400){
        sprintf(buf,format3, time / 3600);
    } else{
        sprintf(buf,format4, time / 86400);
    }
    return buf;
}

string StringUtil::convertToDate(int32_t time) {
    char str[30];
    struct tm *ptr;
    time_t lt = time;
    ptr = localtime(&lt);
    strftime(str, 100, "%Y.%m.%d", ptr);
    return string(str);
}



string StringUtil::convertIntScientific(int64_t num) {
    if (num == 0) {
        return "0";
    }
    
    int64_t n = abs(num);
    
    vector<int> num_data;
    while (n > 0) {
        num_data.push_back((int)(n % 1000));
        n /= 1000;
    }
    
    string ret = num < 0 ? "-" : "";
    for (int i = (int)num_data.size() - 1; i >= 0; i--) {
        string tmp;
        if (i == num_data.size() - 1) {
            tmp = StringUtils::format("%d", num_data[i]);
        } else {
            tmp = StringUtils::format(",%03d", num_data[i]);
        }
        ret.append(tmp);
    }
    
    return ret;
}

string StringUtil::convertIntKScientific(int64_t num)
{
    if (num == 0) {
        return "0";
    }

    int64_t n = abs(num);
    
    vector<int> num_data;
    while (n > 0) {
        num_data.push_back((int)(n % 1000));
        n /= 1000;
    }
    
    string ret = num < 0 ? "-" : "";
    for (int i = (int)num_data.size() - 1; i >= 0; i--) {
        string tmp;
        if (i == num_data.size() - 1) {
            tmp = StringUtils::format("%d", num_data[i]);
        } else if (i == 0) {
            tmp = "K";
        } else {
            tmp = StringUtils::format(",%03d", num_data[i]);
        }
        ret.append(tmp);
    }
    
    return ret;
}

string StringUtil::convertDoubleScientific(double num, bool need_fra)
{
    double integer = 0.00;      // 整数
    double fraction = 0.00;     // 小数
    
    fraction = modf(num, &integer);     // 分离整数和小数
    
    string ret;
    ret = convertIntScientific(integer);
    if(fraction < -0.000001 || fraction > 0.000001) {   // 不等于0
        string str_fra = StringUtils::format("%.2lf", fraction);
        
        string::size_type pos = str_fra.find(".");
        if (pos != string::npos) {
            ret.append(str_fra, pos, str_fra.length() - 1);
        }
    } else {    // 等于0
        if (need_fra) {
            ret.append(".00");
        }
    }
    
    return ret;
}

string StringUtil::convertScientific(int64_t num)
{
//     string num_str = StringUtils::format("%lld", num);
    
//     int32_t num_lenght = (int32_t)num_str.length();
    
    
//     if (num_lenght < 4) {
//         return num_str;
//     } else if (num_lenght < 16) {
//         string tmp_str = "";
//         int num = 0;
//         if (num_lenght < 7) {
//             num = num_lenght - 4;
//             tmp_str = num_str.substr(0, num_str.length() - 3);
//         } else if (num_lenght < 10) {
//             num = num_lenght - 7;
//             tmp_str = num_str.substr(0, num_str.length() - 6);
//         } else if (num_lenght < 13) {
//             num = num_lenght - 10;
//             tmp_str = num_str.substr(0, num_str.length() - 9);
//         } else if (num_lenght < 16) {
//             num = num_lenght - 13;
//             tmp_str = num_str.substr(0, num_str.length() - 12);
//         }
        
//         // 不要小数点
// //        if (num_str[num + 3] == '0') {
// //            if (num_str[num + 2] == '0') {
// //                if (num_str[num + 1] == '0') {
// //
// //                } else {
// //                    tmp_str += "." + StringUtil::itoa(num_str[num + 1] - '0');
// //                }
// //            } else {
// //                tmp_str += "." + StringUtil::itoa(num_str[num + 1] - '0') + StringUtil::itoa(num_str[num + 2] - '0');
// //            }
// //        } else {
// //            tmp_str += "." + StringUtil::itoa(num_str[num + 1] - '0') +
// //            StringUtil::itoa(num_str[num + 2] - '0') +
// //            StringUtil::itoa(num_str[num + 3] - '0');
// //        }
        
//         if (num_lenght < 7) {
//             tmp_str += "K";
//         } else if (num_lenght < 10) {
//             tmp_str += "M";
//         }  else if (num_lenght < 13) {
//             tmp_str += "B";
//         }  else if (num_lenght < 16) {
//             tmp_str += "T";
//         }
        
//         return tmp_str;
//     } else {
//         int32_t unit_lenght = 1 + log10(num_lenght) + 1;
//         char* sce_num = (char*)malloc(unit_lenght);
//         memset(sce_num, 0, unit_lenght);
//         sprintf(sce_num, "%d", num_lenght);
        
//         string tmp_num_str = num_str.substr(0, 1);
//         tmp_num_str = tmp_num_str + "." + num_str[1] + num_str[2] + num_str[3];
//         tmp_num_str = tmp_num_str + "E" + sce_num;
        
//         free(sce_num);
//         return tmp_num_str;
//     }
    
    return "";
    
    
//    if (num_lenght < 4) {
//        return num_str;
//    } else if (num_lenght < 16) {
//        string tmp_str = "";
//        int num = 0;
//        if (num_lenght < 7) {
//            num = num_lenght - 4;
//            tmp_str = num_str.substr(0, num_str.length() - 3);
//        } else if (num_lenght < 10) {
//            num = num_lenght - 7;
//            tmp_str = num_str.substr(0, num_str.length() - 6);
//        } else if (num_lenght < 13) {
//            num = num_lenght - 10;
//            tmp_str = num_str.substr(0, num_str.length() - 9);
//        } else if (num_lenght < 16) {
//            num = num_lenght - 13;
//            tmp_str = num_str.substr(0, num_str.length() - 12);
//        }
//
//        if (num_str[num + 3] == '0') {
//            if (num_str[num + 2] == '0') {
//                if (num_str[num + 1] == '0') {
//
//                } else {
//                    tmp_str += "." + StringUtil::itoa(num_str[num + 1] - '0');
//                }
//            } else {
//                tmp_str += "." + StringUtil::itoa(num_str[num + 1] - '0') + StringUtil::itoa(num_str[num + 2] - '0');
//            }
//        } else {
//            tmp_str += "." + StringUtil::itoa(num_str[num + 1] - '0') +
//            StringUtil::itoa(num_str[num + 2] - '0') +
//            StringUtil::itoa(num_str[num + 3] - '0');
//        }
//
//        if (num_lenght < 7) {
//            tmp_str += "K";
//        } else if (num_lenght < 10) {
//            tmp_str += "M";
//        }  else if (num_lenght < 13) {
//            tmp_str += "B";
//        }  else if (num_lenght < 16) {
//            tmp_str += "T";
//        }
//
//        return tmp_str;
//    } else {
//        int32_t unit_lenght = 1 + log10(num_lenght) + 1;
//        char* sce_num = (char*)malloc(unit_lenght);
//        memset(sce_num, 0, unit_lenght);
//        sprintf(sce_num, "%d", num_lenght);
//
//        string tmp_num_str = num_str.substr(0, 1);
//        tmp_num_str = tmp_num_str + "." + num_str[1] + num_str[2] + num_str[3];
//        tmp_num_str = tmp_num_str + "E" + sce_num;
//
//        free(sce_num);
//        return tmp_num_str;
//    }
}


string StringUtil::itoa(int64_t num)
{
    ostringstream o;
    o << num;
    return o.str();
}

string StringUtil::sign(map<string, string> content) {
//     vector<string> vec;
//     for (map<string, string>::iterator i = content.begin(); i != content.end(); i++)
//     {
//         vec.push_back(i->first);
//     }
//     sort(vec.begin(), vec.end());
    
//     string str_values;
    
//     for (int i = 0; i < vec.size(); i++) {
//         str_values += content[vec[i]];
//     }
// //    str_values += PLATFORM_KEY;
    // return MD5(str_values).toString();
    return "";
}

void StringUtil::splitStringIntoVector(vector<string>& vec, string token, string src) {
    int pos;
    src += token; // 扩展字符串以方便操作,截取最后一个子串
    int size = (int)src.size();
    
    for(int i= 0; i < size; i++) {
        pos = (int)src.find(token, i);
        if(pos < size) {
            string sub=src.substr(i,pos-i);
            vec.push_back(sub);
            i = pos + (int)token.size() - 1;
        }
    }
}

std::vector<std::string> StringUtil::splist(const std::string& s, const std::string& c) {
    std::vector<std::string> result;
    
    std::string::size_type pos1, pos2;
    pos2 = s.find(c);
    pos1 = 0;
    while(std::string::npos != pos2)
    {
        result.push_back(s.substr(pos1, pos2-pos1));
        
        pos1 = pos2 + c.size();
        pos2 = s.find(c, pos1);
    }
    
    if(pos1 != s.length())
        result.push_back(s.substr(pos1));
    
    return result;
}

string StringUtil::replaceAll(string str, const string &old_str, const string &new_str) {
    for (string::size_type pos(0); pos != string::npos ; pos += old_str.length()) {
        if ( (pos = str.find(old_str, pos)) != string::npos )
            str.replace(pos, old_str.length(), new_str);
        else break;
    }
    return str;
}


// ios限制输入需要
unsigned short StringUtil::getLatterSize(const char* src) {
    unsigned long c = src[0];
//    if (c < 0x80) return 1;
//    else if (c < 0x800)     return 2;
//    else if (c < 0x10000)   return 3;
//    else if (c < 0x200000)  return 4;
//    else if (c < 0x4000000) return 5;
//    else return 6;
    if (c<=127) return 1;
    else if ((c & 0xE0) == 0xC0) return 2;
    else if ((c & 0xF0) == 0xE0) return 3;
    else if ((c & 0xF8) == 0xF0) return 4;
    else return 0;//invalid utf8
}

unsigned int StringUtil::getStringLength(const string& src) {
    int length = 0;
    for (int i = 0 ; i < src.length() ; ) {
        int tmp_length = getLatterSize(&src[i]);
        i += MAX(1, tmp_length);
        if (tmp_length == 1) {
            length += 2;
        } else {
            length += tmp_length;
        }
    }
    return length;
}


unsigned int StringUtil::getStringLetterCount(const string& src) {
    int num = 0;
    for (int i = 0 ; i < src.length() ; ) {
        int tmp_length = getLatterSize(&src[i]);
        tmp_length = MAX(1, tmp_length);
        i += tmp_length;
        ++num;
    }
    return num;
}

string StringUtil::cutStringWithLength(const string& src, int length , int min_latter_size) {
    string str;
    int length_count = 0;
    for (int i = 0 ; i < src.length() ;) {
        int tmp_length = getLatterSize(&src[i]);
        tmp_length = MAX(1, tmp_length);
        if (length_count + tmp_length > length) {
            break;
        }
        length_count += MAX(min_latter_size, tmp_length);
        str.append( src.substr(i, tmp_length) );
        i += tmp_length;
    }
    return str;
}

string StringUtil::cutNameWithLength(const string& src, int length, float letter_size, float chinese_size) {
    string str;
    float length_count = 0;
    for (int i = 0 ; i < src.length(); ) {
        int tmp_length = getLatterSize(&src[i]);
        tmp_length = MAX(1, tmp_length);
        float tmp_size = tmp_length > 1 ? chinese_size : letter_size;
        if (length_count + tmp_size > length) {
            break;
        }
        
        length_count += tmp_size;
        str.append( src.substr(i, tmp_length) );
        i += tmp_length;
    }
    return str;
}


int64_t StringUtil::convertStringToInt64(const string& str) {
    int64_t result = 0;
    
    stringstream stream ;
    stream<<str;
    stream>>result;
    
    return result;
}

string StringUtil::getUnits(const char* format1, const char* format2, const char* format3, const char* format4, int64_t time)
{
    char buf[20] = {0};
    if (time < 60) {
        return format1;
    } else if(time < 3600){
        return format2;
    } else if(time < 86400){
        return format3;
    } else{
        return format4;
    }
    return buf;
}


string StringUtil::getFileMd5WithFilePath(const char *path) {

    return "";
}

string StringUtil::convertIntKBMScientific(int64_t num)
{
    short money_bit = 1;
    int64_t asc_value = 10;
    while (num / asc_value) {
        money_bit += 1;
        asc_value *= 10;
    }
    
    string format = "";
    string money = "";
    
    if (money_bit >= 1 && money_bit < 7) {
        if (money_bit <= 3) {
            money = StringUtils::format("%lld", num);
            format = "";
        } else if (money_bit <= 4) {
            money = convertIntScientific(num);
            format = "";
        } else {
            money = StringUtils::format("%lld", num / 1000);
            format = "K";
        }
    } else if (money_bit >= 7 && money_bit < 10) {
        double tmp = num / 1000000.0f;
        money = convertDoubleScientific(tmp, false);
        format = "M";
    } else {
        double tmp = num / 1000000000.0f;
        money = convertDoubleScientific(tmp, false);
        format = "B";
    }
    
    string pRet = StringUtils::format("%s%s", money.c_str(), format.c_str());
    return pRet;
}



#pragma mark -----------------

bool RegularUtil::match(const char* pattern, const char* str) {
    // 定义正则表达式规则和返回错误编码
    regex_t reg;
    int err_code = 0;

    // 将要进行匹配的正则表达式进行编译,做匹配前的准备工作
    if (0 != (err_code = regcomp(&reg, pattern, REG_EXTENDED | REG_NOSUB))){
        //string s = getRegError(err_code, &reg);
        CCLOG("regcomp: %d", err_code);
        return false;
    }

    // 用来检测字符串是否匹配正则表达式
    if (0 != (err_code = regexec(&reg, str, 0, NULL, 0))){
    //	string s = getRegError(err_code, &reg);
		CCLOG("regexec: %d", err_code);
		return false;
    }
    regfree(&reg);
    return true;
}

string RegularUtil::getRegError(int errorcode, regex_t *compiled) {
    // 获取错误编码信息数据长度
    size_t len = regerror(errorcode, compiled, NULL, 0);
    
    // 分配错误数据内存空间
    char *buf = (char*)malloc(len);
    
    // 获取错误编码数据信息
    if (buf){
        regerror(errorcode, compiled, buf, len);
    }
    string s = buf;
    free(buf);
    return s;
}

bool RegularUtil::isEmail(const char* str) {
	return match("^[a-zA-Z0-9\\-\\.]+@[a-zA-Z0-9\\-]+(\\.[a-zA-Z0-9\\-]+)+$", str);
	// return match("^[0-9a-zA-Z]+([\\.\\-_][0-9a-zA-Z]+)*@[0-9a-zA-Z\\-]+(\\.[0-9a-zA-Z\\-]+)*(\\.[a-zA-Z]{1,6})+$", str);
}



// 根据参数将一个图像制作成一个圆形 radius(半径) src_img(源数据)
//vector<char> ImageUtil::convertImgToCircle(int radius, Size origin_size, vector<char>& origin_data, Point dot)
//{
//    vector<char> result;
////    for (int i = 0; i < origin_data.size(); ++i) {
////        if (!((i + 1) % 3)) {
////            result.push_back(origin_data[i]);
////            result.push_back(0);
////        } else {
////            result.push_back(origin_data[i]);
////        }
////    }
////    return result;
////
////    if (!dot.equals(CCPointZero)) {  // 判断圆心是否正确
////        CCRect rect(0, 0, dot.x, dot.y);
////        if (!rect.containsPoint(dot) || radius > dot.x || radius > dot.y || radius + dot.x > origin_size.width || radius + dot.y > origin_size.height) {
////            CCLOG(">>>>>ImageUtil::convertImgToCircle Dot Error!!!");
////            return result;
////        }
////    } else {    // 未设置圆心默认中心点
////        dot = ccp(origin_size.width / 2, origin_size.height / 2);
////    }
////
////    CCPoint cur_pos = CCPointZero;
////    for (; cur_pos.x < origin_size.width; ++cur_pos.x) {   // 横向遍历
////        for (; cur_pos.y < origin_size.height; ++cur_pos.y) {  // 纵向遍历
////            if (cur_pos.getDistance(dot) > radius) {
////                int idx = (cur_pos.x + cur_pos.y) * 4;
////                result[idx] = 0;
////            }
////        }
////    }
////
//    return result;
//}
