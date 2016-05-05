# launcher-linux
This launcher was designed to help you install and update all projects from PhoenixMachina.

## Install
Just download the script into the folder you want to have the PhoenixMachina repertories in.

You'll first need to edit the lines of the file. You need to change user to your Linux username and add your database configuration in it, which will be used to create the configuration files necessary for PhoenixMachina to run. 

Done? You now need to launch the script with ksh. If you don't have it, you can install it by doing
```
sudo apt-get install ksh
```

Now make sure you're in the right folder and run
```
sudo ksh launch.sh
```

You're done!
