library verilog;
use verilog.vl_types.all;
entity top_ctrl is
    generic(
        IDLE            : vl_logic_vector(0 to 11) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1);
        \INIT_CR\       : vl_logic_vector(0 to 11) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0);
        WT_RST          : vl_logic_vector(0 to 11) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0);
        WT_RC           : vl_logic_vector(0 to 11) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0);
        WT_ST           : vl_logic_vector(0 to 11) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0);
        LZWDONE         : vl_logic_vector(0 to 11) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0);
        WT_TST          : vl_logic_vector(0 to 11) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        WT_TC1          : vl_logic_vector(0 to 11) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        WT_TC           : vl_logic_vector(0 to 11) := (Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        DONE            : vl_logic_vector(0 to 11) := (Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0)
    );
    port(
        init_cr         : out    vl_logic;
        init_lzw        : out    vl_logic;
        char_cnt        : out    vl_logic_vector(11 downto 0);
        start_xmt       : out    vl_logic;
        addra_ioram     : out    vl_logic_vector(11 downto 0);
        ena_ioram       : out    vl_logic;
        wea_ioram       : out    vl_logic;
        addra_outram    : out    vl_logic_vector(11 downto 0);
        ena_outram      : out    vl_logic;
        ser_recv_done   : out    vl_logic;
        init_cr_out     : out    vl_logic;
        done_cr_out     : out    vl_logic;
        init_lzw_out    : out    vl_logic;
        lzw_done_out    : out    vl_logic;
        final_done      : out    vl_logic;
        pwr_up          : out    vl_logic;
        done_cr         : in     vl_logic;
        lzw_done        : in     vl_logic;
        outram_cnt      : in     vl_logic_vector(11 downto 0);
        rcv_done        : in     vl_logic;
        xmt_done        : in     vl_logic;
        char_in         : in     vl_logic_vector(7 downto 0);
        clk             : in     vl_logic;
        rst_n           : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IDLE : constant is 1;
    attribute mti_svvh_generic_type of \INIT_CR\ : constant is 1;
    attribute mti_svvh_generic_type of WT_RST : constant is 1;
    attribute mti_svvh_generic_type of WT_RC : constant is 1;
    attribute mti_svvh_generic_type of WT_ST : constant is 1;
    attribute mti_svvh_generic_type of LZWDONE : constant is 1;
    attribute mti_svvh_generic_type of WT_TST : constant is 1;
    attribute mti_svvh_generic_type of WT_TC1 : constant is 1;
    attribute mti_svvh_generic_type of WT_TC : constant is 1;
    attribute mti_svvh_generic_type of DONE : constant is 1;
end top_ctrl;
