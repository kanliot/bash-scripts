#!/bin/bash

hash html2text || err=' html2text not installed'
hash youtube-dl || err='youtube-dl not installed'
hash tempfile || err='tempfile not installed'
hash less || err='less not installed'
#assumes tail is installed

if [ -n "$err" ] 
then echo autocapt.sh error: $err; exit 1
fi


#e="$(grep '<p'   -nom1 "$ tail -n "${e%%:*}"


# Automatic captions  copyrightkanliot https://json.org/license.html
# configure these options if you don't like the defaults 
#
choplines=9 	 #need to chop off some html so html2text doesn't puke

[ -z "$textwidth" ]    && textwidth=41 	 #you can wrap text for shorter lines
[ -z "$languagecode" ] && languagecode=en  # set language code here, i use "en" for english






vidcaptions () {
        youtube-dl   --write-auto-sub --sub-format ttml --skip-download  "$@"
}


if [ ! -e "$1" ] #basically if argument is a ttml file then it's not downloaded as an URL 
	then
	
	echo "$0" assumes you can just type -o in less to save the text you see.
	echo ^  "$1"
	vidtitle=`youtube-dl -i --get-title -- "$1"`
	set -e	
	cd /tmp
	FIL=`tempfile`
	rm $FIL

	echo "$0" assumes you can just type -o in less to save the text you see.
	echo ^  "$1"

	vidcaptions -o $FIL --sub-lang $languagecode  -- "$1" 
	printf %b "[\033]0;$(basename "$vidtitle")\007\]";

	tail -n+$choplines "$FIL"."$languagecode".ttml|  html2text -width $textwidth - |less 
	echo 
	echo type y now to remove tempfile
	rm -iv "$FIL"."$languagecode".ttml #clean up /tmp
else 
	tail -n+$choplines "$1"|  html2text -width $textwidth - |less 
fi




exit 0

