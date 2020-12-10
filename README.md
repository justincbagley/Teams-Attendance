# Teams-Attendance
Bash script to summarize Microsoft Teams Participant attendance data

> _"If you downloaded participants data to take attendance in Microsoft Teams, then you're going to need this!!!"_

Did you take attendance through [Microsoft Teams](https://www.microsoft.com/en-us/microsoft-365/microsoft-teams/) for your online course? If yes, then this software is for you.

This is a `Bash` script for macOS or Linux users who taught an online course through [Microsoft Teams](https://www.microsoft.com/en-us/microsoft-365/microsoft-teams/), took attendance by exporting from the "Participants" tab in the Teams client app (which outputs attendance `.csv` files of student names and meeting join/exit times), and want to summarize student attendance from the resulting files.

Given a directory of attendance `.csv` files mentioned above for one or more sections of a course, and a list of student names, `teams_attendance.sh` will loop through the attendance files and summarize attendance records over all class meetings represented by the 
