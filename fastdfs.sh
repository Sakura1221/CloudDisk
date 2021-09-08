#!/bin/bash

# 已经在运行就重启
tracker_start()
{
    ps aux | grep fdfs_trackerd | grep -v grep > /dev/null
    if [ $? -eq 0 ];then
        sudo fdfs_trackerd  /home/zzc/CloudDisk/conf/tracker.conf restart
    else
        sudo fdfs_trackerd  /home/zzc/CloudDisk/conf/tracker.conf start
    fi

    if [ $? -eq 0 ];then
        echo "tracker start success ..."
    else
        echo "tracker start failed ..."
    fi
}

storage_start()
{
    ps aux | grep fdfs_storaged | grep -v grep > /dev/null
    if [ $? -eq 0 ];then
        sudo fdfs_storaged  /home/zzc/CloudDisk/conf/storage.conf restart
    else
        sudo fdfs_storaged  /home/zzc/CloudDisk/conf/storage.conf start
    fi

    if [ $? -eq 0 ];then
        echo "storage start success ..."
    else
        echo "storage start failed ..."
    fi
}

if [ $# -eq 0 ];then
    echo "Operation:"
    echo "  start storage please input argument: storage"
    echo "  start tracker please input argument: tracker"
    echo "  start storage && tracker please input argument: all"
    echo "  stop storage && tracker input argument: stop"
    exit 0
fi


case $1 in
    storage)
        storage_start
        ;;
    tracker)
        tracker_start
        ;;
    all)
        storage_start
        tracker_start
        ;;
    stop)
        sudo fdfs_trackerd /home/zzc/CloudDisk/conf/tracker.conf stop
        sudo fdfs_storaged /home/zzc/CloudDisk/conf/storage.conf stop
        ;;
    *)
        echo "nothing ......"
esac
