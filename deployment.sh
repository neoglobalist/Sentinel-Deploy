#!/bin/bash

# Variables
ENV="dev"
ORG="hunterdon"
MSSP="ctoc"

TOKEN="2667c45e1b18ea74766daccd7bfa9bf4e0914c41"

sudo apt install software-properties-common -y
sudo apt-add-repository universe
sudo apt-add-repository multiverse

sudo apt update -y

sudo apt install curl python python-pip -y
pip install azure-cosmos

cd ~
git clone http://csharpe101:$TOKEN@github.com/Sensato/packer-nids.git
cd packer-nids
git checkout appliance

# Install Azure CLI
sudo apt install apt-transport-https lsb-release gnupg -y
curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor | \
    sudo tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
    sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt update -y
sudo apt install azure-cli -y

az extension add --name azure-cli-iot-ext

STR="Debug Message: Building Sentinel on environment $ENV, organization $ORG, msspid $MSSP."
echo $STR
python build_sensor.py env=$ENV orgid=$ORG msspid=$MSSP buildos=linux
