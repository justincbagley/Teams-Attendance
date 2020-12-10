# Teams-Attendance
Bash script to summarize Microsoft Teams Participant attendance data

<br/>

> _"If you downloaded participants data to take attendance in Microsoft Teams, then you're
> going to need this!!!"_
<!-- <br/><br/> -->

Did you use participants data to take attendance through [Microsoft
Teams](https://www.microsoft.com/en-us/microsoft-365/microsoft-teams/) for your online
course? If yes, then this software is for _you_.

# Bash script to summarize Microsoft Teams attendance

This is a `Bash` script for macOS or Linux users who taught an online course through
[Microsoft Teams](https://www.microsoft.com/en-us/microsoft-365/microsoft-teams/), took
attendance by exporting from the "Participants" tab in the Teams client app (which outputs
attendance `.csv` files of student names and meeting join/exit times), and want to
summarize student attendance from the resulting files.

Given a directory of attendance `.csv` files mentioned above for one or more sections of a
course, and a list of student names, `teams_attendance.sh` will summarize attendance records 
for each student, over all class meetings represented by the `.csv` files.



## Rationale

I found myself at the end of my first semester as a university professor with all of my 
lecturing, discussions, testing, and grading done, but with folders of 
"Participants" attendance files exported from [Microsoft
Teams](https://www.microsoft.com/en-us/microsoft-365/microsoft-teams/) for each course 
section, and no straightforward way to summarize student attendances. I wrote this myself 
to provide a permanent solution, since I our university is likely to continue using Microsoft 
Teams in the foreseeable future. 

_Note:_ Other tools are available for classroom attendance, including tools in the Turning 
Point program and Teams apps like Microsoft AttendanceBot. I am husband and father and a newbie professor 
on the tenure track. I don't need _any more_ obligations, or teaching- or technology-related 
taks, to consume my highly-prized work time. I prefer to quickly write up my own code using 
`Bash`, `R`, or `python` (e.g. because I don't trust other people's software and I find what 
I write to be fun and stable). Other people may be more satisifed with the above GUI software.

# Installation

This is a `Bash` script, ready to run on many UNIX/Linux boxes, right from the start. No compilation 
needed. Relies on Perl and other standard UNIX/Linux command line tools (e.g `sed`, `grep`). 

For installation, I suggest (currently):

```
# macOS:
chmod u+x ./teams_attendance.sh ;
cp file /usr/local/bin ;

# Linux:
chmod u+x ./teams_attendance.sh ;
cp file $HOME/bin ;
# OR
cp file $HOME/local/opt ;
```

# Usage

`teams_attendance.sh` is easy to use. Simply feed the script a list of student names, as 
follows (from help text, accessed using the `-h` option flag as shown _below_):

```bash
$ ./teams_attendance.sh -h

Usage: chmod u+x ./teams_attendance.sh   ;	# add permissions
       ./teams_attendance.sh <namesList> ;
       # OR
       bash ./teams_attendance.sh <namesList> ; 

 ... where <student_names_list> is a file containing one column of student names, given as
 'firstName lastName', delimited by a single space.

 Created by Justin Bagley on Wed, Apr 15 17:10:14 CDT 2020.
 Copyright (c) 2020 Justin C. Bagley. All rights reserved.
```


# LICENSE

BSD 3-clause license [here](LICENSE).

# Contributions

Contributions are welcome!

