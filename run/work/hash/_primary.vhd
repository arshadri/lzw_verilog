library verilog;
use verilog.vl_types.all;
entity hash is
    port(
        addr            : out    vl_logic_vector(12 downto 0);
        string_reg      : out    vl_logic_vector(12 downto 0);
        not_in_mem      : out    vl_logic;
        match           : out    vl_logic;
        collis          : out    vl_logic;
        in_code_mem     : out    vl_logic;
        gen_hash        : in     vl_logic;
        recal_hash      : in     vl_logic;
        shift_char      : in     vl_logic;
        mux_code_val    : in     vl_logic;
        char_in         : in     vl_logic_vector(7 downto 0);
        string_data     : in     vl_logic_vector(12 downto 0);
        append_data     : in     vl_logic_vector(7 downto 0);
        prefix_data     : in     vl_logic_vector(12 downto 0);
        clk             : in     vl_logic;
        rst_n           : in     vl_logic
    );
end hash;
