import os
from pathlib import Path
import cocotb
import random
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles, Timer
from cocotb.regression import TestFactory


@cocotb.test
async def test_master_slave_interface(dut):
	# Generate a clock with a period of 10ns
	cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

	
	# Reset all the signals

	dut.stall_master.value = 0
	dut.stall_slave.value = 0

	await assert_resetn(dut,2) # Reset for 2 clock cycles

	for _ in range(10):
		await random_signal_assert(dut, dut.stall_master, dut.clk)
		await random_signal_assert(dut, dut.stall_slave, dut.clk)
		await RisingEdge(dut.clk)
		
		cocotb.log.info(f"Data Received at the slave: {hex(dut.slave_reg_data_out.value)}")

		if _ == 5:	
			await assert_resetn(dut, 2) # Reset for 2 clock cycles
			
		
	#await ClockCycles(dut.clk, 100) # End simulation after 100 clock cycles
		
async def assert_resetn(dut, cycles=1):
	""" Generate Reset for the units of clock cycles passed in 'cycles' """

	dut.rst_n.value = 0
	await ClockCycles(dut.clk, cycles)
	dut.rst_n.value = 1
	await RisingEdge(dut.clk)
	await RisingEdge(dut.clk)

async def random_signal_assert(dut, signal_name, clk):
	"""
	Randomly assert a signal high and deassert after a clock cycle.
	
	Args:
		dut: Handle to the DUT.
		signal_name: Name of the signal to control as a string.
		clk: Handle to the clock signal.
	"""

	# Randomly decide to assert or not (50% chance)
	if random.choice([True, False, False, False]):
		signal_name.value = 1  # Assert signal high
		await RisingEdge(clk)  # Wait for one clock cycle
		signal_name.value = 0  # Deassert signal
	await RisingEdge(clk)  # Wait for the next clock edge
	
def run_tests():
	factory = TestFactor(test_master_slave_interface)
	factory.generate_tests()
 
if __name__ == "__main__":
    	run_tests()
