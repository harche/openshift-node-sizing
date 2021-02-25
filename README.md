# Dynamic Node Sizing for OpenShift

This is a prototype of the dynamic node sizing for Openshift. Click [here](https://github.com/openshift/enhancements/pull/642) for more information about the proposed enhancement in Openshift.

This script will be executed as `ExecStartPre` by the systemd unit of the kubelet. The script will generate a file with recommended node sizing values for memory and cpu. e.g.

```bash
[harshal@localhost dynamic-node]$ ./dynamic-node-sizing.sh true
[harshal@localhost dynamic-node]$ cat node_sizes.env
SYSTEM_RESERVED_MEMORY=3.5Gi
SYSTEM_RESERVED_CPU=0.09
```

After this the kubelet's systemd will read the file `EnvironmentFile=/etc/kubernetes/node_sizes.env` and load the environment variables . These variables will be used to set kubelet command line argument `--system-reserved=cpu=${SYSTEM_RESERVED_CPU},memory=${SYSTEM_RESERVED_MEMORY}`

When the user doesn't want to use dynamic node sizing, the script can be invoked to generate existing static values.

```bash
[harshal@localhost dynamic-node]$ ./dynamic-node-sizing.sh false
[harshal@localhost dynamic-node]$ cat node_sizes.env
SYSTEM_RESERVED_MEMORY=1Gi
SYSTEM_RESERVED_CPU=500m
```