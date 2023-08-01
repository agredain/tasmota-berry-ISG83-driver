import webserver # import webserver class

var up_button = 1
var down_button = 0

def short_press(relay)
    def power_off()
        tasmota.set_power(relay, false)
    end
    tasmota.set_power(relay, true)
    tasmota.set_timer(500, power_off)
end

def long_press(relay)
    def power_off()
        tasmota.set_power(relay, false)
    end
    tasmota.set_power(relay, true)
    tasmota.set_timer(4000, power_off)
end

class Isg83: Driver
  var opened
  var til_mode

  def init()
    self.opened = 100.0
    self.til_mode = false
  end

  def every_second()
    # do something
  end

  def web_add_main_button()
    webserver.content_send('<p>hola</p>')
    webserver.content_send('<table style="width:100%"> <tbody> <tr> <td style="width:30%"> <button onclick="la(\'&button_presed=up\');" name="">▲</button> </td> <td style="width:40%"> <button onclick="la(\'&button_presed=center\');" name="">o</button> </td> <td style="width:30%"> <button onclick="la(\'&button_presed=down\');" name="">▼</button> </td> </tr> <tr></tr> </tbody> </table>')
  end

  def handle_normal(option)
    if option == "up"
      short_press(up_button)
      tasmota.delay(500)
      short_press(up_button)
      short_press(down_button)
    elif option == "down"
      short_press(down_button)
      tasmota.delay(500)
      short_press(up_button)
      short_press(down_button)
    elif option == "center"
      long_press(up_button)
      long_press(down_button)
      self.til_mode = true
    end
  end

  def handle_til(option)
    if option == "up"
      short_press(up_button)
    elif option == "down"
      short_press(down_button)
    elif option == "center"
      long_press(up_button)
      long_press(down_button)
      self.til_mode = false
    end
  end

  def web_sensor()

    if webserver.has_arg("button_presed")
      var button_presed = webserver.arg("button_presed")
      if self.til_mode
        self.handle_til(button_presed)
      else
        self.handle_normal(button_presed)
      end

    end

  end
end

var d1 = Isg84()

tasmota.add_driver(d1)
