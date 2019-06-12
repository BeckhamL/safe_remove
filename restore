 #!/bin/bash

fileName=$1
OGfilename=$(grep "$fileName" /home/$USER/.restore.info | cut -d":" -f2)
filePath=$(grep "$fileName" /home/$USER/.restore.info | cut -d":" -f2)
deletedfilename=$(grep "$fileName" /home/$USER/.restore.info | cut -d":" -f1)
concatFile=$(basename $OGfilename)
concatPath=$(dirname $filePath)

if [ $# -lt 1 ]
then
  echo "restore: missing operand"
  exit 1
fi

if [ -d "$fileName" ]
then
  echo "restore: cannot restore '$fileName': Is a directory"
  exit 1
fi

if [ ! -f /home/$USER/deleted/"$fileName" ]
then
  echo "restore: cannot restore '$fileName': No such file or directory"
  exit 1
fi

# Getting the path and filename from .restore.info

if [ -d "$concatPath" ]
then
 if [ -f $concatPath/$concatFile ]
 then
   read -p "Do you want to overwrite? y/n " response
   case $response in
     [yY])
         mv /home/$USER/deleted/"$deletedfilename" "$concatPath"
         cd "$concatPath"
         rm "$concatFile"
         mv "$deletedfilename" "$concatFile"
         egrep -v "$fileName" /home/$USER/.restore.info > /home/$USER/.temp_restore.info
         mv /home/$USER/.temp_restore.info /home/$USER/.restore.info
         exit 0;;
        *)
         exit 0;;
     esac
   else
 mv /home/$USER/deleted/"$deletedfilename" "$concatPath"
     cd "$concatPath"
     mv "$deletedfilename" "$concatFile"
     egrep -v "$fileName" /home/$USER/.restore.info > /home/$USER/.temp_restore.info
     mv /home/$USER/.temp_restore.info /home/$USER/.restore.info
     exit 0
   fi
 else
   if [ -f $concatPath/$concatFile ]
   then
     read -p "Do you want to overwrite? y/n " response
     case $response in
     [yY])
         mkdir -p "$concatPath"
         mv /home/$USER/deleted/"$deletedfilename" "$concatPath"
         cd "$concatPath"
         rm "$concatFile"
         mv "$deletedfilename" "$concatFile"
         egrep -v "$fileName" /home/$USER/.restore.info > /home/$USER/.temp_restore.info
         mv /home/$USER/.temp_restore.info /home/$USER/.restore.info
         exit 0;;
        *)
         exit 0;;
     esac
   else
     mkdir -p "$concatPath"
     mv /home/$USER/deleted/"$deletedfilename" "$concatPath"
     cd "$concatPath"
     mv "$deletedfilename" "$concatFile"
     egrep -v "$fileName" /home/$USER/.restore.info > /home/$USER/.temp_restore.info
     mv /home/$USER/.temp_restore.info /home/$USER/.restore.info
     exit 0
   fi
 fi
