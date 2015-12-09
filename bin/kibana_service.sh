#!/bin/bash
PATH=/sbin:/usr/sbin:/bin:/usr/bin
DESC="Kibana 4"
#KIBANA_HOME=/usr/local/kibana-4.1.2-linux-x64
NAME=kibana
DAEMON=$KIBANA_HOME/bin/$NAME
PIDFILE=$KIBANA_HOME/var/run/$NAME.pid
LOG=$KIBANA_HOME/kibana.log
 
pid_file_exists() {
    [ -f "$PIDFILE" ]
}
 
do_start()      {
        
        if pid_file_exists
        then
                        echo "Kibana is already running"
        else
                  
                        $DAEMON > /dev/null  2>&1 & echo $! > $PIDFILE
                        PID=$(cat $PIDFILE)
                        if pid_file_exists
                        then
                                echo "Kibana started with pid $PID !"
                        else
                                echo "Kibana could not be started"
                        fi    
        fi
                
        
}
 
 
do_status() {
        if pid_file_exists
        then    
                PID=$(cat $PIDFILE)
                STATUS=$(ps ax | grep $PID | grep -v grep | awk '{print $1}')
                
                if [ "$STATUS" == "$PID" ]
                then
                                echo "Kibana is running on proccess $PID"
                else
                                echo "Kibana is NOT running"
                                rm $PIDFILE
                fi
        else
                echo "Kibana is NOT running"
        fi
}
 
do_stop() {
        if pid_file_exists
        then    
                PID=$(cat $PIDFILE)
                STATUS=$(ps ax | grep $PID | grep -v grep | awk '{print $1}')
                
                if [ "$STATUS" == "$PID" ]
                then
                                echo "Killing Kibana...."
                                KILL=$(kill -15 $PID)
                                rm $PIDFILE
                                sleep 1
                                echo -e "\tKibana (PID:$PID) killed"
                                
                else
                                echo "Kibana is NOT running"
                                rm $PIDFILE
                fi
        else
                echo "Kibana is NOT running"
        fi
}
 
 
case "$1" in
  start)
        do_start;;
  stop)
        do_stop
        ;;
  status)
        do_status
        ;;
  restart)
        do_stop
        do_start
        ;;
  *)
        echo "Usage: kibana_service {start|stop|status|restart}" >&2
        exit 3
        ;;
esac
 
:
 
