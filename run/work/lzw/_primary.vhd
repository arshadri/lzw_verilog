library verilog;
use verilog.vl_types.all;
entity lzw is
    port(
        TX              : out    vl_logic;
        SER_RECV_DONE   : out    vl_logic;
        INIT_CR         : out    vl_logic;
        INIT_LZW        : out    vl_logic;
        DONE_CR         : out    vl_logic;
        LZW_DONE        : out    vl_logic;
        FINAL_DONE      : out    vl_logic;
        PWR_UP          : out    vl_logic;
        VALID_START_DEB : out    vl_logic;
        RX              : in     vl_logic;
        CLK66           : in     vl_logic;
        RST             : in     vl_logic
    );
end lzw;
