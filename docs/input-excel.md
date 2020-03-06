# Input Requirements for the Excel Spreadsheet Format

This discusses the desired Excel spreadsheet format I'd like to see, plus some comments around the various data. In general, the closer they get to this, the better.

**This is a work in progress. Please don't hesitate to comment and point out issues!**


## Excel Version and Features

I'd much prefer *Office 365* or *2010*, if possible. *2003* will work but most likely require extra work.

*A single-worksheet approach* is much easier to process, so we should avoid the temptation to put things in separate worksheets.

*Hyperlinks to courses* are fine, as long as they are not embedded in content fields, say descriptions that use HTML tagging. *A hyperlink should always be placed in its own cell.*

*Content fields should use HTML tagging whenever possible.* Text-only formatting in cells, with line breaks and the like, risk breaking.

Care should be taken to *not* duplicate content in different columns. This tends to happen when exporting raw DB contents - probably a normalisation "feature".


## Numbers and Units

When providing a *price*, a *currency unit* and the *registration type* (full, adult, senior, etc) should also be provided.

*A start or end date should be given in proper Excel date format, that is, formatting the Excel cell as a date.* This ensures that we can recognise and format any dates properly later.

*A duration should be given as a number accompanied by a unit* (days, weeks, etc). Easiest is to give a duration time in one column and a duration unit in the next.

*Times should be given using Excel's 24-hr time format*, if possible. A range should be OK, i.e. 08:00 - 16:00.


## Locations

A city should be accampanied by a country.

A college should be identified with at least a name but also a location, preferably with address and contact info.

The course's attendance type (location, online, etc) should be clearly given.


## Identifiers

The *provider* should be identified in a column in the spreadsheet. In my tests, I've had to use the filename to get some kind of identification.

Every *course* should have a unique identifier. I've had to generate IDs based on the course name in some cases, which is far from ideal.

If there are multiple occurrences of a single course (in differing time slots, for example), this should be stated clearly. 


## Column Suggestions

This lists suggested columns in the spreadsheet. Each of these is mapped to the XML.

* Provider_Name
* Provider_ID
* Provider_URL (optional)
* Course_Name
* Course_ID
* Course_Multiple_Occurence (true/false - indicates if the same course is offered multiple times)
* Course_Description (HTML content)
* Course_URL
* Category_1
* Category_2 (optional)
* Category_3 (optional)
* Start_Date (date for course start)
* End_Date (date for course end - optional)
* Duration_Time (number)
* Duration_Unit (unit - days, weeks, etc)
* Duration_Mode (full-time, part-time, percentage - optional)
* Times (start and end times - optional)
* Country
* City
* College_Name
* Receiver_Email (optional?)
* Address (comma-separated address lines according to country convention - optional)
* Event_Price (number)
* Event_Currency (currency for that number)
* Event_Price_Type (full, adult, discount, etc)
* ... (repeat the three pricing columns as needed)

Any additional information should follow the above in separate columns - they will all be mapped to content fields, so I would expect HTML tagging.


## Examples

The *Activate_Learning* spreadsheet provides durations in three separate columns, *Length_Days*, *Length_Weeks*, and *Length_Years*. The contents are always numbers, and all but one of them in any row will be 0. This works since there is no doubt about the duration time or unit.

The *Surrey_Adult_Learning* spreadsheet provides durations in a single column, with string values such as "10 Week" and "1 Day". These are a bit dodgy since we'll have to analyse the string contents using a regular expression to find out the duration time and unit. While the values may be created by an applicationv - they most likely are since the spreadsheet appears to be a simple DB dump - there is no way to know what the allowed values are.


## Issues & Comments

* Should required qualification credentials for applying be given in a dedicated column for the purpose or simply as a generic content field?
* Should a degree resulting from the course be given in a dedicated column or a content field?


[Ari Nordström](mailto:ari.nordstrom@gmail.com)
2020-03-06


