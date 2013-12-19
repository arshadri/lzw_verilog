library verilog;
use verilog.vl_types.all;
entity outreg is
    port(
        valid_dcnt      : out    vl_logic;
        tc_outreg       : out    vl_logic;
        lzw_byte        : out    vl_logic_vector(7 downto 0);
        write_sp        : in     vl_logic;
        write_data      : in     vl_logic;
        read_data       : in     vl_logic;
        prefix_data     : in     vl_logic_vector(12 downto 0);
        clk             : in     vl_logic;
        rst_n           : in     vl_logic
    );
end outreg;
