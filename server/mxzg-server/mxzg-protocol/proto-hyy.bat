::此文件需要GBK编码
::WarProtobuf的项目路径
set project=F:\git_workspace\mxzg-protofiles
::WarServer的项目路径
set server=F:\git_workspace\mxzg-server\mxzg-protocol

F:
cd %server%
::protoc工具是不会进行子目录递归的，需要逐个给出
::以protofiles目录为基础创建java文件，输出在本工程的目录下
protoc.exe --proto_path=%project%/protofiles --java_out=./src/main/java/ %project%/protofiles/*.proto

::以protofiles/game目录为基础创建java文件，输出在本工程的目录下
protoc.exe --proto_path=%project%/protofiles/game --java_out=./src/main/java/ %project%/protofiles/game/*.proto

::以protofiles/cross目录为基础创建java文件，输出在本工程的目录下
protoc.exe --proto_path=%project%/protofiles/cross --java_out=./src/main/java/ %project%/protofiles/cross/*.proto


echo. & pause