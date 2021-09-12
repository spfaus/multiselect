#!/bin/bash
# Inspired by: https://serverfault.com/a/298312

# customize with your own.
options=("AAA" "BBB" "CCC" "DDD")

menu() {
    echo "Avaliable options:"
    for i in ${!options[@]}; do 
        printf "%3d%s) %s\n" $((i+1)) "${choices[i]:- }" "${options[i]}"
    done
    if [[ "$msg" ]]; then echo "$msg"; fi
}

prompt="Enter one or more options (space-separated) to toggle. Press ENTER without input to continue with current selection: "
while menu && read -rp "$prompt" nums && [[ "$nums" ]]; do 
    while read num; do
        [[ "$num" != *[![:digit:]]* ]] &&
        (( num > 0 && num <= ${#options[@]} )) ||
        { msg="Invalid option: $num"; continue; }
        ((num--)); msg="${options[num]} was ${choices[num]:+un}checked"
        [[ "${choices[num]}" ]] && choices[num]="" || choices[num]="+"
    done < <(echo $nums |sed "s/ /\n/g")
done

printf "You selected"; msg=" nothing"
for i in ${!options[@]}; do 
    [[ "${choices[i]}" ]] && { printf " %s" "${options[i]}"; msg=""; }
done
echo "$msg"