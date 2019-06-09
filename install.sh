#!/bin/bash
set -e
# Authors:      Rodrigo Cuadra
#               with Collaboration of Jose Miguel Rivera
#
# Support:      rcuadra@vitalpbx.com
#
echo -e "\n"
echo -e "************************************************************"
echo -e "*           Welcome to the VitalPBX Assistant              *"
echo -e "*                   Powered by Google                      *"
echo -e "************************************************************"
while [[ $client_secret == '' ]]
do
    read -p "Client Secret JSon File Name... > " client_secret 
done
while [[ $project_id == '' ]]
do
    read -p "Project ID..................... > " project_id 
done
while [[ $model_id == '' ]]
do
    read -p "Device Model ID................ > " model_id 
done
yum install -y python-devel python-pip
python -m pip install --upgrade pip setuptools wheel
echo -e "\n"
echo -e "************************************************************"
echo -e "*                      Get Package                         *"
echo -e "************************************************************"
yum install -y portaudio-19 libffi-devel openssl-devel libmpg123-devel
python -m pip install --upgrade google-assistant-library==1.0.1
python -m pip install --upgrade google-assistant-sdk[samples]==0.5.1
echo -e "\n"
echo -e "************************************************************"
echo -e "*                 Generate credentials                     *"
echo -e "*      Copy a paste the name of he client secret file      *"
echo -e "************************************************************"
python -m pip install --upgrade google-auth-oauthlib[tool]
echo -e "\n"
echo -e "************************************************************"
echo -e "*     Wait for the verification device URL a paste this    *"
echo -e "*                    in the web browser                    *"
echo -e "************************************************************"
google-oauthlib-tool --scope https://www.googleapis.com/auth/assistant-sdk-prototype --scope https://www.googleapis.com/auth/gcm --save --headless --client-secrets /var/lib/asterisk/$client_secret
mv /root/.config/google-oauthlib-tool/credentials.json /var/lib/asterisk/
echo -e "\n"
echo -e "************************************************************"
echo -e "*                        Copy Files                        *"
echo -e "************************************************************"
cd /var/lib/asterisk/agi-bin
wget https://raw.githubusercontent.com/VitalPBX/VitalPBX_Google_Assistant/master/google.agi
chown asterisk:asterisk google.agi
chmod +x google.agi
sed -i 's/my-project-id/$project_id/g' /var/lib/asterisk/agi-bin/google.agi
sed -i 's/my-device-model/$model_id/g' /var/lib/asterisk/agi-bin/google.agi
cd /etc/asterisk/ombutel
wget https://raw.githubusercontent.com/VitalPBX/VitalPBX_Google_Assistant/master/extensions__60-google_assistant.conf
cd /var/lib/asterisk/sounds/en
wget https://raw.githubusercontent.com/VitalPBX/VitalPBX_Google_Assistant/master/google_another.sln
wget https://raw.githubusercontent.com/VitalPBX/VitalPBX_Google_Assistant/master/google_example.sln
wget https://raw.githubusercontent.com/VitalPBX/VitalPBX_Google_Assistant/master/google_goodbye.sln
wget https://raw.githubusercontent.com/VitalPBX/VitalPBX_Google_Assistant/master/google_wait.sln
wget https://raw.githubusercontent.com/VitalPBX/VitalPBX_Google_Assistant/master/google_welcome.sln
cd /tmp
wget https://raw.githubusercontent.com/VitalPBX/VitalPBX_Google_Assistant/master/in.wav
echo -e "\n"
echo -e "************************************************************"
echo -e "*     Create working directory and allow asterisk user     *"
echo -e "************************************************************"
mkdir /var/lib/asterisk/.config/
chown asterisk:asterisk /var/lib/asterisk/.config/
echo -e "\n"
echo -e "************************************************************"
echo -e "*                VitalPBX Dialplan realod                   *"
echo -e "************************************************************"
asterisk -rx"dialplan reload"
echo -e "\n"
echo -e "************************************************************"
echo -e "*                        Finish                             *"
echo -e "*                 Please dial *789 for test                 *"
echo -e "************************************************************"
