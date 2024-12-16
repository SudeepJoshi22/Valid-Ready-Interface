SIM ?= icarus
TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += $(PWD)/tb_pipeline.v
VERILOG_SOURCES += $(PWD)/stage_1.v
VERILOG_SOURCES += $(PWD)/stage_2.v
VERILOG_SOURCES += $(PWD)/stage_3.v

run:
	rm -rf sim_build/
	$(MAKE) sim MODULE=test_pipeline TOPLEVEL=tb_pipeline
include $(shell cocotb-config --makefiles)/Makefile.sim
