#!/bin/sh
#
# Test HDF5 RADOS VOL using GitHub Action.
#
# This script assumes that Action installed all dependencies under /home/runner/install.
#
# Author: Hyokyung Lee (hyoklee@hdfgroup.org)
# Last Update: 2022-11-21

echo "Checking PWD"
echo $PWD

echo "Checking /home/runner/install/bin"
ls /home/runner/install/bin

export LD_LIBRARY_PATH=/home/runner/install/lib:/home/runner/install/lib64
echo "Checking LD_LIBRARY_PATH"
echo $LD_LIBRARY_PATH

export PATH=/home/runner/install/bin:$PATH
echo "Checking PATH"
echo $PATH

echo "Creating /usr/local/tmp to check root permission"
mkdir /usr/local/tmp

echo "Running sysctl"
/usr/sbin/sysctl kernel.yama.ptrace_scope=0

echo "Testing using ior"
export HDF5_VOL_CONNECTOR=rados
# export HDF5_PLUGIN_PATH=/home/runner/install/bin/
export HDF5_PLUGIN_PATH=/home/runner/install/lib/
export MOBJECT_CLUSTER_FILE=/home/runner/mobject.ssg
export HDF5_RADOS_POOL=test_pool

bake-mkpool -s 50M /dev/shm/mobject.dat
bedrock na+sm -c $PWD/config.json -v trace &
sleep 5
ior -g -a HDF5 -t 64k -b 128k -E -k



