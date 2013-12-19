library verilog;
use verilog.vl_types.all;
entity io_ram is
    port(
        rd_dataa        : out    vl_logic_vector(7 downto 0);
        rd_datab        : out    vl_logic_vector(7 downto 0);
        wr_porta        : in     vl_logic;
        en_porta        : in     vl_logic;
        addra           : in     vl_logic_vector(11 downto 0);
        wr_dataa        : in     vl_logic_vector(7 downto 0);
        wr_portb        : in     vl_logic;
        en_portb        : in     vl_logic;
        addrb           : in     vl_logic_vector(11 downto 0);
        wr_datab        : in     vl_logic_vector(7 downto 0);
        clk             : in     vl_logic;
        rst_n           : in     vl_logic
    );
end io_ram;
