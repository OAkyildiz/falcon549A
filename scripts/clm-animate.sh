#!/bin/bash

#cleanup function
trap 'cleanup' 2
cleanup(){
  #kill kill kill
  kill $(ps aux | grep '$1' |grep '$2' | awk '{print $2}')
  rm $(ls | grep pipe | grep out)
}
#set paths
repo_root=$(find ~/Documents/ -name falcon549) 
pack_root=$(find ~/Documents/ -name CLM-framework) 
stream_path=$repo_root/stream
build_path=$pack_root/build

#declare pipes
cd $stream_path
points_pipe=head-points_pipe
poses_pipe=head-poses_pipe


#declare .out
points_out=$1.out
#declare .out
poses_out=$2.out
  
#add if for params
#recreate pipes
if [ -n "$(ls | grep pipe)" ]; then
  
  rm $(ls | grep pipe)
fi

mkfifo $points_pipe
mkfifo $poses_pipe

#clean
if [ -n "$(ls | grep out)" ]; then
  rm $(ls | grep out) 
fi


#pipe output files
if [ -n "$1" ]; then
  #redirect output
  ./$points_out>$points_pipe &
fi

if [ -n "$2" ]; then
  #redirect output
  ./$poses_out>$poses_pipe &
fi


# call clm
$build_path/bin/SimpleCLM -d 0 -of "$stream_path/$points_out" -op "$stream_path/$poses_out" 





