#!/usr/bin/bash
set -e

NODE_SIZES_ENV="node_sizes.env"
MEMORY_RECOMMENDER="memory-recommender.txt"
CPU_RECOMMENDER="cpu-recommender.txt"

function dynamic_memory_sizing {
    total_memory=$(free -g|awk '/^Mem:/{print $2}')
    memory_lower_bound=0

    while read -r line; do
        recommended_systemreserved_memory=`echo $line | cut -d ' ' -f 2`
        memory_upper_bound=`echo $line | cut -d ' ' -f 1`

        if (($total_memory >= $memory_lower_bound && $total_memory <= $memory_upper_bound)); then
            echo "SYSTEM_RESERVED_MEMORY=${recommended_systemreserved_memory}g">> ${NODE_SIZES_ENV}
            break
        fi

        memory_lower_bound=${memory_upper_bound}
    done < ${MEMORY_RECOMMENDER}
}

function dynamic_cpu_sizing {
    total_cpu=$(getconf _NPROCESSORS_ONLN)
    cpu_lower_bound=0

    while read -r line; do
        recommended_systemreserved_cpu=`echo $line | cut -d ' ' -f 2`
        cpu_upper_bound=`echo $line | cut -d ' ' -f 1`

        if (($total_cpu >= $cpu_lower_bound && $total_cpu <= $cpu_upper_bound)); then
            echo "SYSTEM_RESERVED_CPU=${recommended_systemreserved_cpu}g">> ${NODE_SIZES_ENV}
            break
        fi

        cpu_lower_bound=${cpu_upper_bound}
    done < ${CPU_RECOMMENDER}
}

function dynamic_ephemeral_sizing {
    echo "Not implemented yet"
}

function dynamic_pid_sizing {
    echo "Not implemented yet"
}

function dynamic_node_sizing {
    >node_sizes.env

    dynamic_memory_sizing
    dynamic_cpu_sizing
    dynamic_ephemeral_sizing
    dynamic_pid_sizing
}

function static_node_sizing {
    echo "Hello static"
}

if [ $1 == "true" ]; then
    dynamic_node_sizing
elif [ $1 == "false" ]; then
    static_node_sizing
else
    echo "Unrecongnized command line option. Valid options are \"true\" or \"false\""
fi