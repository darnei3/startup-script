#!/bin/bash
# Здесь можно заменить на свою программу выполнения, другие коды менять не нужно
APP_NAME=demo-0.0.1.jar
APP_DOWNLOAD_URL=http://192.168.1.7:8081/repository/demo-repository/com/example/demo/0.0.1/demo-0.0.1.jar
APP_FOLDER=/home/dev/demo/demo-0.0.1.jar
APP_DIRECTORY=/home/dev/demo/

update() {
  stop
  echo "${APP_NAME} is not working"
  if test -f "$APP_FOLDER"; then
	rm ${APP_FOLDER}
	echo "Current version $APP_NAME was deleted"
  fi
  wget -q  ${APP_DOWNLOAD_URL} -O ${APP_FOLDER} 
  if test -f "$APP_FOLDER"; then
        echo "Last version $APP_NAME was downloaded"
	echo -n "${APP_NAME} last change time: "
  	stat -c '%y' ${APP_FOLDER}
	echo "UPDATE WAS SUCESSFUL"
  fi
  start
}


 # Использовать инструкции, используемые для запроса входных параметров
usage() {
 echo "Использование: sh сценарий name.sh [начало | остановка | перезапуск | статус]"
exit 1
}

 # Проверить, запущена ли программа
is_exist(){
pid=`ps -ef|grep $APP_NAME|grep -v grep|awk '{print $2}' `
 # Если нет возврата 1, вернуть 0, если он существует
if [ -z "${pid}" ]; then
return 1
else
return 0
fi
}

 #Startup method
start(){
is_exist
if [ $? -eq "0" ]; then
echo "${APP_NAME} is already running. pid=${pid} ."
else
nohup java  -Xms512m -Xmx1024m -XX:NewRatio=2 -XX:SurvivorRatio=8 -XX:+PrintGCDetails -XX:+UseSerialGC -jar /home/dev/demo/$APP_NAME > log.txt &
echo "${APP_NAME} was started"
fi
}

 #Stop method
stop(){
is_exist
if [ $? -eq "0" ]; then
kill -9 $pid
else
echo "${APP_NAME} is not running"
fi
}

 #Output running status
status(){
is_exist
if [ $? -eq "0" ]; then
echo "${APP_NAME} is running. Pid is ${pid}"
else
echo "${APP_NAME} is NOT running."
fi
}

 #Начать сначала
restart(){
stop
start
}

 # В соответствии с входными параметрами выберите выполнение соответствующего метода, если не введено, выполните инструкции
case "$1" in
"start")
start
;;
"update")
update
;;
"stop")
stop
;;
"status")
status
;;
"restart")
restart
;;
*)
usage
;;
esac
