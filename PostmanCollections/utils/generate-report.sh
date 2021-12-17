#!/usr/bin/env bash

# Create a directory to copy newman logs of failed tests
failed_tests_logs=$PWD/logs/failed
if [ -f report.html ]; then rm report.html; fi
if [ -d $failed_tests_logs ]; then rm -rf $failed_tests_logs; fi
mkdir -p $failed_tests_logs

cat >> ./report.html << EOF
<!doctype html>
<html lang="en">
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
        
        <!-- Custom CSS -->
        <link rel="stylesheet" href="utils/style.css">

        <title>Newman Summary Report</title>
    </head>
    <body>
        <div class="container"> <!-- # container -->
            <div class="row"> <!-- # Title div --> 
                <div class="col-md-12 col-lg-12">
                    <h2 class="display-4 mx-auto text-center lg-auto p-1">Newman Run Dashboard</h2>
                </div>
            </div> <!-- # End Title div -->
            <div class="row"> <!-- # Date div -->
                <div class="col-md-12 col-lg-12">
                    <p class="text-right lead green mt-4 mb-4">Generated: $(date +"%A, %d-%m-%Y %T")</p>
                </div>
            </div> <!-- # End Date div -->
            <div class="row mb-10"> <!-- # Table div --> 
                <div class="col-md-12 col-lg-12">
                    <table class="table">
                        <thead>
                            <tr>
                            <th scope="col">#</th>
                            <th scope="col">Test</th>
                            <th scope="col">Iterations</th>
                            <th scope="col">Pending</th>
                            <th scope="col">Skipped</th>
                            <th scope="col">Failed</th>
                            <th scope="col">Ave response</th>
                            <th scope="col">Max response</th>
                            <th scope="col">Min response</th>
                            </tr>
                        </thead>
                        <tbody>
EOF

row_number=0
FILES="./newman/*"
for f in $FILES; do
    test_name=($(jq -r '.run.executions[].item.name' $f))
    iterations=($(jq -r '.run.stats.iterations.total' $f))
    pending=($(jq -r '.run.stats.iterations.pending' $f))
    skipped=($(jq -r '.run.stats.iterations.skipped' $f))
    failed=($(jq -r '.run.failures | length' $f))
    responseAverage=($(jq -r '.run.timings.responseAverage | tonumber' $f))
    responseMax=($(jq -r '.run.timings.responseMax | tonumber' $f))
    responseMin=($(jq -r '.run.timings.responseMin | tonumber' $f))

    # Copy newman logs of failed tests
    if [ "$failed" != 0 ] ; then
        cp $f $failed_tests_logs
        failed_color=red
    else
        failed_color=grey
    fi

    ((row_number++))

    if [ "$skipped" == "null" ]; then skipped=0; fi

cat >> ./report.html << EOF
                            <tr>
                                <th scope="row">${row_number}</th>
                                <td>${test_name}</td>
                                <td>${iterations}</td>
                                <td>${pending}</td>
                                <td>${skipped}</td>
                                <td class=${failed_color}>${failed}</td>
                                <td>${responseAverage}</td>
                                <td>${responseMax}</td>
                                <td>${responseMin}</td>
                            </tr>
EOF
done
    
cat >> ./report.html << EOF
                        </tbody>
                    </table>
                </div>
            </div> <!-- # End Table div --> 
            <div class="row mt-4">
                <div class="col-1">
                    <h5 class="red underline">#</h5>
                </div>
                <div class="col-4">
                    <h5 class="red underline">Failure</h5>
                </div>
                <div class="col-7">
                    <h5 class="red underline">Detail</h5>
                </div>
            </div>
EOF

no_Of_failure=0
FAILED_FILES="./logs/failed/*"
for f in $FAILED_FILES; do

for (( j=0; j<$(jq -r '.run.failures | length' $f); j++ )); do

    failed_error_type=$(jq -r ".run.failures[\"${j}\" | tonumber].error.name" $f)
    failed_request_name=$(jq -r ".run.failures[\"${j}\" | tonumber].source.name" $f)
    failed_test=$(jq -r ".run.failures[\"${j}\" | tonumber].error.test" $f)
    failed_request_method=$(jq -r ".run.failures[\"${j}\" | tonumber].source.request.method" $f)
    failed_test_message=$(jq ".run.failures[\"${j}\" | tonumber].error.message" $f)

    if [ "$failed_test" == "null" ]; then failed_test="This request returned no data"; fi

    ((no_Of_failure++))
    
cat >> ./report.html << EOF
            <div id="detail" class="row $isDisplayed">
                <div class="col-1">
                    <p>${no_Of_failure}.</p>
                </div>
                <div class="col-4">
                    <p>${failed_error_type}</p>
                </div>
                <div class="col-7"> <!-- # Details div --> 
                    <p>${failed_request_name}</p>
                    <p>${failed_test}</p>
                    <p>${failed_request_method}</p>
                    <p class="assertion italics">${failed_test_message}</p>
                </div> <!-- # End Details div --> 
            </div>
EOF
done
done

cat >> ./report.html << EOF
        </div>  <!-- # End of container -->
            <!-- jQuery first, then Popper.js, then Bootstrap JS -->
            <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
            <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
            
            <!-- custom Js -->
            <script src="utils/index.js" type="text/javascript"></script>
    </body>
</html>
EOF

