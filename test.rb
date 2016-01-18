require './bringg_client.rb'
require 'pry'

bc = BringgClient.new({url: "http://localhost:3000",
                       auth_token: "oixxBF4ft6H55SbxcDsG",
+                      hmac_secret: "SBFgk3zrfDSW4tg2vK1r"})

merchant_id = <MERCHANT_ID>

res = bc.create_customer({:scheduled_at=>DateTime.now.to_s,
					:note=>"{:order=>329}",
					:customer_id=>244,
					:lat=>41.9139368,
					:lng=>-87.6528562,
					:address=>"954 West Willow Street, Chicago, IL, 60614, US",
          :name => 'test'
					})

customer = JSON.parse(res.body)["customer"]
puts "received customer: #{customer}"

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

merchant_configuration_res = bc.merchant_configuration(merchant_id, {
   :allow_take_payment=> true,
   :allow_take_signature => true,
   :auto_accept_tasks => true,
   :show_bringg_logo => false,
   :cancel_task_by_driver => false,
   :allow_access_to_all_open_tasks => true,
   :auto_dispatch => true,
   :merchant_configuration => {
     :show_bringg_logo => false,
     :allow_access_to_all_open_tasks => true,
     :auto_dispatch => true }
  })

binding.pry
puts merchant_configuration_res
puts res
# way_point = JSON.parse(res.body)["way_point"]
# puts "received way_point: #{way_point}"
