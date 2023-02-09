#! /bin/bash

checkForCurl(){
    if command -v curl >> /dev/null; then
        return 0
    else
        echo "ERROR: curl is required!"
        return 1
    fi
}

isValidURL(){
    regex='^(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]$'
    if [[ "$@" =~ $regex ]]; then
        return 0
    else
        echo "URL is not valid!"
        return 1
    fi
}

getDestination(){
    curl -ILso /dev/null -w "\n\tDestination URL : %{url_effective}\n\n" "$@"
}

if [[ "$#" == 0 ]]; then
    echo -e "\n
    ERROR: URL is missing\n
    USAGE: "$0" URL
    \n"
elif [[ "$#" > 1 ]]; then
    echo -e "\n
    ERROR: Only one url is allowed
    \n"
else
    if checkForCurl && isValidURL "$1"; then
        getDestination "$1"
    else
        exit 1
    fi
fi
