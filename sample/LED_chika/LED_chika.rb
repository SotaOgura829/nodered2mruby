# GPIO-Read is not supported, {:id=>"d7c616210fab3361", :type=>"GPIO-Read", :z=>"f6f2187d.f17ca8", :name=>"", :ReadType=>"digital_read", :GPIOType=>"read", :targetPort_digital=>"1", :targetPort_ADC=>"", :x=>350, :y=>500, :wires=>[["dfcbf0b678bbc564"]]}
# switch is not supported, {:id=>"dfcbf0b678bbc564", :type=>"switch", :z=>"f6f2187d.f17ca8", :name=>"", :property=>"payload", :propertyType=>"msg", :rules=>[{:t=>"eq", :v=>"1", :vt=>"str"}], :checkall=>"true", :repair=>false, :outputs=>1, :x=>510, :y=>500, :wires=>[["cded069052955602"]]}
#
# by nodered2mruby code generator
#
injects = [{:id=>:n_fe95cee2738fe3ee,
  :delay=>0.0,
  :repeat=>1.0,
  :payload=>"",
  :wires=>[:n_d7c616210fab3361]}]
nodes = [{:id=>:n_cded069052955602,
  :type=>:gpio,
  :targetPort=>"1",
  :targetPort_mode=>"1",
  :wires=>[]}]

#
# node dependent implementation
#
def process_node_gpio(node, msg)
  puts "node=#{node}"
end


#
# inject 
#
def process_inject(inject)
  inject[:wires].each { |node|
    msg = {:id => node, :payload => inject[:payload]}
    $queue << msg
  }
end

#
# node
#
def process_node(node,msg)
  case node[:type]
  when :debug
    puts msg[:payload]
  when :switch
    process_node_switch node, msg
  when :gpio
    process_node_gpio node, msg
  when :constant
    process_node_constant node, msg
  when :gpioread
    process_node_gpioread node, msg
  when :gpiowrite
    process_node_gpiowrite node, msg  
  when :parameter
    process_node_parameter node, msg
  else
    puts "#{node[:type]} is not supported"
  end
end


injects = injects.map { |inject|
  inject[:cnt] = inject[:repeat]
  inject
}

LoopInterval = 0.05

$queue = []

#process node
while true do
  # process inject
  injects.each_index { |idx|
    injects[idx][:cnt] -= LoopInterval
    if injects[idx][:cnt] < 0 then
      injects[idx][:cnt] = injects[idx][:repeat]
      process_inject injects[idx]
    end
  }
  
  # process queue
  msg = $queue.first
  if msg then
    $queue.delete_at 0
    idx = nodes.index { |v| v[:id]==msg[:id] }
    if idx then
      process_node nodes[idx], msg
    end
  end

  # next
  # puts "q=#{$queue}"
  sleep LoopInterval
end

