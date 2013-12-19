library verilog;
use verilog.vl_types.all;
entity ser_model is
    generic(
        CLKHALF_PER     : integer := 270000
    );
    port(
        sout            : out    vl_logic;
        rst             : in     vl_logic;
        sin             : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of CLKHALF_PER : constant is 1;
end ser_model;
