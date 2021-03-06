require 'httparty'

# Populate the graph with some random points
points = []
(1..10).each do |i|
  points << { x: i, y: rand(0) }
end
last_x = points.last[:x]

SCHEDULER.every '10s' do
	result = HTTParty.get("http://api.altmetric.com/v1/citations/1d?num_results=1")
	if result['query']['page'] == 1
		out = 50
	else
		out = 0
	end

	points.shift
	last_x += 1
	points << { x: last_x, y: out }

	send_event('convergence', points: points)
end