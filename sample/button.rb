#
# by nodered2mruby code generator
#
injects = [{:id=>:n_1f502c97fb09e98c,
  :delay=>0.1,
  :repeat=>0.0,
  :payload=>"",
  :wires=>[:n_5aaadcbe41ab4979]}]
nodes = [{:id=>:n_5aaadcbe41ab4979,
  :type=>:button,
  :targetPort=>"0",
  :selectPull=>"1",
  :wires=>[:n_4776d6a17a4dadde]},
 {:id=>:n_4776d6a17a4dadde, :type=>:gpio, :targetPort=>0, :wires=>[]}]

# global variable
$gpioArray = {}       #number of pin
$pwmArray = {}
$pinstatus = {}
$i2cArray = {}

#
# class myindex
#
class Myindex
  def myindex(nodes, msg)
    i = 0

    while i < nodes.length
      if nodes[i][:id] == msg[:id]
        return i
      else
        i += 1
      end
    end
    return nil
  end
end

#
# class GPIO
#
=begin
class GPIO
  attr_accessor :pinNum

  def initialize(pinNum)
    @pinNum = pinNum
  end

  def write(value)
    puts "Writing #{value} to GPIO #{@pinNum}"
  end
end
=end

#
# node dependent implementation
#

# GPIO
def process_node_gpio(node, msg)
  targetPort = node[:targetPort]
  payLoad = msg[:payload]

  if $gpioArray[targetPort].nil?
    gpio = GPIO.new(targetPort)
    $gpioArray[targetPort] = gpio
    gpioValue = 0
    $pinstatus[targetPort] = 0
    puts "Setting up pinMode for pin #{targetPort}"
  else
    gpio = $gpioArray[targetPort]
    gpioValue = $pinstatus[targetPort]
    puts "Reusing pinMode for pin #{targetPort}"
  end

  if payLoad.nil?
    if gpioValue == 0
      gpio.write 1
      $pinstatus[targetPort] = 1
    elsif gpioValue == 1
      gpio.write 0
      $pinstatus[targetPort] = 0
    end
  else
    if gpioValue == 0
      gpio.write 1
      gpioValue = payLoad
    elsif gpioValue == payLoad
      gpio.write 0
      gpioValue = 0
    end
  end
end

# GPIO-Read
def process_node_gpioread(node, msg)
  puts "Processing GPIO read for node: #{node[:id]}"
  targetPort = node[:targetPortDigital]

  if $gpioArray[targetPort].nil?
    gpio = GPIO.new(targetPort)
    $gpioArray[targetPort] = gpio
    puts "Setting up pinMode for pin #{targetPort}"
  else
    gpio = $gpioArray[targetPort]
    puts "Reusing pinMode for pin #{targetPort}"
  end

  if gpio.nil?
    puts "No GPIO configured for pin #{gpio}"
  else
    gpioReadValue = gpio.read()
    puts "gpioReadVale = #{gpioReadValue}"

    msg[:payload] = gpioReadValue
    node[:wires].each do |nextNodeId|
    $queue << { id: nextNodeId, payload: gpioReadValue }
    end
    puts "gpioReadValue = #{gpioReadValue}"
  end
end

# ADC
def process_node_ADC(node, msg)
  pinNum = node[:targetPort_ADC]

  targetPort = case pinNum
               when "0" then 0
               when "1" then 1
               when "2" then 5
               when "3" then 6
               when "4" then 7
               when "5" then 8
               when "6" then 19
               when "7" then 20
               else
                nil
               end

  if targetPort.nil?
    puts "No GPIO configured for pin"
  end

  if $gpioArray[targetPort].nil?
    gpio = GPIO.new(targetPort)
    $gpioArray[targetPort] = gpio
    puts "Setting up pinMode for pin #{targetPort}"
  else
    gpio = $gpioArray[targetPort]
    puts "Reusing pinMode for pin #{targetPort}"
  end

  gpio.start
  adcValue = gpio.read_v
  gpio.stop

  if !adcValue.nil?
    msg[:payload] = adcValue
    node[:wires].each do |nextNodeId|
      $queue << { id: nextNodeId, payload: adcValue }
    end
  else
    puts "No GPIO configured for pin #{targetPort}"
  end
end

# GPIO-Write
def process_node_gpiowrite(node, msg)
  puts "Processing GPIO read for node: #{node[:id]}"
  targetPort = node[:targetPortDigital]
  payLoad = msg[:payload]
  gpioValue = 0

  if $gpioArray[targetPort].nil?
    gpio = GPIO.new(targetPort)
    $gpioArray[targetPort] = gpio
    puts "Setting up pinMode for pin #{targetPort}"
  else
    gpio = $gpioArray[targetPort]
    puts "Reusing pinMode for pin #{targetPort}"
  end

  if !payLoad.nil?
    if gpioValue == 0
      gpio.write 1
      gpioValue = payLoad
    elsif gpioValue == payLoad
      gpio.write 0
      gpioValue = 0
    end
  else
    puts "The value of payload is not set."
  end
end

# PWM
def process_node_PWM(node, msg)
  pwmNum = node[:PWM_num]
  cycle = node[:cycle].to_i      #蜻ｨ豕｢謨ｰ
  rate = msg[:payload].to_i      #duty豈・
  pinstatus = {}

  targetPort =  case pwmNum
                when "1" then 12
                when "2" then 16
                when "3" then nil
                when "4" then 18
                when "5" then 2
                else
                 nil
                end

  pwmChannel = pwmNum.to_i

  if $pwmArray[targetPort].nil?
    pwm = PWM.new(targetPort)
    $pwmArray[targetPort] = pwm
    puts "pwm start"
  else
    pwm = $pwmArray[targetPort]
    puts "pwm continue"
  end

  pwm.frequency(cycle)
  puts "cycle = #{cycle}"
  pwm.duty(rate)
  puts "rate = #{rate}"
end

# I2C
def process_node_I2C(node, msg)
  puts "Processing I2C for node: #{node[:id]}"

  slaveAddress = node[:ad].to_s
  rules = node[:rules]
  payLoad = msg[:payload]

  if $i2cArray[slaveAddress].nil?
    i2c = I2C.new(slaveAddress)
    $i2cArray[slaveAddress] = i2c
    puts "Setting up pinMode for pin #{i2c}"
  else
    i2c = $i2cArray[slaveAddress]
    puts "Reusing pinMode for pin #{i2c}"
  end

  rules.each do |rule|
    if rule[:t] == "W"
      puts "type W"
      i2c.write(slaveAddress, rule[:v], payLoad)
      puts "write 1"
    elsif rule[:t] == "R"
      puts "R"
      i2c.read(slaveAddress, rule[:b], rule[:v])
      puts "Read I2C(#{i2c})"
    end
  end
end

# Button
def process_node_Button(node, msg)
  puts "Button(Select Pull)"

  targetPort = node[:targetPort]
  selectPull = node[:selectPull]

  if $gpioArray[targetPort].nil?
    gpio = GPIO.new(targetPort)
    $gpioArray[targetPort] = gpio
    gpioValue = 0
    $pinstatus[targetPort] = 0
    puts "Setting up pinMode for pin #{targetPort}"
  else
    gpio = $gpioArray[targetPort]
    gpioValue = $pinstatus[targetPort]
    puts "Reusing pinMode for pin #{targetPort}"
  end

  if selectPull == "0"
    gpio.pull(0)
  elsif selectPull == "1"
    gpio.pull(1)
  elsif selectPull == "2"
    gpio.pull(-1)
  end
end

# Switch
def process_switch(node, msg)
  puts "node[:rules] = #{node[:rules]}"







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
  when :gpioread
    process_node_gpioread node, msg
  when :adc
    process_node_ADC node, msg
  when :gpiowrite
    process_node_gpiowrite node, msg
  when :pwm
    process_node_PWM node, msg
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
    indexer = Myindex.new()
    msg = $queue.first
    if msg then
      puts "$queue = #{$queue}"
      $queue.delete_at 0
      #idx = nodes.myindex { |v| v[:id] == msg[:id] }
      idx = indexer.myindex(nodes, msg)
      puts "node is #{nodes[idx]}"
      if idx then
        puts "Do #{nodes[idx]}"
        process_node nodes[idx], msg
        puts "-----------------------------------------------------------------------------------------"
      else
        puts "node not found: #{msg[:id]}"
      end
    end

  # next
  # puts "q=#{$queue}"
  sleep LoopInterval
end
