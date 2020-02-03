#!/bin/zsh

# all arguments
dir="$HOME/romu/$2"
logs=$3
errors=$4
interval=$1
size=$5
username=$(whoami)
message="none";

# BONUS switching to genTickV2
file_version=$6
if [ $file_version = '2' ]
then
    file_version='V2';
else
    file_version='';
fi

# cleaning old instances
if [ $(pidof genTick) ] || [ $(pidof genTickV2) ]
then
    killall genTick
    killall genTickV2
fi

# checking users
# checking if logs exists
# checking if generation.sh is running
# get size of files
# set (not) exceed for each files
# writing final message
# interrup generation and child processes
# creating temporary status file
# create temporary sorted errors/info logs
# compressing the dir
# delete temporary files
# cleaning logs and errors files
# continue generation and child processes
if [ $username = "leprohoncedric" ] || [ $username = "flow2dot0-osx" ]
then
    echo "INFO: current user accepted."
     ./generation.sh $interval $2 $logs $errors $file_version &
    if [ ! -d "$dir" ];
    then
      echo "WARNING: Logs not found."
    elif [ $(ps -ef | grep generation | wc -l) != 2 ]
      then
            echo "WARNING: generation.sh is not running."
            exit 1
    else
        while true; do
            minimumsize=$size
            actualsize_logs=$(wc -c <"$dir/$logs")
            logs_exceed_status="not exceeded"
            actualsize_errors=$(wc -c <"$dir/$errors")
            errors_exceed_status="not exceeded"
            if [ $actualsize_logs -ge $minimumsize ] || [ $actualsize_errors -ge $minimumsize ]
            then
                kill -l STOP `pgrep genTick` # interrupt the process
                if [ $actualsize_logs -ge $minimumsize ]; then
                    logs_exceed_status="exceeded"
                elif [ $actualsize_errors -ge $minimumsize ]; then
                    errors_exceed_status="exceeded"
                fi
                wc -l $dir/$3 | awk '{ print $1 }' >> "status.log"
                wc -l $dir/$4| awk '{ print $1 }' >> "status.log"
                # sort logs here and filter "Bonjour" word
                sed 's/Bonjour//g' $dir/$logs | sort -n > $logs
                sort -n $dir/$errors >> $errors
                zip -r $(date '+%Y-%m-%d-%H-%M-%S').zip $logs $errors status.log
                rm -rf status.log $logs $errors
                echo "" > $dir/$logs && echo "" > $dir/$errors
                kill -l CONT `pgrep genTick` # relaunch the process
                sleep 2
            fi

            message="[ logs file : [ size : $actualsize_logs, limit : $logs_exceed_status ] ], [ errors file : [ size : $actualsize_errors, limit : $errors_exceed_status ] ]"
        done
    fi
fi

# displaying the final message
if [ ! $message = "none" ]
then
    echo $message
fi
