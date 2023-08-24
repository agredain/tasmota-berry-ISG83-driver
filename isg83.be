import webserver # import webserver class
import gpio
import json

# https://github.com/fmtr/hct
# https://github.com/arendst/Tasmota/tree/314af22ae3bd41a55b4d09d5f6831c219809625a/tasmota/berry/drivers
# https://github.com/TomsTek/tasmota-berry-TMP117-driver
# https://github.com/Beormund/Tasmota32-Multi-Zone-Heating-Controller
# https://berry.readthedocs.io/en/latest/source/es/Home.html


class Isg83ButtonAdapter

  def init(down_gpio, up_gpio)
    gpio.digital_write(down_gpio, gpio.HIGH)
    gpio.digital_write(up_gpio, gpio.HIGH)
  end

  def button_press(gpio_pin_list)
    for gpio_pin: gpio_pin_list
      gpio.digital_write(gpio_pin, gpio.LOW)
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
  var down_gpio, up_gpio

  def init(down_gpio, up_gpio)
    self.down_gpio = down_gpio
    self.up_gpio = up_gpio
    self.adapter = Isg83ButtonAdapter(down_gpio, up_gpio)
  end

  def every_second()
    # do something
  end

  def web_add_main_button()
    webserver.content_send("<table style='width:100%'><tbody><tr>")
    webserver.content_send("<td style='width:33%'><button onmousedown='la(\"&button_presed=up\");' onmouseup='la(\"&button_released=up\");' name=''>▲</button></td>")
    webserver.content_send("<td style='width:34%'><button onmousedown='la(\"&button_presed=center\");' onmouseup='la(\"&button_released=center\");' name=''>o</button> </td>")
    webserver.content_send("<td style='width:33%'><button onmousedown='la(\"&button_presed=down\");' onmouseup='la(\"&button_released=down\");' name=''>▼</button>")
    webserver.content_send("</td></tr><tr></tr></tbody></table>")
  end


  def web_sensor() # display sensor information on the Web UI
    var button_list

    if webserver.has_arg("button_presed")
      var button_presed = webserver.arg("button_presed")
      if button_presed == "up"
        button_list = [self.up_gpio]
      elif button_presed == "down"
        button_list = [self.down_gpio]
      elif button_presed == "center"
        button_list = [self.down_gpio, self.up_gpio]
      else
        button_list = []
      end

      self.adapter.button_press(button_list)

    elif webserver.has_arg("button_released")
      var button_released = webserver.arg("button_released")
      if button_released == "up"
        button_list = [self.up_gpio]
      elif button_released == "down"
        button_list = [self.down_gpio]
      elif button_released == "center"
        button_list = [self.down_gpio, self.up_gpio]
      else
        button_list = []
      end

      self.adapter.button_release(button_list)
    end
  end
end


# web_add_main_button(), web_add_management_button(), web_add_console_button(), web_add_config_button(): add a button to Tasmotas Web UI on a specific page
# web_add_handler(): called when Tasmota web server started, and the right time to call webserver.on() to add handlers
# button_pressed(): called when a button is pressed
# save_before_restart(): called just before a restart
# mqtt_data(topic, idx, data, databytes): called for MQTT payloads matching mqtt.subscribe. idx is zero, and data is normally unparsed JSON.
# set_power_handler(cmd, idx): called whenever a Power command is made. idx contains the index of the relay or light. cmd can be ignored.
# display(): called by display driver with the following subtypes: init_driver, model, dim, power.