#!/bin/bash
# Здесь можно заменить на свою программу выполнения, другие коды менять не нужно
#jarpath="/home/dev/demo/demo-0.0.1.jar"

name="demo-0.0.1.jar"
basedir="/home/dev/demo"
backupdir="/home/dev/demo/backup"
downloadurl="http://192.168.178.38:8081/repository/demo-repository/com/example/demo/0.0.1/demo-0.0.1.jar"

currentdate=""$(date +%Y-%m-%d-%H-%M)



update() {
  download
  backup
  stop
  rm ${basedir}/${name}
  mv ${basedir}/temp/${name} ${basedir}/${name}
  echo "Last version ${name} was moved to ${basedir}"
  if test -f "${basedir}/${name}"; then
    echo -n "${name} last change time: "
    stat -c '%y' ${basedir}/${name}
    echo "UPDATE WAS SUCCESSFUL"
  fi
  start
}

backup(){
  if test -f ${basedir}/${name}; then
    mkdir -p ${backupdir}/${currentdate}/
    #mv ${basedir}/${name} ${backupdir}/${currentdate}/${name}
    cp ${basedir}/${name} ${backupdir}/${currentdate}/${name}
    echo "Current version ${name} was copied to ${backupdir}/${currentdate}"
  fi
}

download(){
  if [ -d "${basedir}/temp" ]; then
    echo "Directory ${basedir}/temp will used for download"
  else
    mkdir ${basedir}/temp
    echo "Directory ${basedir}/temp created and will used for download"
  fi
  if test -f ${basedir}/temp/${name}; then
    echo "$name already downloaded"
  else
    wget -q  ${downloadurl} -O ${basedir}/temp/${name}
    echo "Last version $name was downloaded to ${basedir}/temp"
  fi
}

 # Использовать инструкции, используемые для запроса входных параметров
usage() {
 echo "Использование: sh сценарий start.sh [start | stop | restart | status | download | update | backup]"
exit 1
}

 # Проверить, запущена ли программа
is_exist(){
  pid=`ps -ef|grep $name|grep -v grep|awk '{print $2}' `
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
    echo "${name} is already running. pid=${pid} ."
  else
    if ! [ -d ${basedir}/logs ]; then
      mkdir ${basedir}/logs
      echo "The directory for the logs was created by ${basedir}/logs"
    fi
    nohup java  -Xms512m -Xmx1024m -XX:NewRatio=2 -XX:SurvivorRatio=8 -XX:+PrintGCDetails -XX:+UseSerialGC -jar ${basedir}/${name} > ${basedir}/logs/log.txt &
    echo "${name} was started"
  fi
}

 #Stop method
stop(){
  is_exist
  if [ $? -eq "0" ]; then
    kill -9 $pid
    echo "${name} was stopped"
  else
    echo "${name} is not running"
  fi
}

 #Output running status
status(){
  is_exist
  if [ $? -eq "0" ]; then
    echo "${name} is running. Pid is ${pid}"
  else
    echo "${name} is NOT running."
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
