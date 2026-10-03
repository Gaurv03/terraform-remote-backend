#!/bin/bash

sudo apt update -y
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

echo "<h1> Terraform Tutorial by Vinter </h1>" | sudo tee /var/www/html/index.html