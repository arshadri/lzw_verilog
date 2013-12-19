library verilog;
use verilog.vl_types.all;
entity ser is
    port(
        sout            : out    vl_logic;
        rcv_byte        : out    vl_logic_vector(7 downto 0);
        rcv_done        : out    vl_logic;
        xmt_done        : out    vl_logic;
        vld_str_deb     : out    vl_logic;
        sin             : in     vl_logic;
        start_xmt       : in     vl_logic;
        xmt_byte        : in     vl_logic_vector(7 downto 0);
        rst_n           : in     vl_logic;
        clk             : in     vl_logic
    );
end ser;
