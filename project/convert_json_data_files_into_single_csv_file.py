from helper_functions import *

input_files = 'data_files/tvly_ny_ad_calls_impressions_clicks_2013/*'
output_file = 'all_data.csv'

print "Loading data from files: " + input_files
all_data = load_json_data_from_files(input_files)

print "Converting data and writing to: " + output_file
output_file = open(output_file, 'w+')
output_file.write('travelers,rooms,is_weekday,advance_purchase_range_type,os_family,browser_family,star_rating,ad_copy_includes_promotion,ad_copy_includes_discount,ad_copy_includes_free,hotel_id,click_actual_cpc,was_clicked');
output_file.write('\n')

for data_example in all_data:
	line = ''
	line += str(data_example.get('travelers')) + ','
	line += str(data_example.get('rooms')) + ','
	line += str(data_example.get('is_weekday')) + ','
	line += str(data_example.get('advance_purchase_range_type')) + ','
	line += str(data_example.get('os_family')) + ','
	line += str(data_example.get('browser_family')) + ','
	line += str(data_example.get('star_rating')) + ','
	line += str(data_example.get('ad_copy_includes_promotion')) + ','
	line += str(data_example.get('ad_copy_includes_discount')) + ','
	line += str(data_example.get('ad_copy_includes_free')) + ','
	line += str(data_example.get('hotel_id')) + ','
	line += str(data_example.get('click_actual_cpc')) + ','
	line += str(data_example.get('was_clicked'))
	output_file.write(line)
	output_file.write('\n')

output_file.close()
print "Done."
