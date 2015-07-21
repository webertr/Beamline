TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

PROD_IOC = beamline
DBD = beamline.dbd

beamline_DBD += commonInclude.dbd
beamline_DBD += beamlineSub.dbd

# <name>_registerRecordDeviceDriver.cpp will be created from <name>.dbd
beamline_SRCS += beamline_registerRecordDeviceDriver.cpp
beamline_SRCS += beamlineMain.cpp

# Add locally compiled object code
beamline_SRCS += beamlineSub.c

beamline_LIBS += asyn calc sscan modbus seq autosave

#===========================
# for the sequencer.

ifneq ($(SNCSEQ),)
    # This builds snltest as a component of test
    beamline_SNCFLAGS += +r
    beamline_DBD += beamlineSnc.dbd
    beamline_SRCS += beamlineSncLib.st
    #beamline_LIBS += seq pv pvCa ca Com
    beamline_LIBS += seq pv ca Com

    # The following builds snltestProg as a standalone application
    PROD_HOST += beamlineSncProg
    beamlineSncProg_SNCFLAGS += +m
    beamlineSncProg_SRCS += beamlineSncProg.st
    #beamlineSncProg_LIBS += seq pv pvCa ca Com
    beamlineSncProg_LIBS += seq pv ca Com
    beamlineSncProg_LIBS += $(EPICS_BASE_HOST_LIBS)
endif

beamline_LIBS += $(EPICS_BASE_IOC_LIBS)
#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE
