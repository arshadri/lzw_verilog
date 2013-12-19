library verilog;
use verilog.vl_types.all;
entity lzw_enc is
    port(
        xmt_byte        : out    vl_logic_vector(7 downto 0);
        web_ioram       : out    vl_logic;
        enb_ioram       : out    vl_logic;
        addrb_ioram     : out    vl_logic_vector(11 downto 0);
        lzw_done        : out    vl_logic;
        done_cr         : out    vl_logic;
        outram_cnt      : out    vl_logic_vector(11 downto 0);
        ena_outram      : in     vl_logic;
        addra_outram    : in     vl_logic_vector(11 downto 0);
        init_cr         : in     vl_logic;
        init_lzw        : in     vl_logic;
        char_cnt        : in     vl_logic_vector(11 downto 0);
        char_in         : in     vl_logic_vector(7 downto 0);
        clk             : in     vl_logic;
        rst_n           : in     vl_logic
    );
end lzw_enc;
