library verilog;
use verilog.vl_types.all;
entity prefix_code_ram is
    port(
        rd_data         : out    vl_logic_vector(12 downto 0);
        wren            : in     vl_logic;
        en              : in     vl_logic;
        addr            : in     vl_logic_vector(11 downto 0);
        wr_data         : in     vl_logic_vector(12 downto 0);
        clk             : in     vl_logic;
        rst_n           : in     vl_logic
    );
end prefix_code_ram;
