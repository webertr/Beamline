#!../../bin/linux-x86/beamline

## You may have to change beamline to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

epicsThreadSleep(5)

## Register all support components
dbLoadDatabase("dbd/beamline.dbd")
beamline_registerRecordDeviceDriver(pdbbase)

## Setup the GPIB gateway for the Internal Steering Magnet
#E5810Reboot("192.168.0.154",0)

vxi11Configure("SM01Gateway", "192.168.0.154", 1, 2, "gpib0")



## Setup the GPIB gateway for Steering Magnets 2/3
#E5810Reboot("192.168.0.155",0)

vxi11Configure("SM23AGateway", "192.168.0.155", 1, 2, "gpib0")

## Setup the GPIB gateway for GCC
#E5810Reboot("192.168.0.156",0)

vxi11Configure("GCCGateway", "192.168.0.156", 1, 2, "gpib0")



##vxi11Configure("portName", "address", flag, timeout, "vxiName", priority, noAutoConnect)
## portName = Any Name that makes sense (Can be more than one port(name) per IP address.
## address = IP address or name on tne network.  Assumed TCP unless specified - See documentation for other than TCP
## flag = lock/recovery specification. we haqd been using 1 = Recover with IFC (Interface Clear) when error occurs.  Will try 0 = no IFC Clear with error.
## timeout = I/O timeout in seconds
## vxiName = must be "gpib0" for E5810E
## priority = Priority for Asyn I/O thread.  0 or missing = medium priority
## noAutoConnect = zero or missing for portThread to autoconnect



## Setup the GPIB gateway for Q1
#E5810Reboot("192.168.0.157",0)

vxi11Configure("Q1Gateway", "192.168.0.157", 1, 2, "gpib0")

## Setup the GPIB gateway for QG
#E5810Reboot("192.168.0.158",0)

vxi11Configure("QGGateway", "192.168.0.158", 1, 2, "gpib0")

## Setup the GPIB gateway for Q23A
#E5810Reboot("192.168.0.159",0)

vxi11Configure("Q23AGateway", "192.168.0.159", 1, 2, "gpib0")

## Setup the GPIB gateway for Q23B
#E5810Reboot("192.168.0.160",0)

vxi11Configure("Q23BGateway", "192.168.0.160", 1, 2, "gpib0")


##Gantry Steerers

vxi11Configure("XGSteerer", "192.168.0.166", 1, 2, "inst0", 0, 1)

vxi11Configure("YGSteerer", "192.168.0.167", 1, 2, "inst0", 0, 1)


####################################################################################################################################
#########################Configure Asyn Ports Connected to the Extractor SAM, PSHV/SEPTUM, EMC, PSARC/GasFlow Meter
####################################################################################################################################

##                  drvAsynIPPortConfigure("portName","hostAddress",priority,noAutoConnect,noProcessEOS)

##                  portName = Any Name that makes sense (Can be more than one port(name) per IP address
##                  hostAddress = IP address or name, and port # on tne network.  Assumed TCP unless specified - See documentation for other than TCP
##                  maxClients - the maximum number of connections allowed to this port
##                  priority = Asyn I/O thread priority.  0 or missing = ThreadPriorityMedium
##                  noAutoConnect = Autoconnect status. 0 or missing = Autoconnect after disconnect or if connect timeout at boot.
##                  noProcessEOS = EOS in and out are specified if 0 or missing

##  Configure Port for Source-Extractor-Output Acromag 973EN-4006, 6 Channel Analog Output, Output range of 0-5 VDC
## Acromag used to read extractor servo + gas servo + defl probe servo potentiometer values and Gas Flow Meter


## Configure Port connected to BMG Acromag - 952EN, Combo I/O module, Input range of +/-10 VDC, output range 0-20 mA
drvAsynIPPortConfigure("AcromagBMG","192.168.0.165:502",0,0,1)

## Configure Port connected to SWM Acromag - 952EN, Combo I/O module, Input range of +/-10 VDC, output range 0-20 mA
drvAsynIPPortConfigure("AcromagSWM","192.168.0.163:502",0,0,1)

## Configure Port connected to GDP Acromag - 952EN, Combo I/O module, Input range of +/-10 VDC, output range 0-20 mA
drvAsynIPPortConfigure("AcromagGDP","192.168.0.164:502",0,0,1)

##  Configure Port for Source-Extractor-Read Acromag 962EN-4006, 6 Channel Analog Input, Input range of +/-5 VDC
## Acromag used to read BCA-G signals

drvAsynIPPortConfigure("AcromagBCAG","192.168.0.161:502",0,0,1)







##################################################################################################################################################
###############Allow previous IP Ports created to support Modbus Protocol
##################################################################################################################################################
##                  modbusInterposeConfig("portName", linkType, timeOutmSec, writeDelaymSec)

##                  portName = Name of previously configured IP port to attach Modbus communication to
##                  LinkType = 0 - TCP/IP
##                                   1 - RTU Serial
##                                   2 - ASCII Serial
##                  timeOutmSec = time in milliseconds for asynOctet has to complete read/write operations before timeout is reached and operation is
##                            aborted
##                  writeDelayMSec = minimum delay in milliseconds between modbus writes, useful for RTU and ascii comm, set to 0 for tcp comm.


modbusInterposeConfig("AcromagBMG", 0, 1000, 0)

modbusInterposeConfig("AcromagSWM", 0, 1000, 0)

modbusInterposeConfig("AcromagGDP", 0, 1000, 0)

modbusInterposeConfig("AcromagBCAG", 0, 1000, 0)










##################################################################################################################################################
#####Configure Modbus Ports and assign them to IP Ports.  More than 1 Modbus port may be assigned to an IP Port
####################################################################################################################################
#drvModbusAsynConfigure(
#
#                      portName, - name of Modbus port to create
#
#                      tcpPortName, - name of previously created IP port to use  
#
#                      slaveAddress - For TCP communication the PLC ignores it so set to 0
#
#                      modbusFunction, - 1 Read Coil Status
#                                      - 2 Read Input Status
#                                      - 3 Read Holding Register
#                                      - 4 Read Input Register
#                                      - 5 Write Single Coil
#                                      - 6 Write Single Register
#                                      - 7 Read Exception Status
#                                      - 15 Write Multiple Coils (Requires additional Gensub code to put values in waveform record)
#                                      - 16 Write Multiple Registers (Requires additional Gensub code to put values in waveform record)
#                                      - 17 Report Slave ID
#
#                      modbusStartAddress, - Address in decimal or octal (add leading 0 if using octal e.g. 0177)
#
#                      modbusLength,  - number of 16 bit words to access for function codes 3,4,6,16, number of bits for codes 1,2,5,15
#
#                      dataType,     - Data format
#                                    - 0 UINT16, Unsigned 16bit Binary
#                                    - 1 INT16SM, 16 bit Binary, sign and magnitude.  Bit 15 is sign, 0-14 magnitude
#                                    - 2 BCD, unsigned
#                                    - 3 BCD, signed
#                                    - 4 INT16, signed 2's compliment
#                                    - 5 INT32_LE, 32 bit integer, little endian
#                                    - 6 INT32_LE, 32 bit integer, big endian
#                                    - 7 FLOAT32_LE, 32 bit floating point, little endian
#                                    - 8 FLOAT32_LE, 32 bit floating point, big endian
#                                    - 9 FLOAT64_LE, 64 bit floating point, little endian
#                                    - 10 FLOAT64_LE, 64 bit floating point, big endian
#
#                      pollMsec, - Polling delay time for read functions (This is the time resolution when using I/O interrupt scanning)
#
#                      plcType, - Any name, used in asynReport
#
##  

## Read and Write BMG Acromag
drvModbusAsynConfigure("BMGRead", "AcromagBMG",0,4,0,8,0,100,"Acromag")
drvModbusAsynConfigure("BMGWrite","AcromagBMG",0,6,100,1,0,100,"Acromag")


## Read and Write SWM Acromag
drvModbusAsynConfigure("SWMRead", "AcromagSWM",0,4,0,8,0,100,"Acromag")
drvModbusAsynConfigure("SWMWrite","AcromagSWM",0,6,100,1,0,100,"Acromag")



## Read and Write GDP Acromag
drvModbusAsynConfigure("GDPRead", "AcromagGDP",0,4,0,8,0,100,"Acromag")
drvModbusAsynConfigure("GDPWrite","AcromagGDP",0,6,100,1,0,100,"Acromag")


## Read extractor servo + gas servo + defl probe servo potentiometer values and (for now) Gas Flow Meter
drvModbusAsynConfigure("BCAGRead", "AcromagBCAG",0,4,0,15,0,100,"Acromag")


######################################################################################################################
#####################################Load BMG Records
######################################################################################################################

##Load BMG Records
dbLoadRecords("db/BMG/BMGInitialize.vdb","SubSys=BMG")

dbLoadRecords("db/BMG/BMGAnalog.vdb","SubSys=BMG, CurrMult=200.5, VoltReadMult=0.0075, CurrReadMult=.009987")

dbLoadRecords("db/BMG/BMGOnOff.vdb","SubSys=BMG")

dbLoadRecords("db/BMG/BMGCondition.vdb","SubSys=BMG")

dbLoadRecords("db/BMG/BMGParamSet.vdb","SubSys=BMG, Param=Curr,NoAttach=1,Mult=.001,EGU=A,PREC=2,PWZ=1.0,DRVH=100,DRVL=0")

dbLoadRecords("db/BMG/BMGBeamlineSelection.vdb","SubSys=BMG")

dbLoadRecords("db/BMG/BMGPrevent.vdb","PV=BMG:Output:Init,Msg=Init BMG,Reason=Beam On")

dbLoadRecords("db/BMG/BMGPrevent.vdb","PV=BMG:Output:Init:24Volt,Msg=Init BMG,Reason=No Control Voltage")

dbLoadTemplate("iocBoot/iocbeamline/BMGBeamlineLoadSetting.substitutions")


##Load SWM Records
dbLoadRecords("db/SWM/SWMInitialize.vdb","SubSys=SWM")

dbLoadRecords("db/SWM/SWMAnalog.vdb","SubSys=SWM, CurrMult=348.4, VoltReadMult=0.0075, CurrReadMult=.003035")

dbLoadRecords("db/SWM/SWMOnOff.vdb","SubSys=SWM")

dbLoadRecords("db/SWM/SWMCondition.vdb","SubSys=SWM")

dbLoadRecords("db/SWM/SWMParamSet.vdb","SubSys=SWM, Param=Curr,NoAttach=1,Mult=.00015,EGU=A,PREC=2,PWZ=0.3,DRVH=60,DRVL=0")

dbLoadRecords("db/SWM/SWMPolaritySwitch.vdb","SubSys=SWM")

dbLoadRecords("db/SWM/SWMRamp.vdb","SubSys=SWM")

dbLoadRecords("db/SWM/SWMBeamlineSelection.vdb","SubSys=SWM")

dbLoadRecords("db/SWM/SWMPrevent.vdb","PV=SWM:Output:Init,Msg=Init SWM,Reason=Beam On")

dbLoadRecords("db/SWM/SWMPrevent.vdb","PV=SWM:Output:Init:24Volt,Msg=Init SWM,Reason=No Control Voltage")

dbLoadRecords("db/SWM/SWMPrevent.vdb","PV=SWM:Ramp:On,Msg=Ramp SWM,Reason=SWM Off")

dbLoadRecords("db/SWM/SWMPrevent.vdb","PV=SWM:Ramp:Beam,Msg=Ramp SWM,Reason=Beam On")

dbLoadRecords("db/SWM/SWMPrevent.vdb","PV=SWM:Ramp:SD,Msg=Ramp SWM,Reason=SWM Shutting Down")

dbLoadTemplate("iocBoot/iocbeamline/SWMBeamlineLoadSetting.substitutions")



##Load GDP Records
dbLoadRecords("db/GDP/GDPInitialize.vdb","SubSys=GDP")

dbLoadRecords("db/GDP/GDPAnalog.vdb","SubSys=GDP, CurrMult=55.685, VoltReadMult=0.0075, CurrReadMult=.018703")

dbLoadRecords("db/GDP/GDPOnOff.vdb","SubSys=GDP")

dbLoadRecords("db/GDP/GDPCondition.vdb","SubSys=GDP")

dbLoadRecords("db/GDP/GDPParamSet.vdb","SubSys=GDP, Param=Curr,NoAttach=1,Mult=.001,EGU=A,PREC=2,PWZ=1.0,DRVH=375,DRVL=0")

dbLoadRecords("db/GDP/GDPBeamlineSelection.vdb","SubSys=GDP")

dbLoadRecords("db/GDP/GDPPrevent.vdb","PV=GDP:Output:Init,Msg=Init GDP,Reason=Beam On")

dbLoadRecords("db/GDP/GDPPrevent.vdb","PV=GDP:Output:Init:24Volt,Msg=Init GDP,Reason=No Control Voltage")











## Load record instances

dbLoadRecords("db/BeamlineControlSystemSB1SB2.vdb", "SubSys=BeamlineControl")

dbLoadRecords("db/BeamlineSystemReset.vdb")


##Load SM01 Records

dbLoadRecords("db/SM01/SM01OnOff.vdb", "Param=Curr, Group=SM01")

dbLoadRecords("db/SM01/SM01MultiOffSeq.vdb", "Device=X0, Param=Curr, Group=SM01")
dbLoadRecords("db/SM01/SM01MultiOffSeq.vdb", "Device=X1, Param=Curr, Group=SM01")
dbLoadRecords("db/SM01/SM01MultiOffSeq.vdb", "Device=Y1, Param=Curr, Group=SM01")

dbLoadRecords("db/SM01/SM01Initialize.vdb", "Group=SM01")

dbLoadRecords("db/SM01/SM01InitializeSupply.vdb", "Group=SM01, Device=X0, R=1, AsynPort=SM01Gateway")
dbLoadRecords("db/SM01/SM01InitializeSupply.vdb", "Group=SM01, Device=X1, R=2, AsynPort=SM01Gateway")
dbLoadRecords("db/SM01/SM01InitializeSupply.vdb", "Group=SM01, Device=Y1, R=3, AsynPort=SM01Gateway")

dbLoadRecords("db/SM01/SM01Condition.vdb","Param=Curr, Group=SM01")

dbLoadRecords("db/SM01/SM01BeamInterlockCondition.vdb","Device=X0, Param=Curr, Group=SM01")
dbLoadRecords("db/SM01/SM01BeamInterlockCondition.vdb","Device=X1, Param=Curr, Group=SM01")
dbLoadRecords("db/SM01/SM01BeamInterlockCondition.vdb","Device=Y1, Param=Curr, Group=SM01")

dbLoadRecords("db/SM01/SM01ParamSet.vdb","Group=SM01, Device=X0, Param=Curr, NoAttach=1,Mult=.0002,EGU=A,PREC=2,PWZ=.2,DRVH=2,DRVL=-2")
dbLoadRecords("db/SM01/SM01ParamSet.vdb","Group=SM01, Device=X1, Param=Curr, NoAttach=1,Mult=.0002,EGU=A,PREC=2,PWZ=.2,DRVH=2,DRVL=-2")
dbLoadRecords("db/SM01/SM01ParamSet.vdb","Group=SM01, Device=Y1, Param=Curr, NoAttach=1,Mult=.0002,EGU=A,PREC=2,PWZ=.2,DRVH=2,DRVL=-2")

dbLoadRecords("db/SM01/SM01Analog.vdb", "Device=X0, Param=Curr,Group=SM01, R=1, AsynPort=SM01Gateway, Prec=2")
dbLoadRecords("db/SM01/SM01Analog.vdb", "Device=X1, Param=Curr,Group=SM01, R=2, AsynPort=SM01Gateway, Prec=2")
dbLoadRecords("db/SM01/SM01Analog.vdb", "Device=Y1, Param=Curr,Group=SM01, R=3, AsynPort=SM01Gateway, Prec=2")

dbLoadRecords("db/SM01/SM01ControlSeq.vdb", "Group=SM01")

## These create messages when pressed that say "Cannot $(Msg), $(Reason)." They are used to disable buttons (Ex. Init)
dbLoadRecords("db/SM01/SM01Prevent.vdb","PV=SM01:BeamOn:Init,Msg=Init SM01,Reason=Beam On")
dbLoadRecords("db/SM01/SM01Prevent.vdb","PV=SM01:NotOn:Init,Msg=Init SM01,Reason=Not On")




###New records for SM23A. Uses same philsophy as SM01

dbLoadRecords("db/SM23A/SM23AOnOff.vdb", "Param=Curr, Group=SM23A")

dbLoadRecords("db/SM23A/SM23AMultiOffSeq.vdb", "Device=X2, Param=Curr, Group=SM23A")
dbLoadRecords("db/SM23A/SM23AMultiOffSeq.vdb", "Device=Y2, Param=Curr, Group=SM23A")
dbLoadRecords("db/SM23A/SM23AMultiOffSeq.vdb", "Device=X3, Param=Curr, Group=SM23A")
dbLoadRecords("db/SM23A/SM23AMultiOffSeq.vdb", "Device=Y3, Param=Curr, Group=SM23A")

dbLoadRecords("db/SM23A/SM23AInitialize.vdb", "Group=SM23A")

dbLoadRecords("db/SM23A/SM23AInitializeSupply.vdb", "Group=SM23A, Device=X2, R=1, AsynPort=SM23AGateway")
dbLoadRecords("db/SM23A/SM23AInitializeSupply.vdb", "Group=SM23A, Device=Y2, R=3, AsynPort=SM23AGateway")
dbLoadRecords("db/SM23A/SM23AInitializeSupply.vdb", "Group=SM23A, Device=X3, R=2, AsynPort=SM23AGateway")
dbLoadRecords("db/SM23A/SM23AInitializeSupply.vdb", "Group=SM23A, Device=Y3, R=4, AsynPort=SM23AGateway")

dbLoadRecords("db/SM23A/SM23ACondition.vdb","Param=Curr, Group=SM23A")

dbLoadRecords("db/SM23A/SM23ABeamInterlockCondition.vdb","Device=X2, Param=Curr, Group=SM23A")
dbLoadRecords("db/SM23A/SM23ABeamInterlockCondition.vdb","Device=Y2, Param=Curr, Group=SM23A")
dbLoadRecords("db/SM23A/SM23ABeamInterlockCondition.vdb","Device=X3, Param=Curr, Group=SM23A")
dbLoadRecords("db/SM23A/SM23ABeamInterlockCondition.vdb","Device=Y3, Param=Curr, Group=SM23A")

dbLoadRecords("db/SM23A/SM23AParamSet.vdb","Group=SM23A, Device=X2, Param=Curr, NoAttach=1,Mult=.0002,EGU=A,PREC=2,PWZ=.5,DRVH=1.3,DRVL=-1.3")
dbLoadRecords("db/SM23A/SM23AParamSet.vdb","Group=SM23A, Device=Y2, Param=Curr, NoAttach=1,Mult=.0002,EGU=A,PREC=2,PWZ=.5,DRVH=1.3,DRVL=-1.3")
dbLoadRecords("db/SM23A/SM23AParamSet.vdb","Group=SM23A, Device=X3, Param=Curr, NoAttach=1,Mult=.0002,EGU=A,PREC=2,PWZ=.5,DRVH=1.3,DRVL=-1.3")
dbLoadRecords("db/SM23A/SM23AParamSet.vdb","Group=SM23A, Device=Y3, Param=Curr, NoAttach=1,Mult=.0002,EGU=A,PREC=2,PWZ=.5,DRVH=1.3,DRVL=-1.3")

dbLoadRecords("db/SM23A/SM23AAnalog.vdb", "Device=X2, Param=Curr,Group=SM23A, R=1, AsynPort=SM23AGateway, Prec=2")
dbLoadRecords("db/SM23A/SM23AAnalog.vdb", "Device=Y2, Param=Curr,Group=SM23A, R=2, AsynPort=SM23AGateway, Prec=2")
dbLoadRecords("db/SM23A/SM23AAnalog.vdb", "Device=X3, Param=Curr,Group=SM23A, R=3, AsynPort=SM23AGateway, Prec=2")
dbLoadRecords("db/SM23A/SM23AAnalog.vdb", "Device=Y3, Param=Curr,Group=SM23A, R=4, AsynPort=SM23AGateway, Prec=2")

dbLoadRecords("db/SM23A/SM23AControlSeq.vdb", "Group=SM23A")

dbLoadRecords("db/SM23A/SM23ABeamlineSelection.vdb","SubSys=SM23A")

## These create messages when pressed that say "Cannot $(Msg), $(Reason)." They are used to disable buttons (Ex. Init)
dbLoadRecords("db/SM23A/SM23APrevent.vdb","PV=SM23A:BeamOn:Init,Msg=Init SM23A,Reason=Beam On")
dbLoadRecords("db/SM23A/SM23APrevent.vdb","PV=SM23A:NotOn:Init,Msg=Init SM23A,Reason=Not On")



###New records for Gantry Correction Coil. Identical to SM23A

dbLoadRecords("db/GCC/GCCOnOff.vdb", "Param=Curr, Group=GCC")

dbLoadRecords("db/GCC/GCCMultiOffSeq.vdb", "Param=Curr, Group=GCC")

dbLoadRecords("db/GCC/GCCInitialize.vdb", "Group=GCC")

dbLoadRecords("db/GCC/GCCInitializeSupply.vdb", "Group=GCC, R=1, AsynPort=GCCGateway")

dbLoadRecords("db/GCC/GCCCondition.vdb","Param=Curr, Group=GCC")

dbLoadRecords("db/GCC/GCCBeamInterlockCondition.vdb","Device=, Param=Curr, Group=GCC")

dbLoadRecords("db/GCC/GCCParamSet.vdb","Group=GCC, Param=Curr, NoAttach=1,Mult=.0002,EGU=A,PREC=2,PWZ=.5,DRVH=1.3,DRVL=-1.3")

dbLoadRecords("db/GCC/GCCAnalog.vdb","Param=Curr, Group=GCC, R=1, AsynPort=GCCGateway, Prec=2")

dbLoadRecords("db/GCC/GCCControlSeq.vdb", "Group=GCC")

dbLoadRecords("db/GCC/GCCBeamlineSelection.vdb","SubSys=GCC")

## These create messages when pressed that say "Cannot $(Msg), $(Reason)." They are used to disable buttons (Ex. Init)
dbLoadRecords("db/GCC/GCCPrevent.vdb","PV=GCC:BeamOn:Init,Msg=Init GCC,Reason=Beam On")


###New records for Q1. Uses same philsophy as SM23A

dbLoadRecords("db/Q1/Q1OnOff.vdb", "Param=Curr, SubSys=Q1")

dbLoadRecords("db/Q1/Q1MultiOffSeq.vdb", "Device=Lens1, Param=Curr, SubSys=Q1")
dbLoadRecords("db/Q1/Q1MultiOffSeq.vdb", "Device=Lens2, Param=Curr, SubSys=Q1")
dbLoadRecords("db/Q1/Q1MultiOffSeq.vdb", "Device=Lens3, Param=Curr, SubSys=Q1")

dbLoadRecords("db/Q1/Q1Initialize.vdb", "SubSys=Q1")

dbLoadRecords("db/Q1/Q1InitializeSupply.vdb", "SubSys=Q1, Device=Lens1, R=1, AsynPort=Q1Gateway, InitVolt=19")
dbLoadRecords("db/Q1/Q1InitializeSupply.vdb", "SubSys=Q1, Device=Lens2, R=2, AsynPort=Q1Gateway, InitVolt=19")
dbLoadRecords("db/Q1/Q1InitializeSupply.vdb", "SubSys=Q1, Device=Lens3, R=3, AsynPort=Q1Gateway, InitVolt=19")

dbLoadRecords("db/Q1/Q1Condition.vdb","Param=Curr, SubSys=Q1")

dbLoadRecords("db/Q1/Q1BeamInterlockCondition.vdb","Device=Lens1, Param=Curr, SubSys=Q1")
dbLoadRecords("db/Q1/Q1BeamInterlockCondition.vdb","Device=Lens2, Param=Curr, SubSys=Q1")
dbLoadRecords("db/Q1/Q1BeamInterlockCondition.vdb","Device=Lens3, Param=Curr, SubSys=Q1")

dbLoadRecords("db/Q1/Q1ParamSet.vdb","SubSys=Q1, Device=Lens1, Param=Curr, NoAttach=1,Mult=.0002,EGU=A,PREC=2,PWZ=.5,DRVH=35,DRVL=-0.01")
dbLoadRecords("db/Q1/Q1ParamSet.vdb","SubSys=Q1, Device=Lens2, Param=Curr, NoAttach=1,Mult=.0002,EGU=A,PREC=2,PWZ=.5,DRVH=35,DRVL=-0.01")
dbLoadRecords("db/Q1/Q1ParamSet.vdb","SubSys=Q1, Device=Lens3, Param=Curr, NoAttach=1,Mult=.0002,EGU=A,PREC=2,PWZ=.5,DRVH=35,DRVL=-0.01")

dbLoadRecords("db/Q1/Q1Analog.vdb", "Device=Lens1, Param=Curr,SubSys=Q1, R=1, AsynPort=Q1Gateway, Prec=2")
dbLoadRecords("db/Q1/Q1Analog.vdb", "Device=Lens2, Param=Curr,SubSys=Q1, R=2, AsynPort=Q1Gateway, Prec=2")
dbLoadRecords("db/Q1/Q1Analog.vdb", "Device=Lens3, Param=Curr,SubSys=Q1, R=3, AsynPort=Q1Gateway, Prec=2")

dbLoadRecords("db/Q1/Q1ControlSeq.vdb", "SubSys=Q1")

dbLoadRecords("db/Q1/Q1PolaritySwitch.vdb","SubSys=Q1, Device=Lens1")
dbLoadRecords("db/Q1/Q1PolaritySwitch.vdb","SubSys=Q1, Device=Lens2")
dbLoadRecords("db/Q1/Q1PolaritySwitch.vdb","SubSys=Q1, Device=Lens3")

## These create messages when pressed that say "Cannot $(Msg), $(Reason)." They are used to disable buttons (Ex. Init)
dbLoadRecords("db/Q1/Q1Prevent.vdb","PV=Q1:BeamOn:Init,Msg=Init Q1,Reason=Beam On")
dbLoadRecords("db/Q1/Q1Prevent.vdb","PV=Q1:NotOn:Init,Msg=Init Q1,Reason=Not On")
dbLoadRecords("db/Q1/Q1Prevent.vdb","PV=Q1:Output:Init:24Volt,Msg=Init Q1,Reason=No Control Voltage")
#These need to be replaced with those used for the bmg/swm/gdp. get fc1 or beam path open stuff.

dbLoadRecords("db/Q1/Q1Temp.vdb","SubSys=Q1")
#Temporary until mod1 changes made.


###New records for QG. Uses same philsophy as SM23A

dbLoadRecords("db/QG/QGOnOff.vdb", "Param=Curr, SubSys=QG")

dbLoadRecords("db/QG/QGMultiOffSeq.vdb", "Device=Lens1, Param=Curr, SubSys=QG")
dbLoadRecords("db/QG/QGMultiOffSeq.vdb", "Device=Lens2, Param=Curr, SubSys=QG")
dbLoadRecords("db/QG/QGMultiOffSeq.vdb", "Device=Lens3, Param=Curr, SubSys=QG")

dbLoadRecords("db/QG/QGInitialize.vdb", "SubSys=QG")

dbLoadRecords("db/QG/QGInitializeSupply.vdb", "SubSys=QG, Device=Lens1, R=1, AsynPort=QGGateway, InitVolt=10")
dbLoadRecords("db/QG/QGInitializeSupply.vdb", "SubSys=QG, Device=Lens2, R=2, AsynPort=QGGateway, InitVolt=10")
dbLoadRecords("db/QG/QGInitializeSupply.vdb", "SubSys=QG, Device=Lens3, R=3, AsynPort=QGGateway, InitVolt=10")

dbLoadRecords("db/QG/QGCondition.vdb","Param=Curr, SubSys=QG")

dbLoadRecords("db/QG/QGBeamInterlockCondition.vdb","Device=Lens1, Param=Curr, SubSys=QG")
dbLoadRecords("db/QG/QGBeamInterlockCondition.vdb","Device=Lens2, Param=Curr, SubSys=QG")
dbLoadRecords("db/QG/QGBeamInterlockCondition.vdb","Device=Lens3, Param=Curr, SubSys=QG")

dbLoadRecords("db/QG/QGParamSet.vdb","SubSys=QG, Device=Lens1, Param=Curr, NoAttach=1,Mult=.0002,EGU=A,PREC=2,PWZ=.5,DRVH=35,DRVL=-0.01")
dbLoadRecords("db/QG/QGParamSet.vdb","SubSys=QG, Device=Lens2, Param=Curr, NoAttach=1,Mult=.0002,EGU=A,PREC=2,PWZ=.5,DRVH=35,DRVL=-0.01")
dbLoadRecords("db/QG/QGParamSet.vdb","SubSys=QG, Device=Lens3, Param=Curr, NoAttach=1,Mult=.0002,EGU=A,PREC=2,PWZ=.5,DRVH=35,DRVL=-0.01")

dbLoadRecords("db/QG/QGAnalog.vdb", "Device=Lens1, Param=Curr,SubSys=QG, R=1, AsynPort=QGGateway, Prec=2")
dbLoadRecords("db/QG/QGAnalog.vdb", "Device=Lens2, Param=Curr,SubSys=QG, R=2, AsynPort=QGGateway, Prec=2")
dbLoadRecords("db/QG/QGAnalog.vdb", "Device=Lens3, Param=Curr,SubSys=QG, R=3, AsynPort=QGGateway, Prec=2")

dbLoadRecords("db/QG/QGControlSeq.vdb", "SubSys=QG")

dbLoadRecords("db/QG/QGPolaritySwitch.vdb","SubSys=QG, Device=Lens1")
dbLoadRecords("db/QG/QGPolaritySwitch.vdb","SubSys=QG, Device=Lens2")
dbLoadRecords("db/QG/QGPolaritySwitch.vdb","SubSys=QG, Device=Lens3")

dbLoadRecords("db/QG/QGBeamlineSelection.vdb","SubSys=QG")

## These create messages when pressed that say "Cannot $(Msg), $(Reason)." They are used to disable buttons (Ex. Init)
dbLoadRecords("db/QG/QGPrevent.vdb","PV=QG:BeamOn:Init,Msg=Init QG,Reason=Beam On")
dbLoadRecords("db/QG/QGPrevent.vdb","PV=QG:NotOn:Init,Msg=Init QG,Reason=Not On")
dbLoadRecords("db/QG/QGPrevent.vdb","PV=QG:Output:Init:24Volt,Msg=Init QG,Reason=No Control Voltage")
#These need to be replaced with those used for the bmg/swm/gdp. get fc1 or beam path open stuff.

dbLoadRecords("db/QG/QGTemp.vdb","SubSys=QG")
#Temporary until mod1 changes made.



###New records for Q2A. Uses same philsophy as SM23A

dbLoadRecords("db/Q23A/Q23AOnOff.vdb", "Param=Curr, SubSys=Q23A")

dbLoadRecords("db/Q23A/Q23AMultiOffSeq.vdb", "Device=Q2A:Lens13, Param=Curr, SubSys=Q23A")
dbLoadRecords("db/Q23A/Q23AMultiOffSeq.vdb", "Device=Q2A:Lens2, Param=Curr, SubSys=Q23A")
dbLoadRecords("db/Q23A/Q23AMultiOffSeq.vdb", "Device=Q3A:Lens13, Param=Curr, SubSys=Q23A")
dbLoadRecords("db/Q23A/Q23AMultiOffSeq.vdb", "Device=Q3A:Lens2, Param=Curr, SubSys=Q23A")

dbLoadRecords("db/Q23A/Q23AInitialize.vdb", "SubSys=Q23A")

dbLoadRecords("db/Q23A/Q23AInitializeSupply.vdb", "SubSys=Q23A, Device=Q2A:Lens13, R=1, AsynPort=Q23AGateway, InitVolt=19")
dbLoadRecords("db/Q23A/Q23AInitializeSupply.vdb", "SubSys=Q23A, Device=Q2A:Lens2, R=2, AsynPort=Q23AGateway, InitVolt=19")
dbLoadRecords("db/Q23A/Q23AInitializeSupply.vdb", "SubSys=Q23A, Device=Q3A:Lens13, R=3, AsynPort=Q23AGateway, InitVolt=19")
dbLoadRecords("db/Q23A/Q23AInitializeSupply.vdb", "SubSys=Q23A, Device=Q3A:Lens2, R=4, AsynPort=Q23AGateway, InitVolt=19")

dbLoadRecords("db/Q23A/Q23ACondition.vdb","Param=Curr, SubSys=Q23A")

dbLoadRecords("db/Q23A/Q23ABeamInterlockCondition.vdb","Device=Q2A:Lens13, Param=Curr, SubSys=Q23A")
dbLoadRecords("db/Q23A/Q23ABeamInterlockCondition.vdb","Device=Q2A:Lens2, Param=Curr, SubSys=Q23A")
dbLoadRecords("db/Q23A/Q23ABeamInterlockCondition.vdb","Device=Q3A:Lens13, Param=Curr, SubSys=Q23A")
dbLoadRecords("db/Q23A/Q23ABeamInterlockCondition.vdb","Device=Q3A:Lens2, Param=Curr, SubSys=Q23A")

dbLoadRecords("db/Q23A/Q23AParamSet.vdb","SubSys=Q23A, Device=Q2A:Lens13, Param=Curr, NoAttach=1,Mult=.0002,EGU=A,PREC=2,PWZ=.5,DRVH=35,DRVL=-0.01")
dbLoadRecords("db/Q23A/Q23AParamSet.vdb","SubSys=Q23A, Device=Q2A:Lens2, Param=Curr, NoAttach=1,Mult=.0002,EGU=A,PREC=2,PWZ=.5,DRVH=35,DRVL=-0.01")
dbLoadRecords("db/Q23A/Q23AParamSet.vdb","SubSys=Q23A, Device=Q3A:Lens13, Param=Curr, NoAttach=1,Mult=.0002,EGU=A,PREC=2,PWZ=.5,DRVH=35,DRVL=-0.01")
dbLoadRecords("db/Q23A/Q23AParamSet.vdb","SubSys=Q23A, Device=Q3A:Lens2, Param=Curr, NoAttach=1,Mult=.0002,EGU=A,PREC=2,PWZ=.5,DRVH=35,DRVL=-0.01")

dbLoadRecords("db/Q23A/Q23AAnalog.vdb", "Device=Q2A:Lens13, Param=Curr,SubSys=Q23A, R=1, AsynPort=Q23AGateway, Prec=2")
dbLoadRecords("db/Q23A/Q23AAnalog.vdb", "Device=Q2A:Lens2, Param=Curr,SubSys=Q23A, R=2, AsynPort=Q23AGateway, Prec=2")
dbLoadRecords("db/Q23A/Q23AAnalog.vdb", "Device=Q3A:Lens13, Param=Curr,SubSys=Q23A, R=3, AsynPort=Q23AGateway, Prec=2")
dbLoadRecords("db/Q23A/Q23AAnalog.vdb", "Device=Q3A:Lens2, Param=Curr,SubSys=Q23A, R=4, AsynPort=Q23AGateway, Prec=2")

dbLoadRecords("db/Q23A/Q23AControlSeq.vdb", "SubSys=Q23A")

dbLoadRecords("db/Q23A/Q23APolaritySwitch.vdb","SubSys=Q23A, Device=Q2A:Lens13")
dbLoadRecords("db/Q23A/Q23APolaritySwitch.vdb","SubSys=Q23A, Device=Q2A:Lens2")
dbLoadRecords("db/Q23A/Q23APolaritySwitch.vdb","SubSys=Q23A, Device=Q3A:Lens13")
dbLoadRecords("db/Q23A/Q23APolaritySwitch.vdb","SubSys=Q23A, Device=Q3A:Lens2")

dbLoadRecords("db/Q23A/Q23ABeamlineSelection.vdb","SubSys=Q23A")

## These create messages when pressed that say "Cannot $(Msg), $(Reason)." They are used to disable buttons (Ex. Init)
dbLoadRecords("db/Q23A/Q23APrevent.vdb","PV=Q23A:BeamOn:Init,Msg=Init Q23A,Reason=Beam On")
dbLoadRecords("db/Q23A/Q23APrevent.vdb","PV=Q23A:NotOn:Init,Msg=Init Q23A,Reason=Not On")
dbLoadRecords("db/Q23A/Q23APrevent.vdb","PV=Q23A:Output:Init:24Volt,Msg=Init Q23A,Reason=No Control Voltage")
#These need to be replaced with those used for the bmg/swm/gdp. get fc1 or beam path open stuff.

dbLoadRecords("db/Q23A/Q23ATemp.vdb","SubSys=Q23A")
#Temporary until mod1 changes made.


###New records for Q2B. Uses same philsophy as SM23A

dbLoadRecords("db/Q23B/Q23BOnOff.vdb", "Param=Curr, SubSys=Q23B")

dbLoadRecords("db/Q23B/Q23BMultiOffSeq.vdb", "Device=Q2B:Lens13, Param=Curr, SubSys=Q23B")
dbLoadRecords("db/Q23B/Q23BMultiOffSeq.vdb", "Device=Q2B:Lens2, Param=Curr, SubSys=Q23B")
dbLoadRecords("db/Q23B/Q23BMultiOffSeq.vdb", "Device=Q3B:Lens13, Param=Curr, SubSys=Q23B")
dbLoadRecords("db/Q23B/Q23BMultiOffSeq.vdb", "Device=Q3B:Lens2, Param=Curr, SubSys=Q23B")

dbLoadRecords("db/Q23B/Q23BInitialize.vdb", "SubSys=Q23B")

dbLoadRecords("db/Q23B/Q23BInitializeSupply.vdb", "SubSys=Q23B, Device=Q2B:Lens13, R=1, AsynPort=Q23BGateway, InitVolt=19")
dbLoadRecords("db/Q23B/Q23BInitializeSupply.vdb", "SubSys=Q23B, Device=Q2B:Lens2, R=2, AsynPort=Q23BGateway, InitVolt=19")
dbLoadRecords("db/Q23B/Q23BInitializeSupply.vdb", "SubSys=Q23B, Device=Q3B:Lens13, R=3, AsynPort=Q23BGateway, InitVolt=19")
dbLoadRecords("db/Q23B/Q23BInitializeSupply.vdb", "SubSys=Q23B, Device=Q3B:Lens2, R=4, AsynPort=Q23BGateway, InitVolt=19")

dbLoadRecords("db/Q23B/Q23BCondition.vdb","Param=Curr, SubSys=Q23B")

dbLoadRecords("db/Q23B/Q23BBeamInterlockCondition.vdb","Device=Q2B:Lens13, Param=Curr, SubSys=Q23B")
dbLoadRecords("db/Q23B/Q23BBeamInterlockCondition.vdb","Device=Q2B:Lens2, Param=Curr, SubSys=Q23B")
dbLoadRecords("db/Q23B/Q23BBeamInterlockCondition.vdb","Device=Q3B:Lens13, Param=Curr, SubSys=Q23B")
dbLoadRecords("db/Q23B/Q23BBeamInterlockCondition.vdb","Device=Q3B:Lens2, Param=Curr, SubSys=Q23B")

dbLoadRecords("db/Q23B/Q23BParamSet.vdb","SubSys=Q23B, Device=Q2B:Lens13, Param=Curr, NoAttach=1,Mult=.0002,EGU=A,PREC=2,PWZ=.5,DRVH=35,DRVL=-0.01")
dbLoadRecords("db/Q23B/Q23BParamSet.vdb","SubSys=Q23B, Device=Q2B:Lens2, Param=Curr, NoAttach=1,Mult=.0002,EGU=A,PREC=2,PWZ=.5,DRVH=35,DRVL=-0.01")
dbLoadRecords("db/Q23B/Q23BParamSet.vdb","SubSys=Q23B, Device=Q3B:Lens13, Param=Curr, NoAttach=1,Mult=.0002,EGU=A,PREC=2,PWZ=.5,DRVH=35,DRVL=-0.01")
dbLoadRecords("db/Q23B/Q23BParamSet.vdb","SubSys=Q23B, Device=Q3B:Lens2, Param=Curr, NoAttach=1,Mult=.0002,EGU=A,PREC=2,PWZ=.5,DRVH=35,DRVL=-0.01")

dbLoadRecords("db/Q23B/Q23BAnalog.vdb", "Device=Q2B:Lens13, Param=Curr,SubSys=Q23B, R=1, AsynPort=Q23BGateway, Prec=2")
dbLoadRecords("db/Q23B/Q23BAnalog.vdb", "Device=Q2B:Lens2, Param=Curr,SubSys=Q23B, R=2, AsynPort=Q23BGateway, Prec=2")
dbLoadRecords("db/Q23B/Q23BAnalog.vdb", "Device=Q3B:Lens13, Param=Curr,SubSys=Q23B, R=3, AsynPort=Q23BGateway, Prec=2")
dbLoadRecords("db/Q23B/Q23BAnalog.vdb", "Device=Q3B:Lens2, Param=Curr,SubSys=Q23B, R=4, AsynPort=Q23BGateway, Prec=2")

dbLoadRecords("db/Q23B/Q23BControlSeq.vdb", "SubSys=Q23B")

dbLoadRecords("db/Q23B/Q23BPolaritySwitch.vdb","SubSys=Q23B, Device=Q2B:Lens13")
dbLoadRecords("db/Q23B/Q23BPolaritySwitch.vdb","SubSys=Q23B, Device=Q2B:Lens2")
dbLoadRecords("db/Q23B/Q23BPolaritySwitch.vdb","SubSys=Q23B, Device=Q3B:Lens13")
dbLoadRecords("db/Q23B/Q23BPolaritySwitch.vdb","SubSys=Q23B, Device=Q3B:Lens2")

dbLoadRecords("db/Q23B/Q23BBeamlineSelection.vdb","SubSys=Q23B")

## These create messages when pressed that say "Cannot $(Msg), $(Reason)." They are used to disable buttons (Ex. Init)
dbLoadRecords("db/Q23B/Q23BPrevent.vdb","PV=Q23B:BeamOn:Init,Msg=Init Q23B,Reason=Beam On")
dbLoadRecords("db/Q23B/Q23BPrevent.vdb","PV=Q23B:NotOn:Init,Msg=Init Q23B,Reason=Not On")
dbLoadRecords("db/Q23B/Q23BPrevent.vdb","PV=Q23B:Output:Init:24Volt,Msg=Init Q23B,Reason=No Control Voltage")
#These need to be replaced with those used for the bmg/swm/gdp. get fc1 or beam path open stuff.

dbLoadRecords("db/Q23B/Q23BTemp.vdb","SubSys=Q23B")
#Temporary until mod1 changes made.




###Read BCA-G

dbLoadRecords("db/BCAG/BCAGInitialize.vdb","SubSys=BCAG")

dbLoadRecords("db/BCAG/BCAGAnalog.vdb","SubSys=BCAG, TargetReadMult=0.0050256, QuadUpReadMult=0.000157, QuadDownReadMult=0.000157, QuadLeftReadMult=0.000157, QuadRightReadMult=0.000157, SBDGReadMult=0.000157")

dbLoadRecords("db/BCAG/BCAGCondition.vdb","SubSys=BCAG")

dbLoadRecords("db/BCAG/BCAGPrevent.vdb","PV=BCAG:BeamOn:Init,Msg=Init Q1,Reason=Beam On"




################################################################################New records for XGSteerer.

dbLoadRecords("db/IGS/IGSOnOff.vdb", "SubSys=IGS")

dbLoadRecords("db/IGS/IGSInitialize.vdb", "SubSys=IGS")

dbLoadRecords("db/IGS/IGSInitializeSupply.vdb", "SubSys=IGS, Device=XG, AsynPort=XGSteerer, Phase=0")
dbLoadRecords("db/IGS/IGSInitializeSupply.vdb", "SubSys=IGS, Device=YG, AsynPort=YGSteerer, Phase=90")

dbLoadRecords("db/IGS/IGSCondition.vdb","SubSys=IGS")

dbLoadRecords("db/IGS/IGSBeamlineSelection.vdb","SubSys=IGS")

dbLoadRecords("db/IGS/IGSBeamInterlockCondition.vdb","SubSys=IGS, Device=XG")
dbLoadRecords("db/IGS/IGSBeamInterlockCondition.vdb","SubSys=IGS, Device=YG")

dbLoadRecords("db/IGS/IGSParamSetFB.vdb", "SubSys=IGS, Device=XG, Param=DCCurr, NoAttach=1, Mult=.0002,EGU=A, PREC=2, PWZ=.5, DRVH=10, DRVL=-10, FBMult=0.2, FB1=QuadRight, FB2=QuadLeft")
dbLoadRecords("db/IGS/IGSParamSet.vdb", "SubSys=IGS, Device=XG, Param=ACCurr, NoAttach=1, Mult=.0002,EGU=A, PREC=2, PWZ=.5, DRVH=20, DRVL=0")
dbLoadRecords("db/IGS/IGSParamSetFB.vdb", "SubSys=IGS, Device=YG, Param=DCCurr, NoAttach=1, Mult=.0002,EGU=A, PREC=2, PWZ=.5, DRVH=10, DRVL=-10, FBMult=0.2, FB1=QuadUp, FB2=QuadDown")
dbLoadRecords("db/IGS/IGSParamSet.vdb", "SubSys=IGS, Device=YG, Param=ACCurr, NoAttach=1, Mult=.0002,EGU=A, PREC=2, PWZ=.5, DRVH=20, DRVL=0")

dbLoadRecords("db/IGS/IGSAnalog1.vdb", "SubSys=IGS, Device=XG, AsynPort=XGSteerer, ACCurrMult=1.32, PHASE=0")
dbLoadRecords("db/IGS/IGSAnalog1.vdb", "SubSys=IGS, Device=YG, AsynPort=YGSteerer, ACCurrMult=1.4, PHASE=90")

dbLoadRecords("db/IGS/IGSAnalog2.vdb", "SubSys=IGS, Device=XG")
dbLoadRecords("db/IGS/IGSAnalog2.vdb", "SubSys=IGS, Device=YG")

dbLoadRecords("db/IGS/IGSControlSeq.vdb", "SubSys=IGS")

dbLoadRecords("db/IGS/IGSMultiOffSeq.vdb", "Device=XG, Param=DCCurr, SubSys=IGS")
dbLoadRecords("db/IGS/IGSMultiOffSeq.vdb", "Device=XG, Param=ACCurr, SubSys=IGS")
dbLoadRecords("db/IGS/IGSMultiOffSeq.vdb", "Device=YG, Param=DCCurr, SubSys=IGS")
dbLoadRecords("db/IGS/IGSMultiOffSeq.vdb", "Device=YG, Param=ACCurr, SubSys=IGS")

## These create messages when pressed that say "Cannot $(Msg), $(Reason)." They are used to disable buttons (Ex. Init)
dbLoadRecords("db/IGS/IGSPrevent.vdb","PV=IGS:BeamOn:Init,Msg=Init IGS,Reason=Beam On")
dbLoadRecords("db/IGS/IGSPrevent.vdb","PV=IGS:NotOn:Init,Msg=Init IGS,Reason=Not On")
dbLoadRecords("db/IGS/IGSPrevent.vdb","PV=IGS:Output:Init:24Volt,Msg=Init IGS,Reason=No Control Voltage")


#########################################################################################New record to turn on/off the Main Probe Position Controller

dbLoadRecords("db/MPPC/MPPCOnOff.vdb", "Group=MPPC")



dbLoadRecords("db/bcac.vdb")


##This is the database that sends messages to the CCC if the SBD's are tripped.
dbLoadRecords("db/BCATripReport.vdb")


##Creates two pvs to tell how open the beam path is
dbLoadRecords("db/BeamPathOpen.vdb")




dbLoadRecords("db/IocHeartbeat.vdb", "SubSys=BeamlineCtl")


## Set this to see messages from mySub
var mySubDebug 1

iocInit()

## Start any sequence programs
#seq beamlineSnc,"user=webert2Host"
