library verilog;
use verilog.vl_types.all;
entity dictionary_ram is
    port(
        prefix_data     : out    vl_logic_vector(12 downto 0);
        append_data     : out    vl_logic_vector(7 downto 0);
        wea_acram       : in     vl_logic;
        wea_pcram       : in     vl_logic;
        addr            : in     vl_logic_vector(12 downto 0);
        char_data       : in     vl_logic_vector(7 downto 0);
        string_data     : in     vl_logic_vector(12 downto 0);
        clk             : in     vl_logic;
        rst_n           : in     vl_logic
    );
end dictionary_ram;
