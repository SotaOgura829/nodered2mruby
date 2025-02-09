def process_node_gpio(node, msg)
  puts "Do LED : #{node}"
  puts "gpioArray = #{$gpioArray}"
  targetPort = node[:targetPort]
  payLoad = msg[:payload].to_i
  gpioValue = {}
  cnt = {}

  if $gpioArray[targetPort].nil?
    puts "targetPort = #{targetPort}"
    gpio = GPIO.new(targetPort)
    $gpioArray[targetPort] = gpio
    gpioValue[targetPort] = nil
    puts $gpioArray[targetPort].to_s
    puts "Setting up pinMode for pin #{gpio}"
  elsif $gpioArray.key?(targetPort)
    puts "gpioArray[targetPort] = #{$gpioArray[targetPort]}"
    puts "targetPort = #{targetPort}"
    gpio = $gpioArray[targetPort]
    puts "gpioValue[targetPort] = #{gpioValue[targetPort]}"
    puts "Reusing pinMode for pin #{gpio}"
  end

  # 現在のピンの状態をデバッグ出力
  puts "Current pin state before payload check, gpioValue: #{gpioValue}"

  if payLoad == ""
    if gpioValue == 0
      gpio.write(1)
      $pinstatus[targetPort] = 1
      puts "Setting gpioValue to 1, pinstatus = #{$pinstatus[targetPort]}"
    else
      gpio.write(0)
      $pinstatus[targetPort] = 0
      puts "Setting gpioValue to 0, pinstatus = #{$pinstatus[targetPort]}"
    end
  else
    if gpioValue[targetPort] != payLoad
      gpio.write(1)
      gpioValue[targetPort] = payLoad
      puts "Setting gpioValue(payload) to #{payLoad}, payLoad = #{gpioValue[targetPort]}"
    elsif gpioValue[targetPort] == payLoad
      gpio.write(0)
      gpioValue[targetPort] = nil
      puts "Setting gpioValue(payload) to 0, payLoad = #{gpioValue[targetPort]}"
    end
  end
end
