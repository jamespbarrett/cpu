library ieee;
use ieee.std_logic_1164.all;

entity mux is
    generic (
        WIDTH : integer := 16
    );
    port(
        in0 : in  std_logic_vector(WIDTH - 1 downto 0);
        in1 : in  std_logic_vector(WIDTH - 1 downto 0);
        sel : in  std_logic;
        o   : out std_logic_vector(WIDTH - 1 downto 0)
    );
end entity mux;

architecture rtl of mux is
begin
    gen1: for i in WIDTH - 1 downto 0 generate
        o(i) <= (in0(i) and not sel) or (in1(i) and sel);
    end generate;
end rtl;
