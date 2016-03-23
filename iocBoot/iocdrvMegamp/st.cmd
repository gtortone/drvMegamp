#!../../bin/linux-arm/drvMegamp

< envPaths

cd "${TOP}"

epicsEnvSet ("STREAM_PROTOCOL_PATH", "${TOP}/db")

## Register all support components
dbLoadDatabase "dbd/drvMegamp.dbd"
drvMegamp_registerRecordDeviceDriver pdbbase

drvAsynSerialPortConfigure("PS1","/dev/ttyACM0", 0, 0, 0)
asynSetOption("PS1", 0, "baud", "115200")
asynSetOption("PS1", 0, "bits", "8")
asynSetOption("PS1", 0, "parity", "none")
asynSetOption("PS1", 0, "stop", "1")
asynSetOption("PS1", 0, "clocal", "Y")
asynSetOption("PS1", 0, "crtscts", "N")
##asynSetTraceIOMask("PS1", 0, 0x2)
##asynSetTraceMask("PS1", 0, 0x9) 

## Set number of attributes provided for each channel
epicsEnvSet("NATTR","5")

## Load record instances
dbLoadRecords("$(TOP)/db/asynRecord.db", "P=MEGAMP:,R=asyn,PORT=PS1,ADDR=0,OMAX=80,IMAX=80")
dbLoadTemplate("$(TOP)/db/Megamp.template", "NATTR=$(NATTR)")

## autosave settings

set_savefile_path("${PWD}/as","/save")
set_requestfile_path("${PWD}/as","/req")
system("install -m 777 -d ${PWD}/as/save")
system("install -m 777 -d ${PWD}/as/req")

dbLoadRecords("$(TOP)/db/save_restoreStatus.db","P=MEGAMP:,CONFIG=as")
dbLoadRecords("$(TOP)/db/configMenu.db","P=MEGAMP:,CONFIG=as")
## set_pass0_restoreFile("ioc_settings.sav")
## var save_restoreDebug 5

cd "${TOP}/iocBoot/${IOC}"
iocInit

makeAutosaveFileFromDbInfo("as/req/ioc_settings.req", "autosaveFields_pass0")
create_manual_set("asMenu.req", "P=MEGAMP:,CONFIG=as,CONFIGMENU=1")

seq pvcopy "P=MEGAMP,NATTR=$(NATTR)"
