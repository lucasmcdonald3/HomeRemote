import RPi.GPIO as GPIO
import sys
import time

class LEDController():
    def __init__(self):

        outputfile = open('/home/pi/Downloads/LEDController/power.txt')

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
        GPIO.setmode(GPIO.BOARD)
        GPIO.setup(8, GPIO.OUT)
        
    def powerOnOff(self):
        if(self.power == 1):
            self.power = 0
            GPIO.output(8, GPIO.LOW)         
        else:
            self.power = 1
            GPIO.output(8, GPIO.HIGH)
        outputfile = open('/home/pi/Downloads/LEDController/power.txt', 'w')
	outputfile.write(str(self.power))
	
'''    
    def increase(self):
        if(self.power < 100):
            self.power += 5
            print(self.power)
            self.p.ChangeDutyCycle(self.power)
        outputfile = open('/home/pi/Downloads/LEDController/power.txt', 'w')
        outputfile.write(str(self.power))
        return self.power

    
    def decrease(self):
        if(self.power > 0):
            self.power -= 5
            self.p.ChangeDutyCycle(self.power)
        outputfile = open('/home/pi/Downloads/LEDController/power.txt', 'w')
        outputfile.write(str(self.power))
        return self.power


    
    def powerOnOff(self):
        if(self.power > 0):
            self.p.stop()
        else:
            self.p.start(self.power)
        outputfile = open('/home/pi/Downloads/LEDController/power.txt', 'w')
        outputfile.write(str(self.power))
        return self.power'''


#first arg is the function to call
function = sys.argv[1]

#takes up to four additional args for multiple uses (use 0 if not using them)
arg1 = sys.argv[2]
arg2 = sys.argv[3]
arg3 = sys.argv[4]
arg4 = sys.argv[5]


'''#access proxy motorcontroller
proxyled = Pyro4.core.Proxy("PYRONAME:ledcontroller.server")

#call the proxy to perform methods based on function
if(function == "1"):
    proxyled.increase()
elif(function == "2"):
    proxyled.decrease()
elif(function == "3"):
    proxyled.power()
'''

proxyled = LEDController()

if(function == "1"):
    proxyled.increase()
elif(function == "2"):
    proxyled.decrease()
elif(function == "3"):
    proxyled.powerOnOff()



exit()
