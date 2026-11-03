//
//  ShaderFactory.h
//  ClickerHeroes
//
//  Created by windy on 06-01-2015.
//
//

#ifndef __ClickerHeroes__ShaderFactory__
#define __ClickerHeroes__ShaderFactory__

#include "cocos2d.h"
#include "cocos-ext.h"
#include "../Common/SingleInstance.h"

using namespace std;
USING_NS_CC;
USING_NS_CC_EXT;

#define SHADER_INL(__SHADER__) #__SHADER__

enum ShaderType {
    ST_POSITION_TEXTURE_DEFAULT = 0,
    ST_POSITION_TEXTURE_DEFAULT_HIGHP = 1,
    ST_POSITION_TEXTURE_GRAY = 2,
    ST_POSITION_TEXTURE_GRAY_UNIFORM = 3,
    ST_POSITION_TEXTURE_FROZEN = 4,         // 冰冻
    ST_POSITION_TEXTURE_STONE = 5,          // 石化
};

class ShaderFactory : public SingleInstance<ShaderFactory> {
public:
//    static ShaderFactory* instance() {}
    
    void setAllChildren(Node* node, const ShaderType& shader_type);
    
    void registerGLProgram();
    GLProgram* getGLProgram(ShaderType shader_type);
    void loadDefaultGLProgram(GLProgram* p, ShaderType shader_type);
    
    GLProgram* addGLProgram(int32_t shader_type, string vsf, string frag, bool clear);
protected:
    map<int32_t, GLProgram*> map_program;
};

#endif
