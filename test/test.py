import cocotb
from cocotb.triggers import RisingEdge, Timer
from cocotb.clock import Clock


@cocotb.test()
async def test_project(dut):

    dut._log.info("Start")

    # start clock
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    # reset
    dut.rst_n.value = 0
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    await Timer(20, units="ns")
    dut.rst_n.value = 1

    dut._log.info("Reset complete")

    # ADD 5 + 3 = 8
    dut.ui_in.value = (3 << 4) | 5
    dut.uio_in.value = 0
    await RisingEdge(dut.clk)
    assert dut.uo_out.value == 8

    # SUB 10 - 4 = 6
    dut.ui_in.value = (4 << 4) | 10
    dut.uio_in.value = 1
    await RisingEdge(dut.clk)
    assert dut.uo_out.value == 6

    # AND
    dut.ui_in.value = (10 << 4) | 12
    dut.uio_in.value = 2
    await RisingEdge(dut.clk)
    assert dut.uo_out.value == (12 & 10)

    # OR
    dut.ui_in.value = (1 << 4) | 12
    dut.uio_in.value = 3
    await RisingEdge(dut.clk)
    assert dut.uo_out.value == (12 | 1)

    # XOR
    dut.ui_in.value = (3 << 4) | 5
    dut.uio_in.value = 4
    await RisingEdge(dut.clk)
    assert dut.uo_out.value == (5 ^ 3)

    # SHIFT
    dut.ui_in.value = (0 << 4) | 5
    dut.uio_in.value = 5
    await RisingEdge(dut.clk)
    assert dut.uo_out.value == (5 << 1)

    dut._log.info("All ALU tests passed")