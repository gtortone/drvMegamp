TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

## DBD += as.dbd
## DBD += asSupport.dbd

# include files
INC += osdNfs.h

#=============================
# Build custom autosave library

LIBRARY_IOC += autosave

# os independent code
autosave_SRCS += dbrestore.c save_restore.c
autosave_SRCS += initHooks.c fGetDateStr.c
autosave_SRCS += configMenuSub.c verify.c

# os dependent code
autosave_SRCS += osdNfs.c

autosave_LIBS += $(EPICS_BASE_IOC_LIBS)

#=============================
# Build the IOC application

SNC=/opt/epics/support/seq-2.2.3/bin/linux-arm/snc
AUTOSAVE=$(TOP)/lib/linux-arm

PROD_IOC = drvMegamp
# drvMegamp.dbd will be created and installed
DBD += drvMegamp.dbd

# drvMegamp.dbd will be made up from these files:
drvMegamp_DBD += base.dbd
drvMegamp_DBD += asyn.dbd
drvMegamp_DBD += stream.dbd
drvMegamp_DBD += busySupport.dbd
drvMegamp_DBD += calcSupport.dbd
drvMegamp_DBD += asSupport.dbd
drvMegamp_DBD += system.dbd
drvMegamp_DBD += pvcopy.dbd
drvMegamp_DBD += drvAsynSerialPort.dbd 

# Add all the support libraries needed by this IOC
drvMegamp_LIBS += stream
drvMegamp_LIBS += asyn
drvMegamp_LIBS += seq pv
drvMegamp_LIBS += busy
drvMegamp_LIBS += calc
drvMegamp_LIBS += autosave

# drvMegamp_registerRecordDeviceDriver.cpp derives from drvMegamp.dbd
drvMegamp_SRCS += drvMegamp_registerRecordDeviceDriver.cpp
drvMegamp_SRCS += pvcopy.st

# Build the main IOC entry point on workstation OSs.
drvMegamp_SRCS_DEFAULT += drvMegampMain.cpp

# Finally link to the EPICS Base libraries
drvMegamp_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES

