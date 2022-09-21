/**
 * PLL configuration [Modified]
 *
 * This Verilog module was generated automatically
 * using the icepll tool from the IceStorm project.
 * Use at your own risk.
 *
 * Given input frequency:        12.000 MHz
 * Requested output frequency:  100.000 MHz
 * Achieved output frequency:   100.500 MHz
 */
module UartClock(
	input  clock_in,
	output uart_clk,
	output global_clk,
	output locked
	);

	// Since we need both the global oscillator and PLL in the design
	// we need to use SB_PLL40_2_PAD 
	// https://github.com/YosysHQ/icestorm/issues/142
	// https://github.com/mystorm-org/BlackIce-II/wiki/PLLs-Advanced#sb_pll40_2_pad
    SB_PLL40_2_PAD #(
		.FEEDBACK_PATH("SIMPLE"),
		.DIVR(4'b0000),		// DIVR =  0
		.DIVF(7'b1000010),	// DIVF = 66
		.DIVQ(3'b011),		// DIVQ =  3
		.FILTER_RANGE(3'b001)	// FILTER_RANGE = 1
	) uut (
		.LOCK(locked),
		.RESETB(1'b1),
		.BYPASS(1'b0),
		.PACKAGEPIN(clock_in),
		.PLLOUTGLOBALA(global_clk),
		.PLLOUTGLOBALB(uart_clk)
	);

endmodule
