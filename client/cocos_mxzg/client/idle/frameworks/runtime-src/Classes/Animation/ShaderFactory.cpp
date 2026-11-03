//
//  ShaderFactory.cpp
//  ClickerHeroes
//
//  Created by windy on 06-01-2015.
//
//

#include "ShaderFactory.h"
#include "../Person/Hero.h"

void ShaderFactory::registerGLProgram()
{
    getGLProgram(ST_POSITION_TEXTURE_DEFAULT);
    getGLProgram(ST_POSITION_TEXTURE_DEFAULT_HIGHP);
    getGLProgram(ST_POSITION_TEXTURE_GRAY);
    getGLProgram(ST_POSITION_TEXTURE_GRAY_UNIFORM);
    getGLProgram(ST_POSITION_TEXTURE_FROZEN);
    getGLProgram(ST_POSITION_TEXTURE_STONE);
}


void ShaderFactory::loadDefaultGLProgram(GLProgram* p, ShaderType shader_type) {
    switch (shader_type) {
        case ST_POSITION_TEXTURE_GRAY:
            p->initWithFilenames("shader/default.vsh", "shader/gray.frag");
            break;
        case ST_POSITION_TEXTURE_DEFAULT:
            p->initWithFilenames("shader/default.vsh", "shader/default.fsh");
            break;
        case ST_POSITION_TEXTURE_DEFAULT_HIGHP:
            p->initWithFilenames("shader/defaulthighp.vsh", "shader/defaulthighp.fsh");
            break;
        case ST_POSITION_TEXTURE_GRAY_UNIFORM:
            p->initWithFilenames("shader/default.vsh", "shader/grayuniform.fsh");
            break;
        case ST_POSITION_TEXTURE_FROZEN:
            p->initWithFilenames("shader/default.vsh", "shader/frozen.frag");
            break;
        case ST_POSITION_TEXTURE_STONE:
            p->initWithFilenames("shader/default.vsh", "shader/stone.frag");
            break;
        default:
            break;
    }
    
    p->bindAttribLocation(GLProgram::ATTRIBUTE_NAME_POSITION, GLProgram::VERTEX_ATTRIB_POSITION);
    p->bindAttribLocation(GLProgram::ATTRIBUTE_NAME_COLOR, GLProgram::VERTEX_ATTRIB_COLOR);
    p->bindAttribLocation(GLProgram::ATTRIBUTE_NAME_TEX_COORD, GLProgram::VERTEX_ATTRIB_TEX_COORD);
    
    p->link();
    p->updateUniforms();
}

GLProgram* ShaderFactory::getGLProgram(ShaderType shader_type) {    
    auto iter_program = map_program.find(shader_type);
    if ( iter_program == map_program.end() ) {
        auto p = new GLProgram();
        loadDefaultGLProgram(p, shader_type);
        map_program[shader_type] = p;
        return p;
    }
    return iter_program->second;
}

void ShaderFactory::setAllChildren(Node *node, const ShaderType& shader_type) {

    cocos2d::Vector<Node*>& children = node->getChildren();
    if (children.size() <= 0) {
        return;
    }

    auto p = getGLProgram(shader_type);

    Node* obj;
    for (int i = 0; i < children.size(); i++) {
        obj = dynamic_cast<Node*>(children.at(i));

        if (obj)
        {
            obj->setGLProgram(p);
            setAllChildren(obj, shader_type);
        }
    }
}


GLProgram* ShaderFactory::addGLProgram(int32_t shader_type, string vsf, string frag, bool clear)
{
    auto iter_program = map_program.find(shader_type);
    if (clear) {
        if ( iter_program != map_program.end() ) {
            iter_program->second->release();
            map_program.erase(iter_program);
        }
    }
    
    iter_program = map_program.find(shader_type);
    if ( iter_program == map_program.end() ) {
        auto p = new GLProgram();
        p->initWithFilenames(vsf, frag);
        p->bindAttribLocation(GLProgram::ATTRIBUTE_NAME_POSITION, GLProgram::VERTEX_ATTRIB_POSITION);
        p->bindAttribLocation(GLProgram::ATTRIBUTE_NAME_COLOR, GLProgram::VERTEX_ATTRIB_COLOR);
        p->bindAttribLocation(GLProgram::ATTRIBUTE_NAME_TEX_COORD, GLProgram::VERTEX_ATTRIB_TEX_COORD);
        
        p->link();
        p->updateUniforms();
        map_program[shader_type] = p;
        return p;
    }
    return iter_program->second;
}

