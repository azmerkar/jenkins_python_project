#!/bin/bash
unzip -o /home/ec2-user/myapp.zip -d /home/ec2-user/app/
source /home/ec2-user/app/venv/bin/activate
cd /home/ec2-user/app/
pip install -r requirements.txt
sudo systemctl restart flaskapp.service