#!/bin/bash
clear
user="ulysse"

#Database config
dbuser="root"
dbpassword="localhost"
dbname="phoenixmachina"
dbhost="localhost"

#don't touch
CL='\033[1;32m'
CR='\033[0;31m'
CLA='\033[1;33m'
CG='\033[1;34m'
NC='\033[0m'

######
# Cmd functions

# help
# List of available commands
help () {
  printf "Available commands:\n"
  printf "${CLA}clear: ${CL}Clean the terminal\n"
  printf "${CLA}help: ${CL}List of available commands\n"
  printf "${CLA}install: ${CL}Install and set up the PhoenixMachina repositories\n"
  printf "${CLA}update: ${CL}Check update of Julia and PhoenixMachina repositories\n"
  printf "${CLA}start: ${CL}Start PhoenixMachina\n"
  printf "${CLA}test: ${CL}Run test file of the repository\n"
  printf "${CLA}quit: ${CL}Close the terminal${NC}\n"
}

# install
# Install and set up the PhoenixMachina repositories
install () {
  if [[ ! -d "PhoenixMachina" ]]; then
    printf "${CG} Cloning PhoenixMachina repository${NC}\n"
    git clone https://github.com/PhoenixMachina/PhoenixMachina.git PhoenixMachina
  else
    printf "${CL}PhoenixMachina already exists${NC}\n"
  fi
  if [[ ! -d "Tlaloc" ]]; then
    printf "${CG} Cloning Tlaloc repository${NC}\n"
    git clone https://github.com/PhoenixMachina/Tlaloc.git Tlaloc
  else
    printf "${CL}Tlaloc already exists${NC}\n"
  fi
  if [[ ! -d "ConfParser" ]]; then
    printf "${CG} Cloning ConfParser repository${NC}\n"
    git clone https://github.com/PhoenixMachina/ConfParser.jl.git ConfParser
  else
    printf "${CL}ConfParser already exists${NC}\n"
  fi
  if [[ ! -d "Yodel" ]]; then
    printf "${CG} Cloning Yodel repository${NC}\n"
    git clone https://github.com/PhoenixMachina/Yodel.git Yodel
  else
    printf "${CL}Yodel already exists${NC}\n"
  fi
  if [[ ! -d "SapphireORM" ]]; then
    printf "${CG} Cloning SapphireORM repository${NC}\n"
    git clone https://github.com/PhoenixMachina/SapphireORM.git SapphireORM
  else
    printf "${CL}SapphireORM already exists${NC}\n"
  fi
  if [[ ! -d "launcher-linux" ]]; then
    printf "${CG} Cloning launcher-linux repository${NC}\n"
    git clone https://github.com/PhoenixMachina/launcher-linux.git launcher-linux
  else
    printf "${CL}launcher-linux already exists${NC}\n"
  fi
  cd PhoenixMachina
  printf "${CG} Install packages for PhoenixMachina${NC}\n"
  julia install.jl
  cd ..
  sudo chown $user *
  sudo chown $user */
  sudo chown $user */*
  sudo chown $user */*/
  sudo chown $user */*/*
  printf "${CG} Configuring config.jl${NC}\n"
  if [[ -f "PhoenixMachina/config.jl" ]]; then
    rm PhoenixMachina/config.jl
  fi
  echo "#REQUIRED

#Home URLS
HOME_CONTROLLER = \"homeController.jl\"
HOME_URL = \"$path/PhoenixMachina/\"
# Database
DB_USER = \"$dbuser\"
DB_PASSWORD = \"$dbpassword\"
DB_NAME = \"$dbname\"
DB_HOST = \"$dbhost\"

#OPTIONAL" >> PhoenixMachina/config.jl

  printf "${CG} Configuring tlaloc.ini${NC}\n"
  if [[ -f "PhoenixMachina/include/tlaloc.ini" ]]; then
    rm PhoenixMachina/include/tlaloc.ini
  fi
  echo "viewPath=$path/PhoenixMachina/views/
templatePath=$path/PhoenixMachina/templates/
resourcePath=$path/PhoenixMachina/resources/" >> $path/PhoenixMachina/include/tlaloc.ini

  printf "${CG} Configuring test_conf.ini in Tlaloc${NC}\n"
  if [[ -f "Tlaloc/test/test_conf.ini" ]]; then
    rm Tlaloc/test/test_conf.ini
  fi
echo "viewPath=thisIsTheViewPath
templatePath=thisIsTheTemplatePath
resourcePath=$path/Tlaloc/test/thisIsTheResource" >> $path/Tlaloc/test/test_conf.ini
}

# update
# Check update of Julia and PhoenixMachina repositories
update () {
  printf "${CG} Check update for julia package ${NC}\n"
  sudo apt-get install julia
  printf "${CG} Updating julia packages ${NC}\n"
  julia -e "Pkg.update()"
  if [[ -d "PhoenixMachina/" ]]; then
    cd PhoenixMachina
    printf "${CG} Pull PhoenixMachina repository from Github to local ${NC}\n"
    git pull
    cd ..
  else
    printf "${CR}PhoenixMachina wasn't found ${NC}\n"
  fi
  if [[ -d "SapphireORM/" ]]; then
    cd SapphireORM
    printf "${CG} Pull SapphireORM repository ${NC}\n"
    git pull
    cd ..
  else
    printf "${CR}SapphireORM wasn't found ${NC}\n"
  fi
  if [[ -d "Tlaloc/" ]]; then
    cd Tlaloc
    printf "${CG} Pull Tlaloc repository ${NC}\n"
    git pull
    cd ..
  else
    printf "${CR}Tlaloc wasn't found ${NC}\n"
  fi
  if [[ -d "Yodel/" ]]; then
    cd Yodel
    printf "${CG} Pull Yodel repository${NC}\n"
    git pull
    cd ..
  else
    printf "${CR}Yodel wasn't found ${NC}\n"
  fi
  if [[ -d "ConfParser/" ]]; then
    cd ConfParser
    printf "${CG} Pull ConfParser repository${NC}\n"
    git pull
    cd ..
  else
    printf "${CR}ConfParser wasn't found ${NC}\n"
  fi
  cd launcher-linux
  printf "${CG} Pull launcher-linux repository${NC}\n"
  git pull
  cd ..
}

# start
# Start PhoenixMachina
start () {
  if [[ -d "PhoenixMachina/" ]]; then
    cd launcher-linux/logs
    printf "${CG} Starting PhoenixMachina ${NC}\n"
    julia ../../PhoenixMachina/start_server.jl 2>&1 | tee logs$(date +"%F%T")
    cd ../..
  else
    printf "${CR}PhoenixMachina wasn't found${NC}\n"
  fi
}

# test
# Run test file of the repository
testc () {
  folder=${cmd:4}
  julia $folder/test/runtests.jl
}

######
# Terminal

# Unknown command
default () {
  printf "${CL}Unknown command. Type ${CLA}help ${CL}to check commands\n${NC}"
}

# First Message
intro () {
  printf "${CL}PhoenixMachina launcher for Linux\n"
  printf "type ${CLA}help ${CL}to check commands${CL}\n${NC}"
}

#Startup
intro
cd ..

while [ true ]
do

  # Input
  path=$(pwd)
  printf "[$USER:$path] "
  read cmd

  # Check if cmd is a valid command, if yes, execute it.
  case $cmd in
    help)
    help
    ;;
    update)
    update
    ;;
    start)
    start
    ;;
    install)
    install
    ;;
    clear)
    clear
    intro
    ;;
    quit)
    clear
    exit 1
    ;;
    *)
    if [[ ${cmd:0:4} = "test" ]]
      then
        testc
      else
        default
      fi
      ;;
  esac

done
