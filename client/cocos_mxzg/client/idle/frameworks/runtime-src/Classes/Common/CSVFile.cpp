//
//  CSVFile.cpp
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#include "CSVFile.h"
#include <sstream>
#include <assert.h>
#include "../Model/Utils.h"

void CSVFile::ReadCSVHead() {
    char strHeadLine[4096];
    m_CSVFile.getline(strHeadLine, sizeof(strHeadLine));
    
    RowParse(strHeadLine, sizeof(strHeadLine), m_CSVHead);
}

void CSVFile::RowParse(const char* strRow, int nSize, ROWVEC& result) {
    result.clear();
    
    bool    bIsInWord   = false;
    bool    bIsHaveSpace    = false;
    std::string strCurWorld;
    
    for (int i=0; i<nSize; i++) {
        char ch = strRow[i];
        if (ch == '\0') {
            if (i >= 1 && strRow[i-1] == ',') {
                strCurWorld = ' ';
            }
            
            break;
        }
        
        bool bIsAdd = true;
        
        switch (ch) {
            case ',':
            {
                if (!bIsInWord) {
                    // 一项结束
                    
                    result.push_back(strCurWorld);
                    
                    bIsInWord   = false;
                    bIsHaveSpace    = false;
                    strCurWorld = "";
                    
                    bIsAdd  = false;
                }
            }
                break;
            case '"':
            {
                if (!bIsInWord) {
                    bIsInWord   = true;
                    bIsHaveSpace    = true;
                    
                    bIsAdd  = false;
                } else {
                    if ('"' == strRow[i+1]) {
                        i++;
                    } else if (bIsHaveSpace) {
                        bIsInWord   = false;
                        
                        bIsAdd  = false;
                    } else {
                        assert(0);
                    }
                    
                }
            }
                break;
            default:
                //bIsInWord = true;
                break;
        };
        
        if (bIsAdd) {
            strCurWorld += ch;
        }
        
    }
    
    if (strCurWorld != "") {
        result.push_back(strCurWorld);
    }
    
}

int CSVFile::FindField(const char* strRow) {
    if (m_nFileState == FILE_STATE_NULL) {
        return -1;
    }
    
    for (ROWVEC::iterator it = m_CSVHead.begin();
         it != m_CSVHead.end(); it++) {
        string key = StringUtil::trim(*it);
        if (key == strRow) {
            return int(it - m_CSVHead.begin());
        }
    }
    
    return -1;
}

bool CSVFile::OpenLocal(bool bIsRead, const char* file_path) {
    string path = FileUtils::getInstance()->fullPathForFilename(file_path);
    if (path.compare(file_path) == 0) {
        return false;
    }
    
    m_nFileState    = FILE_STATE_NULL;
    //    std::string strFullFileName(strPath);
    //    strFullFileName += strFilename;
    
    //m_CSVFile.open(strFullFileName.c_str(), std::ios_base::in);
    
    string tmp_path = FileUtils::getInstance()->getWritablePath() + "tmp.cvs";
    m_CSVFile.open(tmp_path.c_str(), std::ios_base::out);
    if (!m_CSVFile.is_open()) {
        return false;
    }
    
    string tmp = FileUtils::getInstance()->getStringFromFile(file_path);
    int size  = (int)tmp.size();
    if (size <= 0) {
        return false;
    }
    
    char* data = (char*) malloc(size + 1);
    memcpy(data, tmp.c_str(), size);
    data[size] = 0;
    
    m_CSVFile << data;
    m_CSVFile.close();
    
    CC_SAFE_FREE(data);
    
    m_CSVFile.open(tmp_path.c_str(), std::ios_base::in);
    // m_CSVFile.open(path.c_str(), std::ios_base::in);
    if (!m_CSVFile.is_open()) {
        return false;
    }
    
    ReadCSVHead();
    
    if (bIsRead) {
        m_nFileState    = FILE_STATE_READ;
    } else {
        m_nFileState    = FILE_STATE_WRITE;
        m_CSVFile.close();
        //m_CSVFile.open(strFullFileName.c_str(), std::ios_base::out);
        m_CSVFile.open(path.c_str(), std::ios_base::out);
        if (!m_CSVFile.is_open()) {
            return false;
        }
        
        m_CSVCurRow = m_CSVHead;
        CSVWriteNextRow();
    }
    
    return true;
}

//bool    CSVFile::Open(bool bIsRead, const char* strPath, const char* strFilename)
bool CSVFile::Open(bool bIsRead, const char* strFilename) {
    string path = FileUtils::getInstance()->getWritablePath();
    path.append(strFilename);
    
    m_nFileState    = FILE_STATE_NULL;
//    std::string strFullFileName(strPath);
//    strFullFileName += strFilename;
    
    //m_CSVFile.open(strFullFileName.c_str(), std::ios_base::in);
    m_CSVFile.open(path.c_str(), std::ios_base::in);
    if (!m_CSVFile.is_open()) {
        return false;
    }
    
    ReadCSVHead();
    
    if (bIsRead) {
        m_nFileState    = FILE_STATE_READ;
    } else {
        m_nFileState    = FILE_STATE_WRITE;
        m_CSVFile.close();
        //m_CSVFile.open(strFullFileName.c_str(), std::ios_base::out);
        m_CSVFile.open(path.c_str(), std::ios_base::out);
        if (!m_CSVFile.is_open()) {
            return false;
        }
        
        m_CSVCurRow = m_CSVHead;
        CSVWriteNextRow();
    }
    
    return true;
}

// 读接口
bool CSVFile::CSVReadNextRow() {
    if (m_nFileState != FILE_STATE_READ) {
        return false;
    }
    
    char strHeadLine[4096];
    m_CSVFile.getline(strHeadLine, sizeof(strHeadLine));
    if (m_CSVFile.eof()) {
        return false;
    }
    
    RowParse(strHeadLine, sizeof(strHeadLine), m_CSVCurRow);
    
    return true;
}

int replace(std::string& src_str, const std::string& old_str, const std::string& new_str) {
    int count   = 0;
    int old_str_len = int(old_str.length());
    int new_str_len = int(new_str.length());
    int pos = 0;
    while((pos=int(src_str.find(old_str,pos))) != std::string::npos) {
        src_str.replace(pos,old_str_len,new_str);
        pos+=new_str_len;
        ++count;
    }
    return count;
}

// 写接口
void CSVFile::CSVWriteNextRow() {
    if (m_nFileState != FILE_STATE_WRITE) {
        return;
    }
    
    for (ROWVEC::iterator it = m_CSVCurRow.begin(); it != m_CSVCurRow.end(); it++) {
        std::string str = *it;
        *it = "";
        replace(str, "\"", "\"\"");
        
        m_CSVFile << '"' << str << '"';
        if (it + 1 != m_CSVCurRow.end()) {
            m_CSVFile << ',';
        }
    }
                
    m_CSVFile << std::endl;
}
