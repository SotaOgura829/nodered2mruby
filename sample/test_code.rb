#
# by nodered2mruby code generator
#
#gpioread,debug
=begin
  injects = [{:id=>:n_cc11ec3ebd2a8a9a,
    :delay=>0.1,
    :repeat=>0.0,
    :payload=>"",
    :wires=>[:n_ef93352024ba732a]}]
  nodes = [{:id=>:n_ef93352024ba732a,
    :type=>:gpioread,
    :readtype=>nil,
    :targetPortDigital=>0,
    :wires=>[:n_066354c3d4ea9ea7]},
  {:id=>:n_066354c3d4ea9ea7, :type=>:debug, :wires=>[]}]
=end

#gpio,gpioread
=begin
  injects = [{:id=>:n_cc11ec3ebd2a8a9a,
    :delay=>0.1,
    :repeat=>1.0,
    :payload=>"",
    :wires=>[:n_ef93352024ba732a]}]
  nodes = [{:id=>:n_ef93352024ba732a,
    :type=>:gpioread,
    :readtype=>nil,
    :targetPortDigital=>0,
    :wires=>[:n_8fb0d4f3e09846f1]},
  {:id=>:n_8fb0d4f3e09846f1, :type=>:gpio, :targetPort=>0, :wires=>[]}]
=end

#gpiowrite
=begin
  injects = [{:id=>:n_934017e3524b2bdd,
    :delay=>1.0,
    :repeat=>2.0,
    :payload=>"1",
    :wires=>[:n_3e957c385a6dee4a]}]
  nodes = [{:id=>:n_3e957c385a6dee4a,
    :type=>:gpiowrite,
    :WriteType=>"digital_write",
    :targetPort_digital=>0,
    :wires=>[]}]
=end

#gpio
#nodes = [{:id=>:n_4ae12f0c5c520655, :type=>:gpio, :targetPort=>0, :wires=>[]}]
#=end

#PWM,gpio
=begin
  injects = [{:id=>:n_934017e3524b2bdd,
    :delay=>1.0,
    :repeat=>2.0,
    :payload=>"100",
    :wires=>[:n_4ae12f0c5c520655, :n_c591d9e6ba71344e]}]
  nodes = [{:id=>:n_4ae12f0c5c520655, :type=>:gpio, :targetPort=>0, :wires=>[]},
  {:id=>:n_c591d9e6ba71344e,
    :type=>:pwm,
    :PWM_num=>"1",
    :cycle=>"",
    :rate=>"",
    :wires=>[]}]
=end

#inject,inject,pwm
=begin
  injects = [{:id=>:n_934017e3524b2bdd,
    :delay=>0.0,
    :repeat=>2.0,
    :payload=>"0",
    :wires=>[:n_c591d9e6ba71344e]},
  {:id=>:n_0b25d509b04f9cc0,
    :delay=>1.0,
    :repeat=>2.0,
    :payload=>"1000",
    :wires=>[:n_c591d9e6ba71344e]}]
  nodes = [{:id=>:n_c591d9e6ba71344e,
    :type=>:pwm,
    :PWM_num=>"1",
    :cycle=>"440",
    :rate=>"",
    :wires=>[]}]
=end

#inject,inject,switch,debug
#=begin
injects = [{:id=>:n_653d0fe397da8616,
  :delay=>0.0,
  :repeat=>2.0,
  :payload=>"0",
  :wires=>[:n_0ce63751f6dafe70]}]
nodes = [{:id=>:n_adb474f55de28618, :type=>:debug, :wires=>[]},
 {:id=>:n_0ce63751f6dafe70,
  :type=>:switch,
  :property=>"payload",
  :propertyType=>"msg",
  :rules=>
   [{:t=>"neq", :v=>"1", :vt=>"str", :v2=>"1", :v2t=>"str", :case=>nil},
    {:t=>"lt", :v=>"1", :vt=>"str", :v2=>"1", :v2t=>"str", :case=>nil}],
  :checkall=>"true",
  :repair=>false,
  :wires=>[:n_adb474f55de28618, :n_cd50c8bc6e5be137]},
 {:id=>:n_cd50c8bc6e5be137, :type=>:debug, :wires=>[]}]
#=end

#inject,i2c,debug
=begin
  injects = [{:id=>:n_429ea1649b59e534,
    :delay=>0.1,
    :repeat=>2.0,
    :payload=>"",
    :wires=>[:n_f46a0a4bf79cd652]}]
  nodes = [{:id=>:n_1a09c2de89a90a6d, :type=>:debug, :wires=>[]},
  {:id=>:n_f46a0a4bf79cd652,
    :type=>:i2c,
    :ad=>"0x8",
    :rules=>[{:t=>"R", :v=>"re", :c=>nil, :b=>"1", :de=>"50"}],
    :wires=>[:n_1a09c2de89a90a6d]}]
=end

#inject,gpio
=begin
injects = [{:id=>:n_3742d56df02800bf,
    :delay=>0.1,
    :repeat=>1.0,
    :payload=>"",
    :wires=>[:n_02da4a1ad49fe114]}]
nodes = [{:id=>:n_02da4a1ad49fe114, :type=>:gpio, :targetPort=>0, :wires=>[]}]
=end


# global variable
$gpioArray = {}
$pwmArray = {}
$pinstatus = {}
$i2cArray = {}

# Myindex class
#=begin
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

#GPIO Class
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
  puts "Do LED : #{node}"
  targetPort = node[:targetPort]
  payLoad = msg[:payload]

  if $gpioArray[targetPort].nil?
    gpio = GPIO.new(targetPort)
    $gpioArray[targetPort] = gpio
    gpioValue = 0
    $pinstatus[targetPort] = 0
    puts "Setting up pinMode for pin #{gpio}"
  else
    gpio = $gpioArray[targetPort]
    gpioValue = $pinstatus[targetPort]
    puts "Reusing pinMode for pin #{gpio}"
  end

  # 現在のピンの状態をデバッグ出力
  puts "Current pin state before payload check, gpioValue: #{gpioValue}"

  if payLoad == ""
    if gpioValue == 0
      gpio.write(1)
      $pinstatus[targetPort] = 1
      puts "Setting gpioValue to 1"
    else
      gpio.write(0)
      $pinstatus[targetPort] = 0
      puts "Setting gpioValue to 0"
    end
  else
    if gpioValue != payLoad
      gpio.write(1)
      $pinstatus[targetPort] = payLoad
      puts "Setting gpioValue(payload) to #{payLoad}"
    elsif gpioValue == payLoad
      gpio.write(0)
      $pinstatus[targetPort] = nil
      puts "Setting gpioValue(payload) to 0"
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
    puts "Setting up pinMode for pin #{gpio}"
  else
    gpio = $gpioArray[targetPort]
    puts "Reusing pinMode for pin #{gpio}"
  end

  if gpio.nil?
    puts "No GPIO configured for pin #{gpio}"
  else
    gpioReadValue = gpio.read()
    puts "gpioReadVale = #{gpioReadValue}"

    node[:wires].each do |nextNodeId|
      msg = { id: nextNodeId, payload: gpioReadValue }
      $queue << msg
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

  if adcValue.nil?
    puts "No GPIO configured for pin #{targetPort}"
  else
    msg[:payload] = adcValue
    node[:wires].each do |nextNodeId|
      msg = { id: nextNodeId, payload: adcValue }
      $queue << msg
    end
  end
end

# GPIO-Write
def process_node_gpiowrite(node, msg)
  puts "Processing GPIO read for node: #{node[:id]}"
  targetPort = node[:targetPort_digital]
  payLoad = msg[:payload]

  if $gpioArray[targetPort].nil?
    gpio = GPIO.new(targetPort)
    $gpioArray[targetPort] = gpio
    gpioValue = nil
    $pinstatus[targetPort] = nil
    puts "Setting up pinMode for pin #{targetPort}"
  else
    gpio = $gpioArray[targetPort]
    gpioValue = $pinstatus[targetPort]
    puts "Reusing pinMode for pin #{targetPort}"
  end

  if payLoad != ""
    if gpioValue != payLoad
      gpio.write(1)
      $pinstatus[targetPort] = payLoad
    elsif gpioValue == payLoad
      gpio.write(0)
      $pinstatus[targetPort] = nil
    end
  else
    puts "The value of payload is not set."
  end
end

# PWM
def process_node_PWM(node, msg)
  pwmNum = node[:PWM_num]
  cycle = node[:cycle].to_i      #周波数
  rate = msg[:payload].to_i      #inject.payloadで設定
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

#Switch
def process_node_switch(node, msg)
  puts "node[:rules] = #{node[:rules]}"

  rules = node[:rules]
  payLoad = msg[:payload]


  rules.each_with_index do |rule, index|
    value = rule[:v]
    value2 = rule[:v2]
    switchCase = rule[:case]

    case rule[:t]
      when "eq"            # ==
        if payLoad == value
          puts "nextNode = #{node[:wires][index]}, index = #{index}"
          msg = { id: node[:wires][index], payload: payLoad }
          puts "msg = #{msg}"
        end
      when "neq"           # !=
        if payLoad != value
          puts "nextNode = #{node[:wires][index]}, index = #{index}"
          msg = { id: node[:wires][index], payload: payLoad }
          puts "msg = #{msg}"
        end
      when "lt"            # <
        if payLoad > value
          puts "nextNode = #{node[:wires][index]}, index = #{index}"
          msg = { id: node[:wires][index], payload: payLoad }
          puts "msg = #{msg}"
        end
      when "lte"           # <=
        if payLoad >= value
          puts "nextNode = #{node[:wires][index]}, index = #{index}"
          msg = { id: node[:wires][index], payload: payLoad }
          puts "msg = #{msg}"
        end
      when "gt"            # >
        if payLoad < value
          puts "nextNode = #{node[:wires][index]}, index = #{index}"
          msg = { id: node[:wires][index], payload: payLoad }
          puts "msg = #{msg}"
        end
      when "gte"           # >=
        if payLoad <= value
          puts "nextNode = #{node[:wires][index]}, index = #{index}"
          msg = { id: node[:wires][index], payload: payLoad }
          puts "msg = #{msg}"
        end
      when "hask"          # キーを含む
        if payLoad.key?(value)
          puts "nextNode = #{node[:wires][index]}, index = #{index}"
          msg = { id: node[:wires][index], payload: payLoad }
          puts "msg = #{msg}"
        end
      when "btwn"          # 範囲内である
        if payLoad >= value && payLoad <= value2
          puts "nextNode = #{node[:wires][index]}, index = #{index}"
          msg = { id: node[:wires][index], payload: payLoad }
          puts "msg = #{msg}"
        end
      when "cont"          # 要素に含む
        if payLoad == true
          puts "nextNode = #{node[:wires][index]}, index = #{index}"
          msg = { id: node[:wires][index], payload: payLoad }
          puts "msg = #{msg}"
        end
      when "regex"         # 正規表現にマッチ
        if payLoad =~ value
          puts "nextNode = #{node[:wires][index]}, index = #{index}"
          msg = { id: node[:wires][index], payload: payLoad }
          puts "msg = #{msg}"
        end
      when "true"          # trueである
        if payLoad == true
          puts "nextNode = #{node[:wires][index]}, index = #{index}"
          msg = { id: node[:wires][index], payload: payLoad }
          puts "msg = #{msg}"
        end
      when "false"         # falseである
        if payLoad == false
          puts "nextNode = #{node[:wires][index]}, index = #{index}"
          msg = { id: node[:wires][index], payload: payLoad }
          puts "msg = #{msg}"
        end
      when "null"          # nullである
        if payLoad.nil?
          puts "nextNode = #{node[:wires][index]}, index = #{index}"
          msg = { id: node[:wires][index], payload: payLoad }
          puts "msg = #{msg}"
        end
      when "nnull"         # nullでない
        if !payLoad.nil?
          puts "nextNode = #{node[:wires][index]}, index = #{index}"
          msg = { id: node[:wires][index], payload: payLoad }
          puts "msg = #{msg}"
        end
      when "istype"        # 指定型
        if payLoad.class == value
          puts "nextNode = #{node[:wires][index]}, index = #{index}"
          msg = { id: node[:wires][index], payload: payLoad }
          puts "msg = #{msg}"
        end
      when "empty"         # 空である
        if payLoad.empty
          puts "nextNode = #{node[:wires][index]}, index = #{index}"
          msg = { id: node[:wires][index], payload: payLoad }
          puts "msg = #{msg}"
        end
      when "nempty"        # 空でない
        if !payLoad.empty
          puts "nextNode = #{node[:wires][index]}, index = #{index}"
          msg = { id: node[:wires][index], payload: payLoad }
          puts "msg = #{msg}"
        end
      when "head"          # 先頭要素である
          puts "nextNode = #{node[:wires][index]}, index = #{index}"
          msg = { id: node[:wires][index], payload: payLoad.first }
          puts "msg = #{msg}"
      when "index"         # indexの範囲内である
        if payLoad.size >= value.to_i && payLoad.size <= value2.to_i
          puts "nextNode = #{node[:wires][index]}, index = #{index}"
          msg = { id: node[:wires][index], payload: payLoad }
          puts "msg = #{msg}"
        end
      when "tail"          # 末尾要素である
        puts "nextNode = #{node[:wires][index]}, index = #{index}"
        msg = { id: node[:wires][index], payload: payLoad.last }
        puts "msg = #{msg}"
      when "jsonata_exp"   # JSONata式
        if payLoad.class == value
          puts "nextNode = #{node[:wires][index]}, index = #{index}"
          msg = { id: node[:wires][index], payload: payLoad }
          puts "msg = #{msg}"
        end
      when "else"          # その他
        msg = { id: node[:wires][index], payload: payLoad }
        puts "デフォルトmsg = #{msg}"
      else                 # 条件不一致
        puts "The specified condition does not match : #{rule[:t]}"
      end
  end

  $queue << msg

end


#
# inject
#
def process_inject(inject)
  inject[:wires].each { |node|
    msg = {:id => node, :payload => inject[:payload]}
    puts "msg = #{msg}"
    $queue << msg
  }
end

#
# node
#
def process_node(node,msg)
  case node[:type]
  when :debug
    puts "msg[:payload] = #{msg[:payload]}"
  when :switch
    process_node_switch node, msg
  when :gpio
    process_node_gpio node, msg
  when :gpioread
    process_node_gpioread node, msg
  when :ADC
    process_node_ADC node, msg
  when :gpiowrite
    process_node_gpiowrite node, msg
  when :pwm
    process_node_PWM node, msg
  when :i2c
    process_node_I2C node, msg
  when :button
    process_node_Button node, msg
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
  # process inject  delay の考慮
  injects.each_index { |idx|
    injects[idx][:cnt] -= LoopInterval
    if injects[idx][:cnt] <= 0 then
      injects[idx][:cnt] = injects[idx][:repeat]
      process_inject injects[idx]
      puts "Do inject #{idx}"
    end
  }

  # process queue
  indexer = Myindex.new()
  msg = $queue.first
  if msg then
    puts "$queue = #{$queue}"
    $queue.delete_at 0
    puts "$queue = #{$queue}"
    #idx = nodes.myindex { |v| v[:id] == msg[:id] }
    idx = indexer.myindex(nodes, msg)
    puts "node is #{nodes[idx]}"
    if idx then
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