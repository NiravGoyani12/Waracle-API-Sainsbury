#!/usr/bin/env bash

collection=fpp-api-automation-tests.postman_collection.json
env=FPP_QA_MAIN.postman_environment.json
newman=./newman

# remove existing 'newman' reports directory
if [ -d "$newman" ]; then rm -rf "$newman"; fi

# extract collection request names into an array of postman requests
tests=($(jq -r '.item[].item[].item[].name' $collection | tr -d '[]," '))
echo "Number of test files:- ${#tests[@]}"
number_of_test_files_run=0

function run {
    newman run ${collection} \
    --folder $1 \
    -e $env \
    -d $2 \
    -r cli,json
}

# run tests (that come with/out data files)
for (( i=0; i<${#tests[@]}; i++ ))
do
    if [ -f "${tests[$i]}-data.json" ]
    then
        run "${tests[$i]}" "${tests[$i]}-data.json"
    elif [ -f "${tests[$i]}-data.csv" ]
    then
        run "${tests[$i]}" "${tests[$i]}-data.csv"
    else
        newman run $collection \
        --folder "${tests[$i]}" \
        -e $env \
        -r cli,json
    fi

    ((number_of_test_files_run++))
done

echo "Total number of test files run:- ${number_of_test_files_run}"

# Generate report.html
sh utils/generate-report.sh
