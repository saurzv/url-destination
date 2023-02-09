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
        echo -e "\n\tURL\t\t: $@"
        echo -e "\tERROR\t\t: URL is not valid!\n"
        return 1
    fi
}

getDestination(){
    curl_rsp="$(curl -ILso /dev/null -w "%{http_code} %{url_effective}" "$@")"
    rsp_code="$(echo $curl_rsp | awk '{print $1}')"
    url_dest="$(echo $curl_rsp | awk '{print $2}')"

    echo -e "\n\tURL\t\t: "$@""

    if [[ "$rsp_code" == 200 ]]; then
        echo -e "\tURL Destination\t: $url_dest\n"
    else
        echo -e "\tERROR\t\t: URL might be broken :(\n\tStatus Code\t: $rsp_code\n"
    fi
}

if [[ "$#" == 0 ]]; then
    echo -e "\n
    ERROR: URL is missing\n
    USAGE: "$0" URL
    \n"
else
    if ! isActiveInternet && checkForCurl; then
        exit 1
    fi

    for link in "$@"
    do
        isValidURL $link && getDestination "$link"
    done
fi
