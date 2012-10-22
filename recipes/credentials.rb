data_bag_key = Chef::EncryptedDataBagItem.load_secret(node['data_bag_key'])
secrets = Chef::EncryptedDataBagItem.load("secrets", node.chef_environment, data_bag_key)

def set_amqp_user_and_pass(attrib, secrets)
	if attrib and attrib.has_key? 'amqp'
		attrib['amqp']['user'] = secrets['logstash']['amqp']['user']
		attrib['amqp']['password'] = secrets['logstash']['amqp']['password']
	end
	return attrib
end

if node.role? 'logstash_server'
	node.logstash.server.inputs.each do |input|
		input = set_amqp_user_and_pass(input, secrets)
	end
elsif node.role? 'logstash_agent'
	node.logstash.agent.outputs.each do |output|
		output = set_amqp_user_and_pass(output, secrets)
	end
end
