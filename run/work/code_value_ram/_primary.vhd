library verilog;
use verilog.vl_types.all;
entity code_value_ram is
    port(
        rd_dataa        : out    vl_logic_vector(12 downto 0);
        wr_porta        : in     vl_logic;
        en_porta        : in     vl_logic;
        addra           : in     vl_logic_vector(12 downto 0);
        wr_dataa        : in     vl_logic_vector(12 downto 0);
        wr_portb        : in     vl_logic;
        en_portb        : in     vl_logic;
        addrb           : in     vl_logic_vector(12 downto 0);
        wr_datab        : in     vl_logic_vector(12 downto 0);
        clk             : in     vl_logic;
        rst_n           : in     vl_logic
    );
end code_value_ram;
