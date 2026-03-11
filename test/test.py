import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer


@cocotb.test()
async def test_project(dut):

    dut._log.info("Start test")

    # start clock
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    # initialize
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    # reset
    dut.rst_n.value = 0
    await Timer(20, units="ns")
    dut.rst_n.value = 1

    # wait a few cycles
    for _ in range(5):
        await RisingEdge(dut.clk)

    dut._log.info("Simulation ran successfully")

    # simple sanity check
    assert dut.uo_out.value is not None