#!/bin/bash

optionI=false
optionV=false
optionR=false
  
function removeFile() {
  
 fileINode=$(ls -li "$1" | cut -d" " -f1)
 newFileName="$1"_"$fileINode"

 # Renaming the to be removed file
 mv "$1" "$newFileName"

 currDirectory=$(pwd)/"$1"
 
 mv "$newFileName" /home/$USER/deleted
 
 # Adding the filename and path into hidden file
 echo -n "$newFileName"":" >> /home/$USER/.restore.info
 echo "$currDirectory" >> /home/$USER/.restore.info
}

function removeFileRecursive() {

   fileINode=$(ls -li "$2" | cut -d" " -f1)
   newFileName="$1"_"$fileINode"

   # Renaming the to be removed file
   mv "$2" "$newFileName"

   currDirectory=$(pwd)/"$2"

   mv "$newFileName" /home/$USER/deleted

   # Adding the filename and path into hidden file
   echo -n "$newFileName"":" >> /home/$USER/.restore.info
 echo "$currDirectory" >> /home/$USER/.restore.info
}

function recursivelyRemove() {

 for file in "$1"*
 do
   if [ -d "$file" ]
   then
     recursivelyRemove "$file"/
     else
       removeFileRecursive "$(basename $file)" "$file"
     fi
	 done
   rmdir "$1"
}

while getopts ivr opt
 do
   case $opt in
     i) optionI=true ;;
     v) optionV=true ;;
     r) optionR=true ;;
   esac
done

 shift $(($OPTIND - 1))

 if [ ! -d /home/$USER/deleted ]
 then
   mkdir /home/$USER/deleted
 fi

 if [ $# -lt 1 ]
 then
   echo "remove: missing operand"
   exit 1
 fi

 for i in "$@"
 do

   if [ $(basename "$i") = "remove" ]
   then
     echo "Attempting to delete remove - operation aborted"
     exit 1
   fi

   if [ -d "$i" ]
   then
     if [ "$optionR" = true ]
     then
      recursivelyRemove $i
      exit 0
     else
       echo "remove: cannot remove '$i': Is a directory"
       exit 1
     fi
   fi

   if [ ! -e "$i" ]
   then
     echo "remove: cannot remove '$i': No such file or directory"
     exit 1
   fi

   if [ "$optionI" = true ] && [ "$optionV" = true ]
   then
     read -p "remove: remove regular file '$i'? : " yesno
     case $yesno in
       [yY]) removeFile $i
             echo "removed '$i'" ;;
       [nN]) continue;;
     esac
   elif [ "$optionV" = true ]
   then
     echo "removed '$i'"
     removeFile $i
   elif [ "$optionI" = true ]
   then
     read -p "remove: remove regular file '$i'? : " yesno
     case $yesno in
       [yY]) removeFile $i;;
       [nN]) continue;;
     esac
   else
     removeFile $i
   fi
done
