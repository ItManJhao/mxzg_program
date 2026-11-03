//
//  CSVFile.h
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __AVT__CSVFile__
#define __AVT__CSVFile__

#include <fstream>
#include <string>
#include <sstream>
#include <vector>
#include "../Model/Utils.h"

class CSVFile {
public:
    bool    Open(bool bIsRead, const char* strFilename);
    bool OpenLocal(bool bIsRead, const char* file_path);
    
    // 读接口
    bool    CSVReadNextRow();
    
    template<class T>
    bool CSVRead(const char* strFieldName, T& data) {
        if (m_nFileState != FILE_STATE_READ) {
            return false;
        }
        
        int n   = FindField(strFieldName);
        if (n == -1 || n >= m_CSVCurRow.size()) {
            return false;
        }
        
        std::stringstream ss;
        ss << m_CSVCurRow[n];
        ss >> data;
        
        return true;
    }
    
    bool CSVReadString(const char* strFieldName, std::string& data) {
        if (m_nFileState != FILE_STATE_READ) {
            return false;
        }
        
        int n   = FindField(strFieldName);
        if (n == -1 || n >= m_CSVCurRow.size()) {
            return false;
        }
        
        std::stringstream ss;
        // ss.unsetf(std::ios::skipws);
        ss << m_CSVCurRow[n];
        data = StringUtil::trim(ss.str());
        
        return true;
    }
    
    // 写接口
    void CSVWriteNextRow();
    
    template<class T>
    bool CSVWrite(const char* strFieldName, T data) {
        if (m_nFileState != FILE_STATE_WRITE) {
            return false;
        }
        
        int n   = FindField(strFieldName);
        if (n == -1) {
            return false;
        }
        
        std::stringstream ss;
        ss << data;
        m_CSVCurRow[n]  = ss.str();
        
        return true;
    }
    
private:
    typedef std::vector<std::string> ROWVEC;
    
    void    ReadCSVHead();
    void    RowParse(const char* strRow, int nSize, ROWVEC& result);
    int     FindField(const char* strRow);
    
private:
    enum {
        FILE_STATE_NULL,
        FILE_STATE_READ,
        FILE_STATE_WRITE,
    };
    int         m_nFileState;
    std::fstream    m_CSVFile;
    ROWVEC  m_CSVHead;
    ROWVEC  m_CSVCurRow;  
};

#endif /* defined(__AVT__CSVFile__) */
