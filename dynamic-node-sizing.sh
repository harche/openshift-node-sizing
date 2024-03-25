#!/bin/bash
set -e
function dynamic_memory_sizing {
    #total_memory=$(free -g|awk '/^Mem:/{print $2}')
    total_memory=$1
    recommended_systemreserved_memory=0
    if (($total_memory <= 4)); then # 25% of the first 4GB of memory
        recommended_systemreserved_memory=$(echo $total_memory 0.25 | awk '{print $1 * $2}')
        total_memory=0
    else
        recommended_systemreserved_memory=1
        total_memory=$((total_memory-4))
    fi
    if (($total_memory <= 4)); then # 20% of the next 4GB of memory (up to 8GB)
        recommended_systemreserved_memory=$(echo $recommended_systemreserved_memory $(echo $total_memory 0.20 | awk '{print $1 * $2}') | awk '{print $1 + $2}')
        total_memory=0
    else
        recommended_systemreserved_memory=$(echo $recommended_systemreserved_memory 0.80 | awk '{print $1 + $2}')
        total_memory=$((total_memory-4))
    fi
    if (($total_memory <= 8)); then # 10% of the next 8GB of memory (up to 16GB)
        recommended_systemreserved_memory=$(echo $recommended_systemreserved_memory $(echo $total_memory 0.10 | awk '{print $1 * $2}') | awk '{print $1 + $2}')
        total_memory=0
    else
        recommended_systemreserved_memory=$(echo $recommended_systemreserved_memory 0.80 | awk '{print $1 + $2}')
        total_memory=$((total_memory-8))
    fi
    if (($total_memory <= 112)); then # 6% of the next 112GB of memory (up to 128GB)
        recommended_systemreserved_memory=$(echo $recommended_systemreserved_memory $(echo $total_memory 0.06 | awk '{print $1 * $2}') | awk '{print $1 + $2}')
        total_memory=0
    else
        recommended_systemreserved_memory=$(echo $recommended_systemreserved_memory 6.72 | awk '{print $1 + $2}')
        total_memory=$((total_memory-112))
    fi
    if (($total_memory >= 0)); then # 2% of any memory above 128GB
        recommended_systemreserved_memory=$(echo $recommended_systemreserved_memory $(echo $total_memory 0.02 | awk '{print $1 * $2}') | awk '{print $1 + $2}')
    fi
    echo "SYSTEM_RESERVED_MEMORY=${recommended_systemreserved_memory}Gi"
}


function dynamic_cpu_sizing {
    # total_cpu=$(getconf _NPROCESSORS_ONLN)
    total_cpu=$1
    # Base allocation for 1 CPU in fractions of a core (60 millicores = 0.06 CPU core)
    base_allocation_fraction=0.06
    # Increment per additional CPU in fractions of a core (12 millicores = 0.012 CPU core)
    increment_per_cpu_fraction=0.012

    if ((total_cpu > 1)); then
        # Calculate the total system-reserved CPU in fractions, starting with the base allocation
        # and adding the incremental fraction for each additional CPU
        recommended_systemreserved_cpu=$(awk -v base="$base_allocation_fraction" -v increment="$increment_per_cpu_fraction" -v cpus="$total_cpu" 'BEGIN {printf "%.2f\n", base + increment * (cpus - 1)}')
    else
        # For a single CPU, use the base allocation
        recommended_systemreserved_cpu=$base_allocation_fraction
    fi

    echo "SYSTEM_RESERVED_CPU=${recommended_systemreserved_cpu}"
}

function dynamic_node_sizing {
   for ((a=1; a<=1024; a*=2)); do
    output=$(dynamic_memory_sizing $a)
    echo "Memory in Gibi $a, $output"
   done


   for ((a=1; a<=512; a*=2)); do
    output=$(dynamic_cpu_sizing $a)
    echo "CPU Count $a, $output"
   done
}

if [ $1 == "true" ]; then
    dynamic_node_sizing
else
    echo "Unrecongnized command line option. Valid options are \"true\" or \"false\""
fi
