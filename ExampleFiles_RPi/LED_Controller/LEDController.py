import RPi.GPIO as GP

''' RPi.GPIO is a standard class for controlling the GPIO pins on a Raspberry Pi.
    It provides numerous functionalities for controlling GPIO pins, including PWM and controlling multiple pins. '''

''' Here we provide a class for our LED controller. We create an object of this class below.
    We have programmed this to only work with one method, powerOnOff.
    This is an example of minimizing the number of needed methods.'''

class LEDController():
    def __init__(self):
	
	
	''' We store the current state of the LED in a .txt file.'''
        outputfile = open('/home/pi/Downloads/LEDController/power.txt')
	
	''' Here we convert the current state of the LED to a float for the program to work with.'''
	
        for line in outputfile:
            for numstr in line.split(","):
                if numstr:
                    try:
                        numFl = float(numstr)
                        print(numFl)
                    except ValueError as e:
                        print(e)

             
        self.power = numFl
        outputfile.close()
	
	''' Here we set up the GPIO pins. We used pin 8 in our design.'''
	
        GPIO.setmode(GPIO.BOARD)
        GPIO.setup(8, GPIO.OUT)
    
    # This is our only method: powerOnOff. It uses the stored value of the LED, then flips the GPIOs to the opposite state.
    def powerOnOff(self):
        if(self.power == 1):
            self.power = 0
            GPIO.output(8, GPIO.LOW)         
        else:
            self.power = 1
            GPIO.output(8, GPIO.HIGH)
		
	# Now we store the new value of the LED's current state into the .txt file.
        outputfile = open('/home/pi/Downloads/LEDController/power.txt', 'w')
	outputfile.write(str(self.power))
