require "json"
require 'date'

def calculateDiscount(pricePerDay, nbrDays)
	newPricePerDays = pricePerDay
	timeCost = pricePerDay
	if (nbrDays > 1)
		discountDays = (nbrDays > 4) ? 3 : nbrDays - 1
		newPricePerDays = ((pricePerDay * 90) / 100)
		timeCost += discountDays * newPricePerDays
	end
	if (nbrDays > 4)
		discountDays = (nbrDays > 10) ? 6 : nbrDays - 4
		newPricePerDays = ((pricePerDay * 70) / 100)
		timeCost += discountDays * newPricePerDays
	end
	if (nbrDays > 10)
		discountDays = nbrDays - 10
		newPricePerDays = ((pricePerDay * 50) / 100)
		timeCost += discountDays * newPricePerDays
	end
	return timeCost
end

def calculateRentalsPrice(rentalsData, carsData)
	results = Array.new
	rentalsData.each do |index, rental|
		startDate = Date.parse(rental['start_date'])
		endDate = Date.parse(rental['end_date'])
		nbrDays = endDate.mjd - startDate.mjd + 1
		# puts nbrDays
		pricePerDay = carsData[rental['car_id']]['price_per_day']
		timeCost = calculateDiscount pricePerDay, nbrDays
		distanceCost = carsData[rental['car_id']]['price_per_km'] * rentalsData[index]['distance']
		rentalPrice = timeCost + distanceCost
		item = Hash.new
		item['id'] = rental['id']
		item['price'] = rentalPrice
		results << item
	end
	return results
end

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
results = calculateRentalsPrice rentalsData, carsData
output['rentals'] = results
puts JSON.generate(output)