
# pass a list of files to show what xdg-mime thinks about the mime type of the files
show_mime_from_files () {
	(
	for file 
	#this doesn't work: MIM="$(file -b --mime-type "$file" )"  it appears to work for most files, but returns wrong type for files ending in m4a
	do MIM="$(xdg-mime query filetype "$file")"
		#https://unix.stackexchange.com/questions/47832/is-there-a-simple-command-for-outputting-tab-delimited-columns/47847#47847
		file_s=${file: -18}  #cut the filename so columns of output  look ok
		test ${#file} -le 18  &&  file_s="$file"
		#`echo -n "$file_s" echo -ne '\t' echo -e "$MIM" \t
		printf "%-18s      %-33s     %s\n" "$file_s" "$MIM" "$(xdg-mime query default "$MIM")" 
	done
	)
}

# pass a list of files, then enter a new desktop file when script asks for it.
# should output some shellcode to help you change default application for mime types
output_mime_code () {
	(
	echo  'enter code like "mpv.desktop" or ctrl-c'
	read
	#output some shell script for resetting file assoc
	for file 
	do MIM="$(xdg-mime query filetype "$file")"
		#xdg-mime default mpv.desktop video/quicktime
		echo xdg-mime default "$REPLY" "$MIM"
	done |sort -u
	)
}

		
get_yesno () {
#perl -e 'if ( <> =~ /^y$/i){ exit 0;} exit 1;'
#now match any number of yyyy with whitespace
perl -e 'if ( <> =~ /^\s*y+\s*$/i){ exit 0;} exit 1;'

}

