#!/bin/bash

###begin documentation##########################################################
#
# Author:  George Ungureanu <ugeorge@kth.se>
# Date:    2014.12.19
# Purpose: The first commands that should be run during the first login.
# Comment: 
#
###end documentation############################################################

set -e
 
# Updating and Upgrading dependencies
sudo apt-get update -y -qq > /dev/null
sudo apt-get upgrade -y -qq > /dev/null

mkdir ~/Desktop

