data_bag_key = Chef::EncryptedDataBagItem.load_secret(node['data_bag_key'])
secrets = Chef::EncryptedDataBagItem.load("secrets", node.chef_environment, data_bag_key)

node.logstash.server.inputs.amqp.user = secrets['logstash']['amqp']['user']
node.logstash.server.inputs.amqp.password = secrets['logstash']['amqp']['password']

node.logstash.agent.outputs.amqp.user = secrets['logstash']['amqp']['user']
node.logstash.agent.outputs.amqp.password = secrets['logstash']['amqp']['password']