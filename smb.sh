function help_echo {
    echo -e "    
          \e[4;104m                                Made by                                     \e[0m
                                                                                                    
                              ___       ___       ___       ___   
                             /\__\     /\__\     /\  \     /\__\  
                            /:/  /    /:/ _/_   /::\  \   /:/ _/_ 
                           /:/__/    |::L/\__\ /:/\:\__\ |::L/\__\ 
                           \:\  \    |::::/  / \:\/:/  / |::::/  /
                            \:\__\    L;;/__/   \::/  /   L;;/__/ 
                             \/__/               \/__/            

             ___       ___       ___       ___       ___       ___       ___       ___   
            /\__\     /\  \     /\  \     /\  \     /\  \     /\__\     /\  \     /\__\  
           |::L__L   /::\  \   /::\  \   /::\  \   /::\  \   /:/  /    /::\  \   /:/ _/_ 
           |:::\__\ /::\:\__\ /::\:\__\ /:/\:\__\ /\:\:\__\ /:/__/    /::\:\__\ |::L/\__\ 
           /:;;/__/ \/\::/  / \;:::/  / \:\/:/  / \:\:\/__/ \:\  \    \/\::/  / |::::/  /
           \/__/      /:/  /   |:\/__/   \::/  /   \::/  /   \:\__\     /:/  /   L;;/__/ 
                      \/__/     \|__|     \/__/     \/__/     \/__/     \/__/            

                                                              __          
                    .-----..----..-----..-----..-----..-----.|  |_ .-----.
                    |  _  ||   _||  -__||__ --||  -__||     ||   _||__ --|
                    |   __||__|  |_____||_____||_____||__|__||____||_____|
                    |__|                                                             
                         00110010 01001100  01101001  01101100  01100001
                         -----------------------------------------------
                        |\e[5;104m      ___                   ___       ___      \e[0m|    
                        |\e[5;104m     /\__\      ___        /\__\     /\  \     \e[0m|   
                        |\e[5;104m    /:/  /     /\  \      /:/  /    /::\  \    \e[0m|  
                        |\e[5;104m   /:/  /      \:\  \    /:/  /    /:/\:\  \   \e[0m| 
                        |\e[5;104m  /:/  /       /::\__\  /:/  /    /::\~\:\  \  \e[0m|
                        |\e[5;104m /:/__/     __/:/\/__/ /:/__/    /:/\:\ \:\__\ \e[0m|
                        |\e[5;104m \:\  \    /\/:/  /    \:\  \    \/__\:\/:/  / \e[0m|
                        |\e[5;104m  \:\  \   \::/__/      \:\  \        \::/  /  \e[0m|
                        |\e[5;104m   \:\  \   \:\__\       \:\  \       /:/  /   \e[0m| 
                        |\e[5;104m    \:\__\   \/__/        \:\__\     /:/  /    \e[0m|   
                        |\e[5;104m     \/__/                 \/__/     \/__/     \e[0m| 
                         -----------------------------------------------      
                         00110010 01001100  01101001  01101100  01100001

                       |usage sbm   [ --help ]
                                    [ --create ] ORIGINAL PATH EXTENSION COUNT
                                    [ --check ]  ORIGINAL PATH ARCHNAME

		       \e[4;104m--------------------------------------------------\e[0m 
			
		       |EXAMPLES HOW TO WRITE COMMANDS:
	    		
		       |./smb.sh --create ~/your_original_folder ~/destination_folder doc 3
		       |./smb.sh --check ~/your_original_folder ~/destination_folder backup-2019:11:23-15:00:00.zip		
				
                       \e[4;104m--------------------------------------------------\e[0m

                       |--help   - print this
                       |--check  - check control summ of archive
                       |--create - create backup"
    exit
}

if [ -n "$1" ]
then
    case "$1" in 
        --help) help_echo;;
        --create) 

            arch_name="backup-$(date +%Y:%m:%d-%H:%M:%S).zip"
            mkdir -p "$3"
	    zip_number=$(ls "$3" | grep -c "zip$") 
            if [ "$5" -le $zip_number ]
            then
		for ((i=0; i<=$zip_number - $5; i++))
		do
			rm $3/$(ls "$3" | grep --max-count=1 ".zip$")
		done
            fi  
            md5sum $(ls "$2"| grep "$4$" | awk -F '\n' '{ print $0 }')  >> $2/control
            zip -r $3/$arch_name $(ls $2 | grep "$4$" | awk -v dir=$2/ '{ print dir $0 }')  $2/control
            rm $2/control
	    if [[ ! $(unzip -tq "$3/$arch_name") == "No"* ]]
                then
                    unzip -tq "$3/$arch_name"
                    echo "Ah shit, Here we go again...
I would delete this broken backup"
                    rm "$3/$arch_name"
           fi;;

        --check) 

           mkdir -p "./checker" 
	   unzip "$3/$4" -d "./checker"
	   (( res= $(md5sum -c "./checker$2/control" | grep "\(OK\|ЦЕЛ\)$" | wc -l) - 1 ))
	   if [[ $res -gt $(ls "./checker$2"| grep  -c "backup") ]]
	   then
	   	echo -e "\e[5;42mGood work! All files are awesome!\e[0m"
	   else
	  	echo -e "\e[4;42mWhoopsie! Seems that ur files have been corrupted!\e[0m"
	   	rm -r "$3/$4"
	   	exit
	   fi 
	   rm -dr "./checker";;

        *) help_echo;;
    esac
fi
