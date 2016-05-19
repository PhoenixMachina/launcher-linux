# launcher-linux
This launcher was designed to help you install and update all projects from PhoenixMachina.

## Install
Just download the script into the folder you want to have the PhoenixMachina repertories in.

You'll first need to edit the lines of the file. You need to change user to your Linux username and add your database configuration in it, which will be used to create the configuration files necessary for PhoenixMachina to run. Check the "Configuration" part to have more informations.

Done? You now need to launch the script with ksh. If you don't have it, you can install it by doing

```
sudo apt-get install ksh
```

Now make sure you're in the right folder and run
```
sudo ksh launch.sh
```
Your folder must be structured like this:


Folder/

├── ConfParser

├── launcher-linux

├── PhoenixMachina

├── SapphireORM

├── Tlaloc

└── Yodel


You're done!

## Configuration
To config the launcher, set the variables below in launch.sh.

```
user="username"
```
Change "username" to your linux username in first part.

```
dbuser="localhost"
dbpassword=""
dbname="phoenixmachina"
dbhost="localhost"
```
Then, add your database configuration. The code above is an example.

## Features
### Commands

#### clear
Clean the terminal.

#### help
Display the list of available commands.

#### install
Install and set up the PhoenixMachina repositories.

#### update
Check update of Julia and PhoenixMachina repositories.

#### start
Start PhoenixMachina.

#### test <repository>
Run the test file of the repository.

#### quit
Close the terminal.

---

### Logs
When you start PhoenixMachina, logs are created in logs/.
