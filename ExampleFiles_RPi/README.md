Contains a few projects developed for the Raspberry Pi for developers to base their own projects off of. 

The projects are well-documented and should provide a basic template for developers to use.

A step-by-step instruction for developers to follow in creating their own projects follows.

- Developers will need to provide your own class for interfacing with the GPIO pins. In our example, this is "LEDController.py".
- Developers will need to look at the list of remotes and functionalities to determine which remote they will need to use in the "SSHtoHomeRemote.py" file.
- Developers will need to implement the called functions from XCode to work with the functions in their app. (e.g. "SSHtoHomeRemote 3 0 0 0 0" could be used to call a series of methods to make a project function.)

That's it! Take a walk through our example project (LED_Controller) to see how easy it is to implement Home Remote into your devices!
