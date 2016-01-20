require './bringg_client.rb'
require 'pry'

bc = BringgClient.new({url: "https://developer-api.bringg.com/",
                       auth_token: "<YOUR AUTH TOKEN>",
                      hmac_secret: "<YOUR SECTET>"})

merchant_id = <YOUR COMPANY ID>

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

userRes = bc.create_user({
    :name => "Jhon Smith",
    :email => "jhon@smith.com",
    :phone => "+972545556666",
    :company_id => merchant_id,
    :password => "password"
  })
user = JSON.parse(userRes.body)

update_user_location = bc.update_user_location(user["id"], {:location_data =>  {:coords => { lat: 32.5434, lng:34.3423432}}})

puts user
puts update_user_location

puts merchant_configuration_res
puts res
way_point = JSON.parse(res.body)["way_point"]
puts "received way_point: #{way_point}"
