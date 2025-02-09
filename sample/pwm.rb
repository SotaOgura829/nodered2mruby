#
# by nodered2mruby code generator
#
injects = [{:id=>:n_429ea1649b59e534,
  :delay=>0.1,
  :repeat=>0.0,
  :payload=>"",
  :wires=>[:n_e283765615779883]}]
nodes = [{:id=>:n_e283765615779883,
  :type=>:pwm,
  :targetPort_PWM=>"12",
  :cycle=>"0.00009999999999999999",
  :rate=>"10",
  :wires=>[:n_1a09c2de89a90a6d]},
 {:id=>:n_1a09c2de89a90a6d, :type=>:debug, :wires=>[]}]

# global variable
$gpioNum = {}       #number of pin
$gpioValue = 0      #value for gpio
$payLoad = 0        #value of payload in inject-node

#
# calss GPIO
#
=begin
class GPIO
  attr_accessor :pinNum

  def initialize(pinNum)
    @pinNum = pinNum
  end

  def write(value)
    puts "Writing #{value} to GPIO #{@pinNum}, Out by #{$gpioValue}"
    puts "$payLoad = #{$payLoad}, $gpioValue = #{$gpioValue}"
  end
end
=end

#
# node dependent implementation
#

#gpio-node
def process_node_gpio(node, msg)
  targetPort = node[:targetPort]
  $payLoad = msg[:payload]

  if $gpioArray[targetPort].nil? || !($gpioArray.key?(targetPort))
    $gpio = GPIO.new(targetPort)
    $gpioArray[$targetPort] = { gpio: $gpio, value: $gpioValue }
    puts "Setting up pinMode for pin #{$gpioArray[$targetPort][:gpio]}"
  else
    $gpio = $gpioArray[$targetPort][:gpio]
    $gpioValue = $gpioArray[$targetPort][:value]
    puts "------------------------------------------------------------------------"
    puts "Reusing pinMode for pin #{$gpioArray[$targetPort][:gpio]}"
  end

  # 迴ｾ蝨ｨ縺ｮ繝斐Φ縺ｮ迥ｶ諷九ｒ繝・ヰ繝・げ蜃ｺ蜉・
  puts "Current pin state before payload check, $gpioValue: #{$gpioValue}, $gpioArray[$targetPort][:value]: #{$gpioArray[$targetPort][:value]}"

  if $payLoad == ""
    if $gpioArray[$targetPort][:value] == 0
      $gpioArray[$targetPort][:value] = 1
      $gpioValue = $gpioArray[$targetPort][:value]
      puts "Setting $gpioValue to 1"
      $gpio.write(1)
    else
      $gpioArray[$targetPort][:value] = 0
      $gpioValue = $gpioArray[$targetPort][:value]
      puts "Setting $gpioValue to 0"
      $gpio.write(0)
    end
  else
    if $gpioArray[$targetPort][:value] == 0
      $gpio.write(1)
      $gpioArray[$targetPort][:value] = $payLoad
      $gpioValue = $payLoad
      puts "Setting $gpioValue to #{$payLoad}"
    elsif $gpioArray[$targetPort][:value] == $payLoad
      $gpio.write(0)
      $gpioArray[$targetPort][:value] = 0
      $gpioValue = 0
      puts "Setting $gpioValue to 0"
    end
  end
end

def process_node_gpioread(node, msg)
  puts "Processing GPIO read for node: #{node[:id]}"
  gpioReadType = node[:readtype]
  targetPortDigital = node[:targetPortDigital]
  targetPortADC = node[:targetPort_ADC]

  if gpioReadType == "digital_read"
    if $gpioArray.nil? || !($gpioArray[targetPort].key?(targetPortDigital))
      gpioReadPin = GPIO.new(targetPortDigital)
      $gpioArray[targetPort][:gpio] = gpioReadPin
    else
      gpioReadPin = $gpioArray[targetPort][:gpio]
    end

    gpioReadValue = digitalRead(targetPortDigital)

    msg[:payload] = gpioReadValue
    node[:wires].each do |nextNodeId|
    $queue << { id: nextNodeId, payload: gpioReadValue }
    end
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
  when :pwm
    process_node_pwm node, msg
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
