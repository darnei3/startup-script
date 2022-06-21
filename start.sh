#!/bin/bash
# Здесь можно заменить на свою программу выполнения, другие коды менять не нужно
APP_NAME=demo-0.0.1.jar
APP_DOWNLOAD_URL=http://192.168.178.38:8081/repository/demo-repository/com/example/demo/0.0.1/demo-0.0.1.jar
APP_FOLDER=/home/dev/demo/demo-0.0.1.jar
APP_DIRECTORY=/home/dev/demo/
BACKUP_DIR=/home/dev/demo/backup/
CURRENT_DATE=$(date +%Y-%m-%d-%H-%M)

update() {
  stop
  echo "${APP_NAME} is not working"
  if test -f "$APP_FOLDER"; then
    backup
  fi
  download
  if test -f "$APP_FOLDER"; then
    echo "Last version $APP_NAME was downloaded"
    echo -n "${APP_NAME} last change time: "
    stat -c '%y' ${APP_FOLDER}
    echo "UPDATE WAS SUCCESSFUL"
  fi
  start
}

backup(){
  mkdir -p ${BACKUP_DIR}/${CURRENT_DATE}/
  mv ${APP_FOLDER} ${BACKUP_DIR}/${CURRENT_DATE}/${APP_NAME}
	echo "Current version $APP_NAME was moved to $BACKUP_DIR$CURRENT_DATE"
}

download(){
  if test -f "$APP_FOLDER"; then
    echo "$APP_NAME already downloaded"
  else
    wget -q  ${APP_DOWNLOAD_URL} -O ${APP_FOLDER}
    echo "Last version $APP_NAME was downloaded"
  fi
}

 # Использовать инструкции, используемые для запроса входных параметров
usage() {
 echo "Использование: sh сценарий start.sh [start | stop | restart | status | download | update | backup]"
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
"download")
download
;;
"backup")
backup
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
