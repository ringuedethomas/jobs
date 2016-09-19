require "json"
require 'date'

file = File.read('data.json')
data = JSON.parse(file)
# Store cars info into an array
carsData = Hash.new
data['cars'].each do |x|
	carsData[x['id']] = x
end
# Store rentals info into an array
rentalsData = Hash.new
data['rentals'].each do |x|
	rentalsData[x['id']] = x
end
output = Hash.new
results = Array.new
rentalsData.each do |index, rental|
	startDate = Date.parse(rental['start_date'])
	endDate = Date.parse(rental['end_date'])
	diff = endDate.mjd - startDate.mjd + 1
	timeCost = carsData[rental['car_id']]['price_per_day'] * diff
	distanceCost = carsData[rental['car_id']]['price_per_km'] * rentalsData[index]['distance']
	rentalPrice = timeCost + distanceCost
	item = Hash.new
	item['id'] = rental['id']
	item['price'] = rentalPrice
	results << item
end
output['rentals'] = results
puts JSON.generate(output)

