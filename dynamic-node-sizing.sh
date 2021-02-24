#!/usr/bin/bash
set -e


function dynamic_node_sizing {
    total_memory=$(free -g|awk '/^Mem:/{print $2}')
    memory_lower_bound=0
    >node_sizes.env
    while read -r line; do
        recommended_systemreserved_memory=`echo $line | cut -d ' ' -f 2`
        memory_upper_bound=`echo $line | cut -d ' ' -f 1`

        if (($total_memory >= $memory_lower_bound && $total_memory <= $memory_upper_bound)); then
            echo "SYSTEM_RESERVED_MEMORY=${recommended_systemreserved_memory}g">> node_sizes.env
            break
        fi

        memory_lower_bound=${memory_upper_bound}
    done < memory-recommender.txt
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