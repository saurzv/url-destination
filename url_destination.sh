#! /bin/bash

checkForCurl(){
    if command -v curl >> /dev/null; then
        return 0
    else
        echo "\n\tERROR: curl is required!\n"
        return 1
    fi
}

isActiveInternet(){
    curl -ILso /dev/null github.com  2>&1 || { echo "\n\tERROR: Active internet connection needed!\n >&2"; return 1; }
}

isValidURL(){
    regex='^(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]$'
    if [[ "$@" =~ $regex ]]; then
        return 0
    else
        echo -e "\n\tURL is not valid!\n"
        return 1
    fi
}

getDestination(){
    curl_rsp="$(curl -ILso /dev/null -w "%{http_code} %{url_effective}" "$@")"
    rsp_code="$(echo $curl_rsp | awk '{print $1}')"
    url_dest="$(echo $curl_rsp | awk '{print $2}')"

    if [[ "$rsp_code" == 200 ]]; then
        echo -e "\n\tURL Destination : $url_dest\n"
    else
        echo -e "\n\tERROR: URL might be broken :(\n\tStatus Code: $rsp_code\n"
    fi
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
    if ! isActiveInternet; then
        exit 1
    fi

    if checkForCurl && isValidURL "$1"; then
        getDestination "$1"
    else
        exit 1
    fi
fi
