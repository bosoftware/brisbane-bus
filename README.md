# Brisbane Bus

I implemented this IOS app few years ago and I don't have time to maintain this app anymore. I think it is good to open source it.

## Getting Started

1. To run this app, you have to get GTFS data from Brisbane government website.
2. Convert the GTFS data to mysql database.
3. Get the php file which is in the root folder of this repository.
4. Modify prefix.h to set the QUERY_URL to be your remote php url, you have to upload the php file to your cloud server or web server.

## How to open it in XCode
1. run pod install command
2. open SydneyTransit.xcworkspace (sorry about the name, I built Sydney IOS app first and then never change name for Brisbane app)

### Prerequisities
1. You mush understand GTFS file structure.
2. You know how to covert GTFS zip file to mysql database.
3. You need a cloud server or web server which is supporting php.

## Authors

* **Bo Wang** - *Initial work* - [Bo Wang's Software](https://thebosoftware.com)
I am freelancer, if you want create a app like this, please contact me. My rate is $70+GST per hour.

## Screenshots
## Screenshots
<img src="https://cloud.githubusercontent.com/assets/20594610/17173468/622c9296-543e-11e6-9dec-754cb1301893.png" width="400" height="500" />
<img src="https://cloud.githubusercontent.com/assets/20594610/17173467/6229f6c6-543e-11e6-98c3-e3de007d400d.png" width="400" height="500" />
<img src="https://cloud.githubusercontent.com/assets/20594610/17173466/62294cd0-543e-11e6-8aa6-f87204bac867.png" width="400" height="500" />




##Thank you for your support.

<a href="https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=amos%2esoftware%40hotmail%2ecom&lc=AU&item_name=Bo%20Software&currency_code=AUD&bn=PP%2dDonationsBF%3abtn_donate_LG%2egif%3aNonHosted">Please click here to donate if you think this project is useful for you. Thanks.</a>
