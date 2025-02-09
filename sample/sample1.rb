#
# by nodered2mruby code generator
#
injects = [{:id=>:n_934017e3524b2bdd,
  :delay=>1.0,
  :repeat=>2.0,
  :payload=>"",
  :wires=>[:n_4ae12f0c5c520655]}]
nodes = [{:id=>:n_4ae12f0c5c520655, :type=>:gpio, :targetPort=>0, :wires=>[]}]

# global variable
$gpioNum = {}       #number of pin
gpioValue = 0       #value for gpio
$payLoad = 0        #value of payload in inject-node
$gpioArray[targetPort] = {:gpio => gpio, :value => gpioValue}

#
# node dependent implementation
#

#gpio-node
def process_node_gpio(node, msg)
  targetPort = node[:targetPort]
  $payLoad = msg[:payload]

  if $gpioArray[targetPort].nil? || !($gpioArray.key?(targetPort))
    gpio = GPIO.new(targetPort)
    $gpioArray[targetPort] = { gpio: gpio, value: 0}
    puts "Setting up pinMode for pin #{$gpioArray[targetPort][:gpio]}"
  else
    gpio = $gpioArray[targetPort][:gpio]
    puts "------------------------------------------------------------------------"
    puts "Reusing pinMode for pin #{$gpioArray[targetPort][:gpio]}"
    puts "$payLoad = #{$payLoad}, $gpioValue = #{$gpioArray[targetPort][:value]}"
  end


  if $payLoad == ""
    if $gpioArray[targetPort][:value] == 0
      $gpioArray[targetPort][:value] = 1
      puts "$gpioArray[targetPort][:gpio] = #{$gpioArray[targetPort][:gpio]}"
      puts "$gpioArray[targetPort][:value] = #{$gpioArray[targetPort][:value]}"
      gpio.write 1
    else
      $gpioArray[targetPort][:value] = 0
      puts "$gpioArray[targetPort][:gpio] = #{$gpioArray[targetPort][:gpio]}"
      puts "$gpioArray[targetPort][:value] = #{$gpioArray[targetPort][:value]}"
      gpio.write 0
    end
  else                                            # payload!=nil
    if $gpioArray[targetPort][:value] == 0
      gpio.write 1
      $gpioArray[targetPort][:value] = $payLoad
    elsif $gpioArray[targetPort][:value] == $payLoad
      gpio.write 0
      $gpioArray[targetPort][:value] = 0
    end
  end
end

def process_node_gpioread(node, msg)
  puts "Processing GPIO read for node: #{node[:id]}"
  gpioReadType = node[:readtype]
  targetPortDigital = node[:targetPortDigital]

  if gpioReadType == "digital_read"
    if $gpioArray.nil? || !($gpioArray[targetPort].key?(targetPortDigital))
      gpioReadPin = GPIO.new(targetPortDigital)
      $gpioArray[targetPort][:gpio] = gpioReadPin
    else
      gpioReadPin = $gpioArray[targetPort][:gpio]
    end

    gpioReadValue = digitalRead(targetPortDigital)

    if gpioReadValue.nil?
      msg[:payload] = gpioReadValue
      node[:wires].each do |nextNodeId|
      $queue << { id: nextNodeId, payload: gpioReadValue }
    else
      puts "No GPIO configured for pin #{targetPortDigital}"
    end

  if gpioReadType == "ADC"
    if $gpioArray.nil? || !($gpioArray[targetPort].key?(targetPortDigital))
      gpioReadPin = GPIO.new(targetPortDigital)
      $gpioArray[targetPort][:gpio] = gpioReadPin
    else
      gpioReadPin = $gpioArray[targetPort][:gpio]
    end

    gpioReadPin.start
    gpioReadValue = gpioReadPin.read_v
    gpioreadPin.stop

    if gpioReadValue.nil?
      msg[:payload] = gpioReadValue
      node[:wires].each do |nextNodeId|
      $queue << { id: nextNodeId, payload: gpioReadValue }
    else
      puts "No GPIO configured for pin #{targetPortDigital}"
    end
end


def process_node_gpiowrite(node, msg)
  gpiowrite[:wires].each { |node|
  msg = {:WriteType => gpiowrite[:WriteType],
        :GPIOType => gpiowrite[:GPIOType],
        :targetPort_digital => gpiowrite[:targetPort_digital],
        :targetPort_mode => gpiowrite[:targetPort_mode],
        :targetPort_PWM => gpiowrite[:targetPort_PWM],
        :PWM_num => gpiowrite[:PWM_num],
        :cycle => gpiowrite[:cycle],
        :double => gpiowrite[:doube],
        :time => gpiowrite[:time],
        :rate => gpiowrite[:rate]
        }
  $queue << msg
}
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
#  when :debug
#    puts msg[:payload]
  when :gpio
    process_node_gpio node, msg
  when :gpioread
    process_node_gpioread node, msg
  when :gpiowrite
    process_node_gpiowrite node, msg
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
    if injects[idx][:cnt] == 0 then
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
