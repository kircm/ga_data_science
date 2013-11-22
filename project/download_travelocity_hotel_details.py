from helper_functions import *

import requests
import os

#############################################
# Extract travelocity hotel IDs from CSV file 
#############################################
travelocity_hotel_ids = extract_hotel_ids_from_database_data()

###########################################
# Download the hotel details for each hotel
###########################################
# We need to send a hotel availability request first, to generate session cookie
availability_request = "http://travel.travelocity.com/hotel/HotelAvailability.do?Service=TRAVELOCITY&SEQ=1375397882051712013&pathIndicator=HOTEL_FRONTDOOR&leavingDate=09/23/2013&returningDate=09/26/2013&state=NY&city=New%20York&cityCountryCode=US&dateFormat=mm/dd/yyyy&searchMode=city"
print "Sending availability request: " + availability_request
hotel_availability_request = requests.get(availability_request)
cookies = hotel_availability_request.cookies
hotel_availability_request.close()
print "Availability request performed correclty."
# We have the session cookies generated, loop through all the hotel ids and download the HTML for each hotel details page
output_dir = "./travelocity_hotel_details"
if not os.path.exists(output_dir):
    os.makedirs(output_dir)
for idx, val in enumerate(travelocity_hotel_ids):
	if (idx > 0):
		print "Sending hotel details request for hotel id: " + val
		hotel_details_request = requests.get("http://travel.travelocity.com/hotel/HotelDetailfeatures.do?propertyId=" + val + "&tab=features", cookies=cookies)
		hotel_details_file_name = output_dir + "/hotel_details." + val + ".downloaded.html"
		print "Saving to file: " + hotel_details_file_name
		output_file = open(hotel_details_file_name, 'w+')		
		output_file.write(hotel_details_request.content);
		hotel_details_request.close()
		output_file.close()
