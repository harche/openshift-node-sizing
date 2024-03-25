# Dynamic Node Sizing for OpenShift

This is a prototype of the dynamic node sizing for Openshift. Click [here](https://github.com/openshift/enhancements/pull/642) for more information about the proposed enhancement in Openshift.

This script will be executed as `ExecStartPre` by the systemd unit of the kubelet. The script will generate the recommended node sizing values for system reserved memory and cpus.

Sample output for various values of memory and cpus,

```bash
$ ./dynamic-node-sizing.sh true
Memory in Gibi 1, SYSTEM_RESERVED_MEMORY=0.25Gi
Memory in Gibi 2, SYSTEM_RESERVED_MEMORY=0.5Gi
Memory in Gibi 4, SYSTEM_RESERVED_MEMORY=1Gi
Memory in Gibi 8, SYSTEM_RESERVED_MEMORY=1.8Gi
Memory in Gibi 16, SYSTEM_RESERVED_MEMORY=2.6Gi
Memory in Gibi 32, SYSTEM_RESERVED_MEMORY=3.56Gi
Memory in Gibi 64, SYSTEM_RESERVED_MEMORY=5.48Gi
Memory in Gibi 128, SYSTEM_RESERVED_MEMORY=9.32Gi
Memory in Gibi 256, SYSTEM_RESERVED_MEMORY=11.88Gi
Memory in Gibi 512, SYSTEM_RESERVED_MEMORY=17Gi
Memory in Gibi 1024, SYSTEM_RESERVED_MEMORY=27.24Gi
CPU Count 1, SYSTEM_RESERVED_CPU=0.06
CPU Count 2, SYSTEM_RESERVED_CPU=0.07
CPU Count 4, SYSTEM_RESERVED_CPU=0.10
CPU Count 8, SYSTEM_RESERVED_CPU=0.14
CPU Count 16, SYSTEM_RESERVED_CPU=0.24
CPU Count 32, SYSTEM_RESERVED_CPU=0.43
CPU Count 64, SYSTEM_RESERVED_CPU=0.82
CPU Count 128, SYSTEM_RESERVED_CPU=1.58
CPU Count 256, SYSTEM_RESERVED_CPU=3.12
CPU Count 512, SYSTEM_RESERVED_CPU=6.19
```