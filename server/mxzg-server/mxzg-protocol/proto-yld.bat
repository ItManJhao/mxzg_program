::���ļ���ҪGBK����
::WarProtobuf����Ŀ·��
set project=D:/mxzg/git/mxzg-protofiles
::WarServer����Ŀ·��
set server=D:/mxzg/git/mxzg-server/mxzg-protocol

d:
cd %server%
::protoc�����ǲ��������Ŀ¼�ݹ�ģ���Ҫ�������
::��protofilesĿ¼Ϊ��������java�ļ�������ڱ����̵�Ŀ¼��
::protoc.exe --proto_path=protofiles --java_out=./src/main/java/ protofiles/*.proto

::��protofiles/gameĿ¼Ϊ��������java�ļ�������ڱ����̵�Ŀ¼��
::protoc.exe --proto_path=%project%/protofiles/game --java_out=./src/main/java/ %project%/protofiles/game/*.proto
protoc.exe --proto_path=%project%/protofiles/game --java_out=./src/main/java/ %project%/protofiles/game/*.proto

::��protofiles/crossĿ¼Ϊ��������java�ļ�������ڱ����̵�Ŀ¼��
:: protoc.exe --proto_path=protofiles/cross --java_out=./src/main/java/ protofiles/cross/*.proto


echo. & pause