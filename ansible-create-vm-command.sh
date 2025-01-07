#!/bin/bash

HOSTNAME="ansible"
CPUS=2
MEM=4096
DISK=25
OS="almalinux9"
ISO="/iso/AlmaLinux-9.5-x86_64-dvd.iso"
KS_FILE="ansible-server-kickstart.cfg"
KS_PATH="/iso/"
NET='bridge=br0'

virt-install \
  --name=${HOSTNAME} \
  --vcpus=${CPUS} \
  --memory=${MEM} \
  --disk size=${DISK} \
  --network ${NET} \
  --os-variant=${OS} \
  --location=${ISO} \
  --initrd-inject=${KS_PATH}/${KS_FILE} \
  --extra-args="inst.ks=file:/${KS_FILE} console=ttyS0 noipv6" \
  --console pty,target_type=serial 
