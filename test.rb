require './bring_client'
require 'pry'

bc = BringgClient.new({url: "http://localhost:3000",
                        auth_token: "AKgZe85aEdL4p88VWczj",
                        hmac_secret: "yVxx9LjC2P1sxkMEyPyP"})


res = bc.create_customer({:scheduled_at=>DateTime.now.to_s,
					:note=>"{:order=>329}",
					:customer_id=>244,
					:lat=>41.9139368,
					:lng=>-87.6528562,
					:address=>"954 West Willow Street, Chicago, IL, 60614, US",
          :name => 'test'
					})

customer = JSON.parse(res.body)["customer"]
# puts "received customer: #{customer}"

res = bc.create_task({:scheduled_at=>DateTime.now.to_s,
          :note=>"{:order=>329}",
          :customer_id=>customer["id"],
          :lat=>41.9139368,
          :lng=>-87.6528562,
          :address=>"954 West Willow Street, Chicago, IL, 60614, US",
          :name => 'test'
          })

task = JSON.parse(res.body)["task"]
# puts "received task: #{task}"


res = bc.add_waypoint(task["id"], {:scheduled_at=>DateTime.now.to_s,
          :note=>"{:order=>329}",
          :customer_id=>customer["id"],
          :lat=>41.9139368,
          :lng=>-87.6528562,
          :address=>"954 West Willow Street, Chicago, IL, 60614, US",
          })

          binding.pry

way_point = JSON.parse(res.body)["way_point"]
puts "received way_point: #{way_point}"
