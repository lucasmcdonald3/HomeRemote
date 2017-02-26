''' This file is called from the iOS app.
    Specifically, the app calls the statement: cd /home/Home_Remote; python SSHtoHomeRemote.py [args]
    The arguments vary for each style of remote. For this example of the LED controller, we use the one-button remote.
    As a result, we can have a very basic set of args: 1 0 0 0 0.
    Thus the exact statement used from this remote is: cd /home/Home_Remote; python SSHtoHomeRemote.py 1 0 0 0 0'''

import LEDController

#first arg is the function to call
function = sys.argv[1]

#takes up to four additional args for multiple uses (use 0 if not using them)
arg1 = sys.argv[2]
arg2 = sys.argv[3]
arg3 = sys.argv[4]
arg4 = sys.argv[5]

proxyled = LEDController()

if(function == "1"):
    proxyled.powerOnOff()

exit()
