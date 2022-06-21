#!/bin/bash
# Здесь можно заменить на свою программу выполнения, другие коды менять не нужно
#jarpath="/home/dev/demo/demo-0.0.1.jar"

name="demo-0.0.1.jar"
basedir="/home/dev/demo"
backupdir="/home/dev/demo/backup"
downloadurl="https://downloader.disk.yandex.ru/disk/b2445131bfba7cb5c251d1647e6b2ca6a3714a897f1ca5c84b8813a414bd75c9/62b214be/Mg2J5YGTNLNA2fIKEpCbggwXkCT-hsEw-2j4qV3B-KRoUfHvN0YQ7YLxDQRNxTO5InmHus5VT_TNgagO18GQEg%3D%3D?uid=0&filename=FNF%20RUS.rar&disposition=attachment&hash=IRHGpxbE%2Bf6iCfHsQaarT7c5xwMmJ6skTWNSFdJ7cUl2ctb6AMaP8q92l7dCXMgZq/J6bpmRyOJonT3VoXnDag%3D%3D&limit=0&content_type=application%2Fx-rar&owner_uid=845034015&fsize=140161374&hid=d2a522c135686f0c46f6d3fc98602204&media_type=compressed&tknv=v2"

#"http://192.168.178.38:8081/repository/demo-repository/com/example/demo/0.0.1/demo-0.0.1.jar"

currentdate=""$(date +%Y-%m-%d-%H-%M)



test(){
  wget -q ${downloadurl} /home/dw/
  echo "Я тут типо"
}



update() {
  stop
  backup
  rm ${basedir}/${name}
  download
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
  if test -f ${basedir}/${name}; then
    echo "$name already downloaded"
  else
    wget -q  ${downloadurl} -O ${basedir}/${name}
    echo "Last version $name was downloaded"
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
"test")
test
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
