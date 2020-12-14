# Teams-Attendance
Bash script to summarize Microsoft Teams Participant attendance data

[![Codacy Badge](https://app.codacy.com/project/badge/Grade/3fe859683f384a1c80f759dccebe2195)](https://www.codacy.com/gh/justincbagley/Teams-Attendance/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=justincbagley/Teams-Attendance&amp;utm_campaign=Badge_Grade) [![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)

<br/>
<!-- ![microsoft-teams](https://raw.githubusercontent.com/justincbagley/Teams-Attendance/master/assets/1920px-Microsoft_Office_Teams_(2018–present).svg.png) -->
<p align="center"><img src="/assets/1920px-Microsoft_Office_Teams_(2018–present).svg.png?raw=true"/ width="150"></p>

<!-- > _"If you downloaded participants data to take attendance in Microsoft Teams, then you're
> going to need this!!!"_
<br/><br/> -->

Did you use participants data to take attendance through [Microsoft
Teams](https://www.microsoft.com/en-us/microsoft-365/microsoft-teams/) for your online
course? 

If yes, then this software is for _you_.

## Bash script to summarize Microsoft Teams attendance

This is a `Bash` script for macOS or Linux users who taught an online course through
[Microsoft Teams](https://www.microsoft.com/en-us/microsoft-365/microsoft-teams/), took
attendance by exporting from the "Participants" tab in the Teams client app (which outputs
attendance `.csv` files of student names and meeting join/exit times), and want to
summarize student attendance from the resulting files.

Given a directory of attendance `.csv` files mentioned above for one or more sections of a
course, and a list of student names, `teams_attendance.sh` will summarize attendance records 
for each student, over all class meetings represented by the `.csv` files.

Results are simultaneously printed to screen and logged to a logfile named 'teams_attendance.log.txt', 
and a final summary table is both printed to screen (and log) and saved as a table in `.txt` and 
`.csv` formats. All output files are reorganized into an `output/` subfolder in the current working 
directory, and the logfile is saved in `output/logs/`.

### Rationale

I found myself at the end of my first semester as a university professor with all of my 
lecturing, discussions, assessment, and grading done, but with folders of 
"Participants" attendance files exported from [Microsoft
Teams](https://www.microsoft.com/en-us/microsoft-365/microsoft-teams/) for each course 
section, and no straightforward way to summarize student attendances. 

I also realized after 
finals week that when submitting my grades I would need to give the last date of attendance 
and total number of hours attended for any student with a failing grade ("F", in the U.S. 
education system) or a grade of incomplete ("I"). 

I wrote this software myself 
to provide a permanent solution to all of the above, since our university is likely to continue using Microsoft 
Teams into the foreseeable future. 

> _Note:_ Other non-command line tools are available for classroom attendance, including tools 
> in the Turning Point software and Teams apps (e.g. Microsoft [AttendanceBot](https://attendancebot.freshdesk.com/support/solutions/articles/17000101416)). Others may be more 
> satisifed with the above GUI software, for example if it better fits your level of computing 
> experience. 
> 
> However, I am a husband and father and a newbie professor on the tenure track. I don't need 
> _any more_ obligations, or teaching- or technology-related taks, to consume my highly-prized 
> work time. I prefer to quickly write up my own CLI software code ([see here](https://gist.github.com/justincbagley/95cfaf9601b4af6f3afa93b4d2155abb)) using `Bash`, `R`, or `python` because I 
> find coding to be fun and rewarding and my results to often be stable (with 
> limited learning curve, since I _always_ document my code).

## Installation

This is a `Bash` script, ready to run on many UNIX/Linux boxes, right from the start. No compilation 
needed. Relies on Perl and other standard UNIX/Linux command line tools (e.g `sed`, `grep`). 

### Homebrew install

[See here.](https://github.com/justincbagley/homebrew-tap)

**Recommended:**

1. Development (cutting edge) Homebrew install:

```bash
# Install:
brew tap justincbagley/homebrew-tap ;
brew update ;
brew install teams_attendance ;
```

### Install by hand

2.  Installation 'by-hand' from terminal:
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

## Usage

Basic usage: 

`teams_attendance.sh` is easy to use. Simply feed the script a list of student names, as 
shown in the help texts _below_.

Access the regular help text using the `-h` or `--help` flags (e.g. `$ ./teams_attendance.sh -h`), 
which output the following:

```bash

Usage: chmod u+x ./teams_attendance.sh   ;	# add permissions
       ./teams_attendance.sh <namesList> ;
       # OR
       bash ./teams_attendance.sh <namesList> ; 

 ... where <student_names_list> is a file containing one column of student names, given as
 'firstName lastName', delimited by a single space.

 Created by Justin Bagley on Wed, Dec 9 16:11:18 CST 2020.
 Copyright (c) 2020 Justin C. Bagley. All rights reserved.
```

Verbose usage:

Access the verbose help text using the `-H` or `--Help` flags (e.g. `$ ./teams_attendance.sh -H`), 
which output the following:

```bash

Usage: chmod u+x ./$(basename "$0")   ;	# add permissions
       ./$(basename "$0") <namesList> ;

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
```

## LICENSE

BSD 3-clause license [here](LICENSE).

## Contributions

Contributions are welcome!

<!-- Credits 
Microsoft Teams image from Wikipedia: https://en.wikipedia.org/wiki/Microsoft_Teams#/media/File:Microsoft_Office_Teams_(2018–present).svg (saved as PNG).
-->
