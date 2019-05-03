show_mime_from_files () {
	(
	for file 
	#this doesn't work: MIM="$(file -b --mime-type "$file" )"  it appears to work for most files, but returns wrong type for files ending in m4a
	do MIM="$(xdg-mime query filetype "$file")"
		file_s=${file: -14}  #cut the filename so columns of output  look ok
		echo -n "$file_s"
		echo -ne '\t'
		echo -e "      $MIM \t$(xdg-mime query default "$MIM")"
	done
	)
}

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

		

