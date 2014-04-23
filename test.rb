require './bring_client'

bc = BringgClient.new({url: "http://localhost:3000",
                        auth_token: "AKgZe85aEdL4p88VWczj",
                        hmac_secret: "yVxx9LjC2P1sxkMEyPyP"})

customer = bc.create_customer({:scheduled_at=>DateTime.now.to_s,
					:note=>"{:order=>329}",
					:customer_id=>244,
					:lat=>41.9139368,
					:lng=>-87.6528562,
					:address=>"954 West Willow Street, Chicago, IL, 60614, US",
          :name => 'test'
					})
