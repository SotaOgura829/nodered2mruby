#
# calss GPIO
#
class GPIO
  IN = "in"
  OUT = "out"

  #def initialize(type = nil, onboardled = nil, pin = nil, direction = nil)
  def initialize(gpioNum)
    @gpioNum = gpioNum
  end

  def write(value)
    if @type == "onBoardLED"
      puts "Writing #{value} to GPIO #{@onboardled}"
    elsif @type == "GPIO"
      puts "Writing #{value} to GPIO #{@pin} at #{@direction}"
    end
  end
end


#
# node dependent implementation
#

#gpio-node
$gpioNum = {}

def process_node_gpio(node, msg)
  puts "node=#{node}"
  gpioData = 0
  targetPort = node[:targetPort]
  payLoad = node[:payload]

  if($gpioNum[targetPort].nil?)
    $gpioNum[targetPort] = pinMode.new(targetPort)
    puts "Setting up pinMode for pin #{@gpioNum}"
  else
    puts "Reusing pinMode for pin #{@gpioNum}"
  end

  if($injects[payLoad].nil?) #payloadが空だった場合
    if(gpioData == 0)
      digitalWrite($gpioNum[:targetPort], 1)
      gpioData = 1
    elsif(gpioData == 1)
      digitalWrite($gpioNum[:targetPort], 0)
      gpioData = 0
    end
  end
  elsif($injects[payLoad].is_a?(Float)) #payloadに数値が入っていた場合（未完）
    gpioData = $injects[payLoad] #(gpioData = gpioData.new($injects[payLoad]))?
    pinMode(node[:targetPort], 0)
    #while true
      digitalWrite(node[:targetPort], 1)
      puts "Pin-LED Write 1"
      sleep(node[:repeat])
      digitalWrite(node[:targetPort], 0)
      puts "Pin-LED Write 0"
      sleep(node[:repeat])
  end
end

#
#  if($injects[node[:payload]].nil){
#    if(gpioData == 0){
#      digitalWrite(node[:targetPort])
#    }
#    pinMode(node[:targetPort], 0)
#    while true
#      digitalWrite(node[:targetPort], 1)
#      puts "Pin-LED Write 1"
#      sleep(node[:repeat])
#      digitalWrite(node[:targetPort], 0)
#      puts "Pin-LED Write 0"
#      sleep(node[:repeat])
#    end
#  }

  #if($gpioNum[node[:targetPort]].nil?)
  #  $gpioNum = pinMode.new(node[:targetPort])
    #puts "Setting up pinMode for pin #{@pin}"
  #else
   # $gpioNum = pinMode(node[:targetPort])
  #end

end

def process_node_gpioread(node, msg)
  gpioread[:wires].each { |node|
  msg = {:id => node,
         :GPIOType => gpioread[:GPIOType],
         :digital => gpioread[:targetPort_digital],
         :ADC => gpioread[:targetPort_ADC]

        }
  $queue << msg

}
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
  when :i2c
    process_node_i2c node, msg
  when :parameter
    process_node_parameter node, msg
  when :function_code
    process_node_function_code node, msg
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
