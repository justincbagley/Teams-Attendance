#!/usr/bin/env bash

## Program: teams_attendance.sh
   VERSION="v1.0.0" 
## Author: Dr. Justin C. Bagley
## Created: Wed Dec 9 16:11:18 CST 2020
## Last updated: December 29, 2020
## 
## Checks and summarizes student attendances in .CSV attendance files exported from Microsoft 
## Teams app, also attempts to identify date of last attendance (or at least provide information
## helpful for determination).

teams_attendance () {

######################################## START ###########################################
echo "
teams_attendance v1.0.0, December 2020 (updated Dec 10 08:44:11 CST 2020)                                       "
echo "Copyright (c) 2020 Justin C. Bagley. All rights reserved.                                                 "
echo "----------------------------------------------------------------------------------------------------------"

	####### EVALUATE STUDENT LIST:
	

	####### PRINT STARTING CONDITIONS TO SCREEN:
	echo "INFO      | $(date) | Starting teams_attendance analysis... "
	echo "INFO      | $(date) | Current working directory: "
	echo "INFO      | $(date) | $PWD "
	echo "INFO      | $(date) | Student list: ${MY_STUDENT_LIST}"
	
	####### SET LOG FILE:
	MY_LOGFILE=teams_attendance.log.txt ;
	if [[ -s "$MY_LOGFILE" ]]; then rm "$MY_LOGFILE" ; fi;
	touch "$MY_LOGFILE";
	
	####### CHECK MACHINE TYPE:
	## This idea and code came from the following URL (Lines 87-95 code is reused here):
	## https://stackoverflow.com/questions/3466166/how-to-check-if-running-in-cygwin-mac-or-linux
	echo "INFO      | $(date) | Checking machine type... " | tee -a "$MY_LOGFILE" ;
	unameOut="$(uname -s)"
	case "${unameOut}" in
		Linux*)     machine=Linux;;
		Darwin*)    machine=Mac;;
		CYGWIN*)    machine=Cygwin;;
		MINGW*)     machine=MinGw;;
		*)          machine="UNKNOWN:${unameOut}"
	esac
	echo "INFO      | $(date) | Found machine type ${machine}. " | tee -a "$MY_LOGFILE" ;
	echo "INFO      | $(date) | "

	####### ADD OTHER INTERNAL FUNCTIONS AND VARIABLES:
	
	# Tab
	TAB="$(printf '\t')";
	
	# Remove parentheses from filenames:
	# URL: https://www.linuxquestions.org/questions/linux-software-2/how-do-you-remove-parenthesis-from-filenames-using-sed-812975/
	replace_parentheses () {
		(
			for i in ./*.csv; do
				i="$(basename "$i")";
				j=${i//[\(\)]/};
				mv "$i" "$j" ;
			done
		)
	}

	# Remove spaces from filenames:
	# URL: https://unix.stackexchange.com/questions/223182/how-to-replace-spaces-in-all-file-names-with-underscore-in-linux-using-shell-scr
	replace_spaces () {
		find . -name "* *.csv" -type f -print0 | \
		while read -d $'\0' f; do mv -v "$f" "${f// /_}"; done
	}
	
	# Remove \" (double-quotes) from within files:
	remove_quotes () {
		(
			for i in ./*.csv; do
				if [[ "$machine" = "Mac" ]]; then
					sed -i '' 's/\"//g' "$i" ;
				fi
				if [[ "$machine" = "Linux" ]]; then
					sed -i 's/\"//g' "$i" ;
				fi
			done
		)
	}
	
	check_attendance () {
	count=1
	(
		while read NAME; do
			echo "INFO      | $(date) | -------- Checking attendance for student ${count}.: ${NAME} " | tee -a "$MY_LOGFILE" ;
			(
				for FILE in ./*.csv; do 
					#echo "$FILE";
					
					## Check file encoding:
					MY_UTF16_CHECK="$(file "$FILE" | grep 'Little-endian UTF-16' | wc -l | sed 's/\ //g' )";
					
					## Change UTF16 to std UTF8 if needed:
					## Idea from URL: https://jim-zimmerman.com/?p=893
					if [[ "$MY_UTF16_CHECK" != "0" ]]; then
					MY_FILENAME="$(basename "$FILE")";
					echo "WARNING   | $(date) | UTF-16 encoding detected... " | tee -a "$MY_LOGFILE" ;
						 if [ -s $(which iconv) ]; then 
						 	echo "INFO      | $(date) | Fixing with to UTF-8 with iconv... " | tee -a "$MY_LOGFILE" ;
						 	iconv -f utf-16 -t utf-8 "$MY_FILENAME" > _"$MY_FILENAME"_ ;
						 	mv _"$MY_FILENAME"_ "$MY_FILENAME" ;
						 fi
					fi
					
					MY_FILENAME="$FILE";
					if [[ -s "$MY_FILENAME" ]]; then
						## Check attendance on file:
						MY_ATTEND_CHECK="$(cat "$MY_FILENAME" | grep "${NAME}" | wc -l | sed 's/\ //g')";
						#echo "INFO      | $(date) | Attendance check: $MY_ATTEND_CHECK";
													
						## If student attended on day of corresponding attendance file, do stuff:
						if [[ "$MY_ATTEND_CHECK" != "0" ]]; then 
							#echo "INFO      | $(date) | Attendance check: $MY_ATTEND_CHECK";
							
							## Get date of attendance and echo to screen and logfile:
							if [[ "$(cat "$MY_FILENAME" | grep 'Joined before\t' | wc -l | sed 's/\ //g')" -gt "0" ]]; then
								MY_DATE_GRAB="$(cat "$MY_FILENAME" | grep 'Joined\ before' | head -n1 | sed 's/^.*Joined\ before\t//g; s/\,.*//g')";
							fi
						#							
							if [[ "$(cat "$MY_FILENAME" | grep 'Joined\t' | wc -l | sed 's/\ //g')" -gt "0" ]]; then
								MY_DATE_GRAB="$(cat "$MY_FILENAME" | grep 'Joined\t' | head -n1 | sed 's/^.*Joined\t//g; s/\,.*//g')";
								#optional addition to pipe: perl -pe 's/^.*([0-9]{1,}\/[0-9]{1,}\/[0-9]{4}).*/$1/g'
							fi
						#							
							#echo "INFO      | $(date) | Student attendance: ${MY_DATE_GRAB} ($MY_FILENAME)" | tee -a "$MY_LOGFILE"					
							#echo "INFO      | $(date) |                     $(ls -l "$FILE")" | tee -a "$MY_LOGFILE" ;
							echo "INFO      | $(date) | Record: ${MY_DATE_GRAB}${TAB}  $(ls -l "$FILE") " | tee -a "$MY_LOGFILE" ;
						#							
							## Save tmp file of student dates and add dates to it:
							echo "$MY_DATE_GRAB" >> ./student_records.tmp ;							
						fi
					else
						echo "WARNING   | $(date) | No file named ${MY_FILENAME} found in current directory." | tee -a "$MY_LOGFILE" ;
					fi
				done
			)
			
			## Identify last date of attendance for student and print to screen:
			sort -n -t"/" -k3 -k1 -k2 ./student_records.tmp > ./student_records2.tmp ;
			MY_LAST_DATE="$(tail -n1 ./student_records2.tmp)";
			echo "INFO      | $(date) | Last attendance date: ${MY_LAST_DATE} " | tee -a "$MY_LOGFILE" ;

			## Identify approximate number of total attendances (unique dates):
			sort -u ./student_records2.tmp > ./student_records3.tmp ;
			MY_TOTAL_NUM_ATT="$(cat ./student_records3.tmp | wc -l | sed 's/\ //g')";
			echo "INFO      | $(date) | Total no. attendance records: ${MY_TOTAL_NUM_ATT} " | tee -a "$MY_LOGFILE" ;
			
			## Save results to summary file:
			echo "${NAME}	${MY_LAST_DATE}	${MY_TOTAL_NUM_ATT}" >> ./teams_attendance_summary.txt  ;

			echo "INFO      | $(date) | Student complete. " | tee -a "$MY_LOGFILE" ;
			echo "INFO      | " | tee -a "$MY_LOGFILE" ;

			## Remove tmp file:
			if [[ -s ./student_records.tmp ]]; then 
				rm ./student_records.tmp ;
			fi

		echo "$((count++)) "  >/dev/null 2>&1 ;
		done < "$MY_STUDENT_LIST" ;
	)
	}


	####### RUN INTERNAL FUNCTIONS:

	replace_parentheses ;
	replace_spaces ;
	remove_quotes ;
	check_attendance ;


	####### CLEAN UP WORKSPACE AND ORGANIZE OUTPUT:
	clean_workspace () {

		echo "INFO      | Cleaning workspace and organizing output files... " | tee -a "$MY_LOGFILE"

		## Organize output files:
		if [[ ! -s output/ ]]; then mkdir output/ ; fi;
		if [[ ! -s output/logs/ ]]; then mkdir output/logs/ ; fi;
		# Edit and organize summary file (e.g. add header, align columns):
		if [[ -s ./teams_attendance_summary.txt ]]; then 
			echo "Name	lastDate	totalRecords" > ./header.tmp ; 
			cp ./teams_attendance_summary.txt ./summary.tmp ;
			cat ./header.tmp ./summary.tmp > ./teams_attendance_summary.tmp ;
			column -t -s'	' ./teams_attendance_summary.tmp > ./teams_attendance_summary.txt ;
			if [[ -s ./teams_attendance_summary.txt ]]; then mv ./teams_attendance_summary.txt output/ ; fi;
		fi
		# Also save summary in .csv format:
		if [[ -s ./output/teams_attendance_summary.txt ]]; then
			cp ./output/teams_attendance_summary.txt ./output/teams_attendance_summary.csv ;
			perl -p -i -e 's/\ +/\,/g' ./output/teams_attendance_summary.csv ;
			perl -p -i -e 's/Name/firstName\,lastName/g' ./output/teams_attendance_summary.csv ;
		fi

		## Remove temporary or unnecessary files created above:
		echo "INFO      | $(date) | Removing temporary files... "
		if [[ "$(ls -1 ./*.tmp 2>/dev/null | wc -l | sed 's/\ //g')" != "0"  ]]; then 
			rm ./*.tmp ; 
		fi	
		
		echo "INFO      | Done. " | tee -a "$MY_LOGFILE"
	}

	## RUN CLEANUP:
	clean_workspace


	echo "----------------------------------------------------------------------------------------------------------"
	echo "" | tee -a "$MY_INPUT_DIR""$MY_LOGFILE_SWITCH"
	echo "-------- Final Teams attendance summary table: -------- " | tee -a "$MY_INPUT_DIR""$MY_LOGFILE_SWITCH"
	echo "" | tee -a "$MY_INPUT_DIR""$MY_LOGFILE_SWITCH"
	
	if [[ -s ./output/teams_attendance_summary.txt ]]; then
		echo "----------------------------------------------------"
		cat ./output/teams_attendance_summary.txt ;
		echo "----------------------------------------------------"
	fi
	
	echo "" | tee -a "$MY_INPUT_DIR""$MY_LOGFILE_SWITCH"
	echo "----------------------------------------------------------------------------------------------------------"
	echo "output file location(s): output/ " | tee -a "$MY_INPUT_DIR""$MY_LOGFILE_SWITCH"
	echo "output file location(s): output/logs/ " | tee -a "$MY_INPUT_DIR""$MY_LOGFILE_SWITCH"
	echo "" | tee -a "$MY_INPUT_DIR""$MY_LOGFILE_SWITCH"

	## Place logfile in output subfolder:
	if [[ -s ./teams_attendance.log.txt ]]; then mv ./teams_attendance.log.txt output/logs/ ; fi;


######################################### END ############################################

}

############ READ USER INPUT:
MY_STUDENT_LIST="$1"

############ CREATE USAGE & HELP TEXTS:
USAGE="
Usage: chmod u+x ./$(basename "$0")   ;	# add permissions
       ./$(basename "$0") <namesList> ;
       # OR
       bash ./$(basename "$0") <namesList> ;

 ... where <student_names_list> is a file containing one column of student names, given as
 'firstName lastName', delimited by a single space.

 Created by Justin Bagley on Wed, Apr 15 17:10:14 CDT 2020.
 Copyright (c) 2020 Justin C. Bagley. All rights reserved.
"

VERBOSE_USAGE="
Usage: chmod u+x ./$(basename "$0")   ;	# add permissions
       ./$(basename "$0") <namesList> ;
       # OR
       bash ./$(basename "$0") <namesList> ;

 ... where <student_names_list> is a file containing one column of student names, given as
 'firstName lastName', delimited by a single space.

 Example <namesList>:
 
 Chuck Barry
 Elivs Presley
 Fats Domino

 This program runs on UNIX-like and Linux systems using commonly distributed utility 
 software, with usage as obtained by running the script with the -h flag. It has been 
 tested with Perl v5.1+ on macOS Catalina (v10.13+), but should work on many other versions 
 of macOS or Linux using standard UNIX/Linux utility software. No other dependencies are 
 required.

 Created by Justin Bagley on Wed, Dec 9 16:11:18 CST 2020.
 Copyright (c) 2020 Justin C. Bagley. All rights reserved.
"

if [[ -z "$*" ]]; then
	echo "$USAGE"
	exit
fi

if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
	echo "$USAGE"
	exit
fi

if [[ "$1" == "-H" ]] || [[ "$1" == "--Help" ]]; then
	echo "$VERBOSE_USAGE"
	exit
fi

if [[ "$1" == "-V" ]] || [[ "$1" == "--version" ]]; then
	echo "$(basename "$0") $VERSION";
	exit
fi

############ RUN THE SCRIPT:
teams_attendance

exit 0
