#!/bin/bash

###begin documentation##########################################################
#
# Author:  George Ungureanu <ugeorge@kth.se>
# Date:    2014.12.19
# Purpose: ForSyDe-SystemC library and environment
# Comment: I don't know if the Accelera link works for everybody. In case the
#          configuration fails, get SystemC 2.3.1 from the Accelera Initiative download page:
#          http://www.accellera.org/downloads/standards/systemc
#          register, and download systemc-2.3.1.tgz

#Dfml systemc-2.3.1.tgz a6437844f7961c4e47d9593312f6311c http://www.accellera.org/downloads/standards/systemc/accept_license/accepted_download/systemc-2.3.1.tgz
#
###end documentation############################################################

touch /opt/forsyde-systemc/Makefile.defs
echo "## Variable that points to SystemC installation path
SYSTEMC = /opt/systemc-2.3.1

## Variable that points to SFF (SystemC ForSyDe) installation path
SFF = /opt/forsyde-systemc/src

TARGET_ARCH = linux
CC     = g++  
OPT    = -O0 -std=c++11
DEBUG  = -g
SYSDIR = -I \$(SYSTEMC)/include
INCDIR = -I. -I.. \$(SYSDIR) -I\$(SFF)
LIBDIR = -L. -L.. -L\$(SYSTEMC)/lib-\$(TARGET_ARCH)

## Build with maximum gcc warning level
CFLAGS = -Wall -Wno-deprecated -Wno-return-type -Wno-char-subscripts -pthread \$(DEBUG) \$(OPT) \$(EXTRACFLAGS)
#CFLAGS = -arch i386 -Wall -Wno-deprecated -Wno-return-type -Wno-char-subscripts \$(DEBUG) \$(OPT) \$(EXTRACFLAGS)

LIBS   =  -lstdc++ -lm \$(EXTRA_LIBS) -lsystemc

EXE    = \$(MODULE).x

.PHONY: clean 

\$(EXE): \$(OBJS)
\t\$(CC) \$(CFLAGS) \$(INCDIR) \$(LIBDIR) -o \$@ \$(OBJS) \$(LIBS) 2>&1 | c++filt

## based on http://www.paulandlesley.org/gmake/autodep.html
%.o : %.cpp
\t\$(CC) \$(CFLAGS) \$(INCDIR) -c -MMD -o \$@ \$<
\t@cp \$*.d \$*.P; \\
\tsed -e 's/#.*//' -e 's/^[^:]*: *//' -e 's/ *\\\$\$//' \\
\t-e '/^\$\$/ d' -e 's/\$\$/ :/' < \$*.d >> \$*.P; \\
\trm -f \$*.d

clean:
\t-rm -f \$(OBJS) *~ \$(EXE) *.vcd *.wif *.isdb *.dmp *.P *.log

-include \$(SRCS:.cpp=.P)" > /opt/forsyde-systemc/Makefile.defs


touch ~/.fsdk
echo 'PS1="\[\e[32;2m\]\w\[\e[0m\]\n[ForSyDe-SystemC]$ "

if [ "$FORSYDE_BASH_RUN" != "" ]
then
	return 0 # is already runníng
fi
FORSYDE_BASH_RUN=1

export LD_LIBRARY_PATH=/opt/systemc-2.3.1/lib-linux
export FORSYDE_MAKEDEFS=/opt/forsyde-systemc/Makefile.defs


Example designs can be found in
	/opt/forsyde-systemc/examples


cd ~/ForSyDe-workspace

function generate-makefile () {
touch Makefile
echo "
EXTRACFLAGS = 
EXTRA_LIBS =

MODULE = run
SRCS = \\$(wildcard *.cpp)

OBJS = \\$(SRCS:.cpp=.o)

include \\$(FORSYDE_MAKEDEFS)

CFLAGS += -DFORSYDE_INTROSPECTION

" > Makefile
}

' >> ~/.fsdk

chmod 777 ~/.fsdk


