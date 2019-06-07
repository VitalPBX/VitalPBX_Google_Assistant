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
yum install -y python-devel python-virtualenv
virtualenv env --no-site-packages
env/bin/python -m pip install --upgrade pip setuptools wheel
source env/bin/activate
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
echo -e "************************************************************"
python -m pip install --upgrade google-auth-oauthlib[tool]
echo -e "\n"
echo -e "************************************************************"
echo -e "*                        Finish                             *"
echo -e "*       Now continue with manual configurations             *"
echo -e "************************************************************"
