#!/bin/sh
[ -n "$1" ] && mon=$1 || mon=0
brvfile=$HOME/.config/BraveSoftware/Brave-Browser/Default/Bookmarks
[ -n "$brvfile" ] && bvb="Brave Bookmarks" || bvb=""
while true; do 
	bookmark=$(printf "Bookmarks\\nSwitch Browser\\nYouTube\\nOdysee\\nDuckDuckGo\\nbol\\n%s" "$bvb" | dmenu -m $mon -h 40 -i) ; [ -n "$bookmark" ] || exit 
	case $bookmark in
		YouTube) choice=$(printf "" | dmenu -m $mon -h 40 -i -p "Youtube ") 
			[ -n "$choice" ] && link="https://www.youtube.com/results?search_query=""$choice" || exit ; break ;;
		Odysee) choice=$(printf "" | dmenu -m $mon -h 40 -i -p "Odysee ") 
			[ -n "$choice" ] && link="https://www.odysee.com/$/search?q=""$choice" || exit ; break ;;
		DuckDuckGo) choice=$(printf "" | dmenu -m $mon -h 40 -p " DuckDuckGo ") 
			[ -n "$choice" ] && link="https://duckduckgo.com/?q=""$choice" || exit ; break ;; 
		1337x) choice=$(printf "" | dmenu -m $mon -h 40 -p " 1337x ") 
			[ -n "$choice" ] && link="https://1337x.to/search/""$choice""/1/" || exit ; break ;; 
		bol) choice=$(printf "" | dmenu -m $mon -h 40 -p " bol ") 
			[ -n "$choice" ] && link="https://www.bol.com/nl/s/?searchtext=""$choice" || exit ; break ;; 
		"Switch Browser") newbrowser=$(printf "brave\\nsurf\\nicecat" | dmenu -m $mon -h 40 -i -p "Choose Browser") ;; 
		Bookmarks) 
			if [ -s "$BOOKMARKS"/bookmark_titles ]; then 
				entry=$(dmenu -m $mon -i -l 10 < "$BOOKMARKS"/bookmark_titles) 
				[ -n "$entry" ] || exit 
				idx=$(grep -nx "$entry" "$BOOKMARKS"/bookmark_titles)
				[ -n "$idx" ] && link=$(sed "${idx%%:*}"'!d' "$BOOKMARKS"/bookmarks) && break || link="$entry" ; break
			else 
				link=$(dmenu -m $mon -h 40 -p "Search/URL") ; break
			fi ;;
		"Brave Bookmarks")
			brv_bm=$(grep -B1 '"type": "url"' ~/.config/BraveSoftware/Brave-Browser/Default/Bookmarks | 
				grep "name" | sed "s/\s.\"name\"://g;s/\"//g;s/,//g;s/^[ \t]*//" | dmenu -m $mon -ix -l 20)
			[ -n "$brv_bm" ] && newbrowser="brave" || exit
			link=$(grep '"url":' ~/.config/BraveSoftware/Brave-Browser/Default/Bookmarks | sed "s/\s.*\/\///g;s/\"//g;$brv_bm!d") ; break ;;
		*) link="$bookmark" ; break ;;
	esac
done
[ -n "$link" ] || exit ; [ -n "$newbrowser" ] || newbrowser="$BROWSER"
[ "$newbrowser" = "surf" ] || [ "$newbrowser" = "vimb" ] && newbrowser="tabbed -cr2 $newbrowser -e x"

if [ -n "$choice" ] || [ -n "$idx" ]; then 
	$newbrowser "$link"
elif curl -s --head  --request --fail "$link"; then 
	$newbrowser "$link"
else 
	$newbrowser "https://searx.bar/search?q=""$link"
fi
