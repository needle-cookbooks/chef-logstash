data_bag_key = Chef::EncryptedDataBagItem.load_secret(node['data_bag_key'])
secrets = Chef::EncryptedDataBagItem.load("secrets", node.chef_environment, data_bag_key)

node.logstash.server.inputs.each do |input|
	input.amqp = secrets['logstash']['amqp']	
end

node.logstash.server.outputs.each do |output|
	output.amqp = secrets['logstash']['amqp']
end
	