SIM ?= icarus
TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += $(PWD)/tb_master_slave_interface.v
VERILOG_SOURCES += $(PWD)/master.v
VERILOG_SOURCES += $(PWD)/slave.v

run:
	rm -rf sim_build/
	$(MAKE) sim MODULE=test_master_slave_interface TOPLEVEL=tb_master_slave_interface
include $(shell cocotb-config --makefiles)/Makefile.sim
