import webserver # import webserver class
import gpio
import json

var up_button = 1
var down_button = 0


class Isg83ButtonAdapter
  var down_gpio, up_gpio

  def init(down_gpio, up_gpio)
    self.down_gpio = down_gpio
    self.up_gpio = up_gpio
    gpio.digital_write(self.down_gpio, gpio.HIGH)
    gpio.digital_write(self.up_gpio, gpio.HIGH)
    end

  def button_press(gpio_pin_list)
    for gpio_pin: gpio_pin_list
      gpio.digital_write(gpio_pin, gpio.HIGH)
    end
end

  def button_release(gpio_pin_list)
    for gpio_pin: gpio_pin_list
      gpio.digital_write(gpio_pin, gpio.HIGH)
    end
end

  def click(gpio_pin_list, timeout)
    self.button_press(gpio_pin_list)
    tasmota.delay(timeout)
    self.button_release(gpio_pin_list)
  end
  
  def short_click(gpio_pin_list)
    self.click(gpio_pin_list, 500)
  end

  def long_click(gpio_pin_list)
    self.click(gpio_pin_list, 3000)
  end
end
  

class Isg83: Driver
  var adapter

  def init(down_gpio, up_gpio)
    self.adapter = Isg83ButtonAdapter(down_gpio, up_gpio)
  end

  def every_second()
    # do something
  end

  def web_add_main_button()
    # for line: html["til-buttons"]
    #   webserver.content_send(line)
    # end
    webserver.content_send('<p>hola</p>')
  end


  def web_sensor() # display sensor information on the Web UI

    if webserver.has_arg("button_presed")
      var button_presed = webserver.arg("button_presed")
      end
  end
end

