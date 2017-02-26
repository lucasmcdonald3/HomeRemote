import sys
import time
import LEDController

#first arg is the function to call
function = sys.argv[1]

#takes up to four additional args for multiple uses (use 0 if not using them)
arg1 = sys.argv[2]
arg2 = sys.argv[3]
arg3 = sys.argv[4]
arg4 = sys.argv[5]

'''
#access proxy motorcontroller
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
    proxyled.power()

exit()
