This is a list of remotes currently implemented in Home Remote. It also provides insight as to how the app implements each remote, allowing developers to utilize the remotes' functionality properly.

One Button
- The name is somewhat evident. This remote is a single-button remote for basic applications (turning on and off a light, opening a garage door, etc.)
- When pressed, the button calls "SSHtoHomeRemote.py 1 0 0 0 0". Thus there is only one callable function from this remote, which should still be enough for some purposes.

Stepper Remote
- This remote provides a way to increment or decrement a value by an amount controlled by the device developer. It utilizes a plus and a minus button, as well as a third button for additiona functionality.
- Pressing the plus button calls "SSHtoHomeRemote.py 1 0 0 0 0".
- Pressing the minus button calls "SSHtoHomeRemote.py 2 0 0 0 0".
- Pressing the third button calls "SSHtoHomeRemote.py 3 0 0 0 0".]

We didn't have time to implement all the remotes we wanted. Some more we would like to include follow.

Text Input Remote
- Provides up to four fields to transmit string values to the device.
- Pressing a button will call "SSHtoHomeRemote.py 1 [str1] [str2] [str3] [str4]". This utilizes the additional data fields that we provide in the SSHtoHomeRemote.py file.

Slider Remote
- Provides a slider to vary the value of a parameter between a maximum and minimal value.
- Much like the stepper remote, but provides a much more gradual gradation between values.
- Sliding the slider calls "SSHtoHomeRemote.py 1 [sliderValue] 0 0 0".
