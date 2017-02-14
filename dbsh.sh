#!/bin/bash
fileName="sh.db" 
optionK=false 

put () {
    if grep -q "^$key " $fileName; then
        sed -i "/^$key /c$key $value" $fileName
    else
        echo "$key $value" >> $fileName
    fi
}
del () {
	if [ "$value" != "" ]; then
	    if grep -q "^$key $value" $fileName; then
	        sed -i "/^$key /d" $fileName
		fi
    elif grep -q "^$key " $fileName; then
        sed -i "/^$key /c$key " $fileName
    fi
}
selects () {
	if [ "$key" != "" ]; then
    	if [ $optionK != true ]; then
    		grep $key $fileName |grep -o '\S\+$'
    	else
    		grep $key $fileName  | sed 's/ /=/g' 
    	fi
    else 
    	if [ $optionK != true ]; then
		    grep -o '\S\+$' $fileName
    	else
		    grep  '\S\+$' $fileName | sed 's/ /=/g'
    	fi
    fi
}
while [ "$1" != "" ]; 
do
    case $1 in
        -f | --file )
			fileName=$1
            ;;
        -p | put )
			key=$2
			value=$3
			if [ "${key:0:1}" == "$" ]
	        then
	            key=$(grep "${key#"$"} " "$fileName" | grep -o "\S\+$")
	            put
	        elif [ ${value:0:1} == "$" ]
	        then
	            value=$(grep "${value#"$"} " "$fileName" | grep -o "\S\+$")
	            put
	        else
	  			put
		    fi
            ;;
		-d | del )
			key=$2
			value=$3
		del
            ;;

        -s | select )
			key=$2
			selects
        ;;
        flush )
			echo "" > $fileName
        ;;
        -k)
		optionK=true;
		;;
    esac
    shift
done
