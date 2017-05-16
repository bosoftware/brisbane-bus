# Brisbane Bus

I implemented this IOS app few years ago and I don't have time to maintain this app anymore. I think it is good to open source it.

I have already unpublished this app from Apple Store. 

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

* **Bo Wang** - *Initial work* - [Bo Wang's Software](http://thebosoftware.com)
I am freelancer, if you want create a app like this, please contact me. 

## Screenshots
<img src="https://is1-ssl.mzstatic.com/image/thumb/Purple5/v4/ba/00/03/ba000363-ba15-4a63-f8db-b7aa0a3c389b/pr_source.png/0x0ss.jpg" width="400" height="500" />
<img src="https://is1-ssl.mzstatic.com/image/thumb/Purple7/v4/0c/a9/54/0ca954e5-908d-00ae-b0e1-3a5573828f98/pr_source.png/0x0ss.jpg" width="400" height="500" />
<img src="https://is1-ssl.mzstatic.com/image/thumb/Purple7/v4/19/12/4a/19124afa-a67f-31cf-ee36-4734580b2280/pr_source.png/0x0ss.jpg" width="400" height="500" />




##Thank you for your support.

<a href="https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=amos%2esoftware%40hotmail%2ecom&lc=AU&item_name=Bo%20Software&currency_code=AUD&bn=PP%2dDonationsBF%3abtn_donate_LG%2egif%3aNonHosted">Please click here to donate if you think this project is useful for you. Thanks.</a>
