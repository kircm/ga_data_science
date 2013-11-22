#########
# Imports
#########
import json
import csv
from numpy import where
from numpy import array
from glob import glob
from HTMLParser import HTMLParser
from scipy import sparse as sparse



###################
# Helper functions
###################

# Load several JSON files into one array of dictionaries
def load_json_data_from_files(file_name_pattern):
	return_data = []
	for file_name in glob(file_name_pattern):
		#print "Processing file: " + file_name
		input_file = open(file_name)
		lines = [line.strip() for line in input_file]
		for line in lines:
			return_data.append(json.loads(line))
		input_file.close()
	return return_data

# Extract travelocity hotel IDs from CSV file 
def extract_hotel_ids_from_database_data():
	travelocity_hotel_ids_file_name = './travelocity_hotels/travelocity_new_york_hotels.csv'
	travelocity_hotel_ids = []
	with open(travelocity_hotel_ids_file_name, 'rb') as travelocity_hotels_csv:
		hotel_reader = csv.reader(travelocity_hotels_csv, delimiter=',', quotechar='"')
		for row in hotel_reader:
			travelocity_hotel_ids.append(row[21])
	return travelocity_hotel_ids

# Remove features from data dictionary
def remove_features(dict, features):
	for el in dict:
		for feature in features:
			del el[feature]

# To strip HTML tags
class MLStripper(HTMLParser):
    def __init__(self):
        self.reset()
        self.fed = []
    def handle_data(self, d):
        self.fed.append(d)
    def get_data(self):
        return ''.join(self.fed)

def strip_tags(html):
    s = MLStripper()
    s.feed(html)
    return s.get_data()


# To extract hotel amenities from a downloaded HTML page
def extract_amenities_text_from_html(html_text):
	start_amenities = '<div class="amenities">'
	end_amenities = '<div class="clear">'
	if start_amenities == -1:
		return ''
	html_text_amenities = html_text[html_text.find(start_amenities):]
	html_text_amenities = html_text_amenities[:html_text_amenities.find(end_amenities)]
	return html_text_amenities

# Load text data containing amenities for a specific hotel
def load_hotel_amenities_data_for_hotel(hotel_id):	
	try:
		with open("./travelocity_hotel_details/hotel_details." + str(hotel_id) + ".downloaded.html", "r") as myfile:
			hotel_details_text_data = myfile.read().replace('\n', '')
		hotel_amenities_text_data = strip_tags(extract_amenities_text_from_html(hotel_details_text_data))
	except:
		hotel_amenities_text_data = ''
	return hotel_amenities_text_data

# Generate a dictionary of hotel details data indexed by hotel id
def generate_hotel_amenities_data_dict(hotel_ids):
	hotel_amenities_data = {}
	for hotel_id in hotel_ids:
		hotel_amenities_data[hotel_id] = load_hotel_amenities_data_for_hotel(hotel_id)
	return hotel_amenities_data

# Generate all amenities data concatenated
def generate_hotel_amenities_data(hotel_ids):
	hotel_amenities_data = ''
	for hotel_id in hotel_ids:
		hotel_amenities_data = hotel_amenities_data + load_hotel_amenities_data_for_hotel(hotel_id) + " "
	return hotel_amenities_data

# Add amenities to hotels
def add_hotel_amenities_as_features(training_data, hotel_amenities_dict, amenities):
	for el in training_data:
		hotel_details_text = hotel_amenities_dict.get(el['hotel_id'], '')
		el['size_of_amenities_text'] = len(hotel_details_text)
		for amenity in amenities:
			amenity_key = 'has_' + amenity
			if hotel_details_text.find(amenity) == -1:
				el[amenity_key] = 'n'
			else:
				el[amenity_key] = 'y'

