#!/bin/bash

# Author: Johnson Li <johnson.li@intel.com>
# Change Log:
# 	10-28-2015: Initial version
#
# This script helps to setup the NSH test environment.
# Since the NSH patches are not merged into OVS's mainline,
# users cannot test the feature easily.
# In order to get OVS installed for tests, this script helps
# to get patch files from the mail archivements and apply
# the patches to a special commit of OVS.
#
# This script is for free use, feel free to modify the script
# for your own use. Any questions about the installation script,
# please send an email to the author.


######################## Global Variables #####################
DPDK_VER=2.1.0

WORK_DIR=`pwd`
OVS_COMMIT=121daded51b9798fe3722824b27a05c16806cbd1
RTE_TARGET=x86_64-native-linuxapp-gcc
PATCHES="060679 060680 060681 060682 060683 060684 060685"


URL_OVS=https://github.com/openvswitch/ovs.git
URL_DPDK=http://dpdk.org/browse/dpdk/snapshot/dpdk-${DPDK_VER}.tar.gz


######################## Functions  ############################



################################################################
# Function Name: download_file_from_web()
# Desription: Download files from website. 3 tries and 5 seconds
#             interval between tries. Proxy may be required for
#             some development environments.
################################################################
function download_file_from_web()
{
	wget -t 3 -w 5 ${1} 2>&1 | tee -a ${WORK_DIR}/install.log
	return $?	
}

################################################################
# Function Name: download_and_build_dpdk()
# Desription: Download DPDK from dpdk.org and build the source
#             for specific target. For the Openvswitch netdev,
#             LIBRTE_VHOST is required and the DPDK should be
#             be built into one combined library.
################################################################
function download_and_build_dpdk()
{
	echo "Getting DPDK source from DPDK.org" 2>&1 | tee -a ${WORK_DIR}/install.log
	download_file_from_web ${URL_DPDK}

	if [ "$?" == "0" ] ;then
		tar -xzvf dpdk-${DPDK_VER}.tar.gz 2>&1 | tee -a ${WORK_DIR}/install.log
		cd dpdk-${DPDK_VER}
		sed -i -e 's/CONFIG_RTE_LIBRTE_VHOST=n/CONFIG_RTE_LIBRTE_VHOST=y/' \
		       -e 's/CONFIG_RTE_BUILD_COMBINE_LIBS=n/CONFIG_RTE_BUILD_COMBINE_LIBS=y/' \
		       -e 's/CONFIG_RTE_PKTMBUF_HEADROOM=128/CONFIG_RTE_PKTMBUF_HEADROOM=256/' \
		       config/common_linuxapp
		cd ${WORK_DIR}
		tar -czvf dpdk-${DPDK_VER}.tar.gz dpdk-${DPDK_VER} 2>&1 | tee -a ${WORK_DIR}/install.log
		cd dpdk-${DPDK_VER}
		echo "Install DPDK with target ${RTE_TARGET}..." | tee -a ${WORK_DIR}/install.log
		make install T=${RTE_TARGET} 2>&1 | tee -a ${WORK_DIR}/install.log
                cd ${WORK_DIR}
		return 0

	fi

	cd ${WORK_DIR}
	return $? 
}


################################################################
# Function Name: get_ovs_codes_from_github()
# Desription: Clone sources for OVS from github.
################################################################
function get_ovs_codes_from_github()
{
	git clone ${URL_OVS} openvswitch 2>&1 | tee -a ${WORK_DIR}/install.log
	return $?	
}

################################################################
# Function Name: apply_patches_to_ovs()
# Desription: Apply patches to a specific commit of OVS.
################################################################
function apply_patches_to_ovs()
{
	if [ ! -d openvswitch ] ;then
		echo "No source found for Openvswitch, exit!"  | tee -a ${WORK_DIR}/install.log
		return -1
	fi

	if [ ! -d patches ] ;then
		echo "No source found for Openvswitch, exit!" | tee -a ${WORK_DIR}/install.log
		return -1
	fi

	cd openvswitch
	git checkout ${OVS_COMMIT} -b development 2>&1 | tee -a ${WORK_DIR}/install.log
	for patch in ${PATCHES}
	do
		patch -p1 < ${WORK_DIR}/patches/${patch}.patch 2>&1 | tee -a ${WORK_DIR}/install.log
	done

	cd ${WORK_DIR}
	return 0
}

################################################################
# Function Name: build_ovs_from_source()
# Desription: 1. Build OVS from source codes
#             2. Install the binaries into system
#             3. Create OVSDB from schema
################################################################
function build_ovs_from_source()
{
	if [ "${DPDK_BUILD}" == "" -o ! -e ${DPDK_BUILD} ] ;then
		echo "DPDK_BUILD environmental variable is not set, exit" | tee -a ${WORK_DIR}/install.log
		return 1
	fi

	if [ ! -d openvswitch-dpdk ] ;then
		echo "No source found for Openvswitch, exit!" | tee -a ${WORK_DIR}/install.log
		return -1
	fi

	cd openvswitch-dpdk
	./boot.sh 2>&1 | tee -a ${WORK_DIR}/install.log 
	./configure --with-dpdk=$DPDK_BUILD 2>&1 | tee -a ${WORK_DIR}/install.log

	cd ${WORK_DIR}
	return ${ret}
}
###################        MAIN        ############################


download_and_build_dpdk
if [ $? -ne 0 ] ;then
	echo "Error occured when installing DPDK, exit." | tee -a ${WORK_DIR}/install.log
	exit 1
fi

get_ovs_codes_from_github
if [ $? -ne 0 ] ;then
	echo "Error occured when cloning OVS, exit." | tee -a ${WORK_DIR}/install.log
	exit 1
fi

apply_patches_to_ovs
if [ $? -ne 0 ] ;then
	echo "Error occured when applying patches, exit." | tee -a ${WORK_DIR}/install.log
	exit 1
fi

cp -r openvswitch openvswitch-dpdk
export RTE_SDK=${WORK_DIR}/dpdk-${DPDK_VER}
export DPDK_BUILD=${RTE_SDK}/${RTE_TARGET}
build_ovs_from_source
if [ $? -ne 0 ] ;then
	echo "Error occured when installing OVS, exit." | tee -a ${WORK_DIR}/install.log
	exit 1
fi

exit 0



