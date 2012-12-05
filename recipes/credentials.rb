data_bag_key = Chef::EncryptedDataBagItem.load_secret(node['data_bag_key'])
secrets = Chef::EncryptedDataBagItem.load("secrets", node.chef_environment, data_bag_key)

def set_rabbitmq_user_and_pass(attrib, secrets)
	if attrib and attrib.has_key? 'rabbitmq'
		attrib['rabbitmq']['user'] = secrets['logstash']['rabbitmq']['user']
		attrib['rabbitmq']['password'] = secrets['logstash']['rabbitmq']['password']
	end
	return attrib
end

if node.roles.include? 'logstash_server'
	node.logstash.server.inputs.each do |input|
		input = set_amqp_user_and_pass(input, secrets)
	end
elsif node.roles.include? 'logstash_beaver'
	node.logstash.beaver.outputs.each do |output|
		output = set_amqp_user_and_pass(output, secrets)
	end
end
