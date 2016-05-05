#!/bin/bash
clear
user=""

#Database config
dbuser=""
dbpassword=""
dbname=""
dbhost=""

#don't touch
path="../"
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
  printf "${CLA}install: ${CL}Install PhoenixMachina repositories\n"
  printf "${CLA}update: ${CL}Update julia, its packages and all git repositories\n"
  printf "${CLA}test: ${CL}Run test file\n"
  printf "${CLA}start: ${CL}Start PhoenixMachina\n"
  printf "${CLA}quit: ${CL}Close the terminal${NC}\n"
}

# update
# Update julia, julia's packages and all PhoenixMachina git repositories
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
    cd PhoenixMachina
    printf "${CG} Starting PhoenixMachina ${NC}\n"
    julia start_server.jl
    cd ..
  else
    printf "${CR}PhoenixMachina wasn't found${NC}\n"
  fi
}

# install
# Install PhoenixMachina and its git repositories (included packages)
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
  if [[ -f "$path/PhoenixMachina/config.jl" ]]; then
    rm $path/PhoenixMachina/config.jl
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

#OPTIONAL" >> $path/PhoenixMachina/config.jl

  printf "${CG} Configuring tlaloc.ini${NC}\n"
  if [[ -f "$path/PhoenixMachina/include/tlaloc.ini" ]]; then
    rm $path/PhoenixMachina/include/tlaloc.ini
  fi
  echo "viewPath=$path/PhoenixMachina/views/
templatePath=$path/PhoenixMachina/templates/
resourcePath=$path/PhoenixMachina/resources/" >> $path/PhoenixMachina/include/tlaloc.ini
}

# test
# Run test file
test () {
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
cd $path

while [ true ]
do

  # Input
  printf "[$USER:$(pwd)] "
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
        test
      else
        default
      fi
      ;;
  esac

done
