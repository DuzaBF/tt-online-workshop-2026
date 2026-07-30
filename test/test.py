# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    assert dut.uo_out.value == 0
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    # Set the input values you want to test
    dut.ui_in.value = 0

    for i, x in enumerate(
        [
            0x3F,
            0x06,
            0x5B,
            0x4F,
            0x66,
            0x6D,
            0x7D,
            0x27,
            0x7F,
            0x6F,
            0x77,
            0x7C,
            0x39,
            0x5E,
            0x79,
            0x71,
            0x3F,
        ]
    ):
        await ClockCycles(dut.clk, 1)
        assert dut.uo_out.value[6:0] == x
        assert dut.uo_out.value[7] == 0

    dut.ui_in.value = 11
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value[7:0] == 0

    dut.rst_n.value = 1

    for i, x in enumerate(
        [
            0x7C,
            0x39,
            0x5E,
            0x79,
            0x71,
            0x3F,
            0x06,
            0x5B,
            0x4F,
            0x66,
            0x6D,
            0x7D,
            0x27,
            0x7F,
            0x6F,
            0x77,
        ]
    ):
        await ClockCycles(dut.clk, 1)
        assert dut.uo_out.value[6:0] == x
        assert dut.uo_out.value[7] == 0

