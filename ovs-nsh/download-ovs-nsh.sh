#!/bin/bash

# Author: Johnson Li <johnson.li@intel.com>
# Change Log:
#     10-28-2015: Initial version
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
WORK_DIR=`pwd`
PATCHES="060679 060680 060681 060682 060683 060684 060685"
URL_OVS=https://github.com/openvswitch/ovs.git
OVS_COMMIT=121daded51b9798fe3722824b27a05c16806cbd1

######################## Functions  ############################

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

###################        MAIN        ############################
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

exit 0
