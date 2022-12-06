# Weather App
![Weather App Screenshot](/images/Screenshots/weather_app_home_page.png "Weather App Screenshot")

## Developers:
1. Alden Chan [@AldenCh](https://github.com/AldenCh)
    - API Fetching
    - Notifications GUI, Backend
    - Non Local Forecast GUI
    - Settings Page GUI
    - Navigation Bar
    - Localization

2. Nicholas Panait [@NicholasPanait](https://github.com/NicholasPanait)
    - Sign In Page GUI, Backend
    - Non Local Forecast Backend
    - Settings Page Backend
    - Downloaded Forecasts GUI, Backend
    - Localization

3. David Howe [@DavidHoweOTU](https://github.com/DavidHoweOTU)
    - Home Page Current Forecast
    - Home Page GUI
    - More Page GUI, Backend
    - Weather API Parsing
    - Settings Page Backend

## Overview and User Guide
**All weather information is fetched from the [Open Meteo Weather Forecast API](https://open-meteo.com/en/docs#api-documentation)**
This app is a Weather App it has features to: 
- View daily and weekly weather forecasts globally
- Set up daily weather updates
- View and manage which detailed charts and graphs on weather information to see
- Sign In or Sign Up to load or save your settings
- Download weather data for offline viewing


### Current Forecast
An hourly forecast on your current location on the home page including:
- Current Location
- Today's Date
- Current Temperature
- Current Apparent Temperature
- Current Weather
- Today's Highest and Lowest Temperatures
- Scrollable Forecast of The Current and Next 11 Hours<br>

![Current Forecast Screenshot](/images/Screenshots/current_forecast.png "Current Forecast Screenshot")

### Weekly Forecast
A weekly forecast that displays:
- The High and Low Temperatures Of Each Day
- The Weather on Each Day<br>

![Weekly Forecast Screenshot](/images/Screenshots/weekly_forecast.png "Weekly Forecast Screenshot")

### Temperature Unit Selection
An easy toggle between Celsius and Fahrenheit.<br>

![Temperature Unit Screenshot](/images/Screenshots/temperature_unit_toggle.png "Temperature Unit Screenshot")

### Non Local Forecast
To get the weather forecast for somewhere else in the world simply click the AppBar Location Icon.

![Map Directions Screenshot](/images/Screenshots/map_directions.png "Map Directions Screenshot")

Hover the center crosshair on top of your location and click the checkmark to display.

![Non Local Forecast Screenshot](/images/Screenshots/map_page.png "Non Local Forecast Screenshot")

### More Page
==TODO==

![More Page Screenshot](/images/Screenshots/more_page_1.png "More Page Screenshot")

### Settings Page
The settings page allows you to toggle on and off what information to display in the More Page.<br>

![Settings Page Screenshot](/images/Screenshots/settings_page.png "Settings Page Screenshot")

### Account Page
The account page allows you to create or log into an account. The account page also verifies that each user has a unique username and on login, confirms that the password is correct. There is also verification to make sure the username is at least 4 characters, and the password is at least 8 characters.<br>

![Account Page Screenshot](/images/Screenshots/account_page_1.png "Account Page Screenshot")

If a user creates a new account, their settings are saved and uploaded to both cloud and local storage. If a user logs into an existing account, their settings are pulled from cloud storage, and the settings page is updated with the user's settings. Once a user signs out of the app, settings are set back to the default and their account is removed from local storage. When the app starts up, it will load the account that is stored in local storage. If a user taps on the "delete account" button, they will be signed out and their account will be deleted from both local and cloud storage.<br>

![Account Page 2 Screenshot](/images/Screenshots/account_page_2.png "Account Page 2 Screenshot")

### Notifications Page
The page to schedule what time of day to recieve daily weather updates.<br>

![Notifications Page Screenshot](/images/Screenshots/notifications_page.png "Notifications Page Screenshot")

### Offline Weather Forecasts
If you want to download weather forecasts for use when you don't have internet click the AppBar Download Icon.

![Download Directions Screenshot](/images/Screenshots/download_directions.png "Download Directions Screenshot")

Select the date you want to get weather from. Once a date has been selected, the weather app will use that date as the date of the weather. Once a date has been selected, tap on the download button to save the date locally.

![Download Page 1 Screenshot](/images/Screenshots/download_page_1.png "Download Page 1 Screenshot")

The downloaded weather will show up underneath the button. Tapping on a downloaded date will select that date to use for the app. Since the weather is downloaded, it will pull all the weather data from local storage.<br>
**NOTE:** To delete a downloaded forecast select the forecast and click the AppBar Trash Can Icon.<br>
**NOTE:** To reset the forcast to the current date, tap on the AppBar Undo Icon.

![Download Page 2 Screenshot](/images/Screenshots/download_page_2.png "Download Page 2 Screenshot")

## Weather Icons
These are Icons placed alongside temperatures to tell you the 
| Icon | Description |
| :---: | :---|
| ![Clear Day Icon](/images/Icons/sunny.png "Clear Day Icon") | It's a clear sky out and daytime |
| ![Clear Night Icon](/images/Icons/bedtime.png "Clear Night Icon") | It's clear sky out and night time |
| ![Partly Cloudy Day Icon](/images/Icons/wb_cloudy.png "Partly Cloudy Day Icon") | It's partly cloudy out and day time |
| ![Partly Cloudy Night Icon](/images/Icons/nights_stay.png "Partly Cloudy Night Icon") | It's partly cloudy out and night time|
| ![Foggy Icon](/images/Icons/foggy.png "Foggy Icon") | It's foggy outside|
| ![Drizzle Icon](/images/Icons/water_drop_outlined.png "Drizzle Icon") | It's drizzling outside|
| ![Rain Icon](/images/Icons/water_drop.png "Rain Icon") | It's raining outside|
| ![Snow Icon](/images/Icons/snowing.png "Snow Icon") | It's snowing outside|
| ![Thunder Icon](/images/Icons/electric_bolt.png "Thunder Icon") | There's a thunderstorm outside|
| ![Unknown Icon](/images/Icons/question_mark.png "Unkown Icon") | There was an error getting the weather conditions outside|

## Functional Requirements
| Functional Requirement | Usage |
| :--- | :--- |
| multiple screens and navigation | Navigation Bar which takes you to different pages, AppBar buttons which push different pages onto the screen |
| dialogs and pickers | Date picker in the Download Page, Time picker in the Notification Page |
| snackbars and notifications | Error messages, scheduled notification prompts, scheduled notifications |
| local storage | Downloaded weather forecasts are stored in local storage, last stored account is also automatically logged in (unless the user has logged out before closing the app) |
| cloud storage | The login information fetched and compared from Cloudbase, where all accounts are stored |
| data tables and charts | The charts and tables displayed in the More Page |
| maps | Choosing a location for Non Local Weather Forecasts uses a map |
| geolocation | Grabbing user location and updating weather information based on it |
| geocoding | Displaying the address the weather information is based on |
| internationalization | Celsius and Fahrenheit toggle, Change Languages in Settings

## Code Design
![Diagram](/images/Diagram/diagram.png "Diagram")
___

### Summative Assessment

The final phase of marking will be carried out at the end of the course.  This evaluation will be carried out more strictly, with higher expectations. In addition to your fully developed application, you will need to submit a technical report as a group effort, and each member will need to submit a ~5 minute demonstration video presentation of the app individually. This evaluation will be worth 50% of your final grade, divided into 30% (mobile application), 10% (group report), and 10% (individual demo). Students who do not submit any individual demo will receive a 0 for all parts of the summative assessment.

#### Functional requirements (5 marks total)

Max Score | Requirement
--------- | ----------- 
0.50 | multiple screens and navigation
0.25 | dialogs and pickers
0.50 | snackbars and notifications
0.75 | local storage
0.75 | cloud storage
0.50 | data tables and charts
0.50 | maps
0.50 | geolocation
0.25 | geocoding
0.50 | internationalization

#### Non-functional requirements (25 marks total)

Max Score | Requirement
--------- | ----------- 
5.00 | code and design quality
5.00 | user interface design and usability
15.00 | amount of work done

#### Technical Report (10 marks total)

Max Score | Requirement
--------- | ----------- 
1.00 | overview of project
1.00 | list of group members and their contributions
2.00 | code design (e.g. UML)
2.00 | user's guide (for non-developers)
2.00 | list of functional requirements and how/where they are used
2.00 | writing quality

#### Individual Demo (10 marks total)

Max Score | Requirement
--------- | ----------- 
5.00 | demonstration of application
5.00 | explanation and presentation of individual contribution to the project

## How to Submit
The project starter is available on GitHub Classroom, which really just has this README.md, since I want you to have freedom over this project.  There won’t be any starter code, you will start from scratch.  Accept the invite link for this project on GitHub Classroom, and use the new repository generated to store your project files.  This is setup as a group project, so one person can sign up, and others group members can also contribute to the project in that new repository.  

The markers will use this repository to download the latest version of your project, along with other information (e.g. commit logs) available through Git, when they want to mark the project.

_**Note:**  Only one of the group members will accept the GitHub Classroom invitation.  It is recommended that every member of the team verify the final repository on GitHub on submission day, so that everybody can be sure that the correct files were submitted and on time.  You should also clone the latest version into a fresh directory, and run it locally on your machine to ensure that it works without any unusual configuration._

_**Note:**  Work equity will be evaluated using the Git commit logs for your project.  If you decide to work together which results in a misrepresentation of work equity in the commit logs, be sure to mention this in your `README.md`. The instructor will handle all issues of uneven distribution of work on a case by case basis, which may involve adjustments to project grades as needed._

To submit this project, please push all your work to your repository, and add the names of all group members names (but not their SIDs) and their corresponding GitHub usernames (so we can tell who made which commits) to the `README.md` file (at the top).

_**Note:**  Any instances of plagiarism will result in the student(s) receiving a mark of zero for the project, and further disciplinary action will be taken.  Plagiarism includes, but is not limited to:_
- Copying of (any amount of) work from the Internet, without proper citation
- Submitting a body of work, cited or not, that is primarily not your own work
- Copying of (any amount of) work from another student, past or present, without proper citation
- Allowing your own work to be copied by a fellow student

## Getting Help
If you run into difficulty, you may wish to check out some of the following resources:

- https://api.flutter.dev/  - The standard documentation for Flutter, all classes and methods.
- https://dart.dev/tutorials - A series of tutorials for the Dart programming language, focusing entirely on the features of Dart.
- https://flutter.dev/docs/reference/tutorials - A series of tutorials for the Flutter platform, focusing mainly on the widgets and API.
- https://flutter.dev/docs/codelabs - A series of deep-dive, more comprehensive, tutorials to learn more about the Flutter platform.
- https://flutter.dev/docs/cookbook - A set of recipes for commonly used features of Flutter.
- https://github.com/flutter/samples/ - A repository containing some completed Flutter applications.
- http://stackoverflow.com/ - A forum for asking questions about programming.  I bet you know this one already!

Of course, you can always ask us for help!  However, learning how to find the answers out for yourself is not only more satisfying, but results in greater learning as well.

## How to Submit
Create your flutter project, and copy it into this folder, commit, and then push your code to this repository to submit your major group project.
