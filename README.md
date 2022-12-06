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
**All weather information is fetched from the [Open Meteo Weather Forecast API](https://open-meteo.com/en/docs#api-documentation)**<br>
**NOTE:** Make sure your phone is running android api 30<br>
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
Here the more page shows you the more in depth weather information not displayed on the home page

![More Page Screenshot](/images/Screenshots/more_page_1.png "More Page Screenshot")

You can also view the charts and tables for the next 7 days by clicking on any of these options and scrolling through the table or chart

![Chart and Table Instructions Screenshot](/images/Screenshots/more_page_2.png "Chart and Table Instructions Screenshot")
![Chart and Table Screenshot](/images/Screenshots/more_page_3.png "Chart and Table Screenshot")

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
