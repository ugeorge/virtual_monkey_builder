#!/bin/bash

###begin documentation##########################################################
#
# Author:  George Ungureanu <ugeorge@kth.se>
# Date:    2015.01.08
# Purpose: ForSyDe-Haskell EDSL
# Comment: 
#
###end documentation############################################################

sudo apt-get install -y git
sudo apt-get install -y haskell-platform
sudo apt-get install -y ghc-haddock
sudo apt-get install -y cabal-install-1.24



mkdir /home/student/forsyde-haskell
git clone https://github.com/forsyde/forsyde-shallow.git /home/student/forsyde-haskell
cd /home/student/forsyde-haskell

cabal install

sudo mv /home/student/forsyde-haskell /opt/
