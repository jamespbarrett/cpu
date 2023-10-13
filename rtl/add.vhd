library ieee;
use ieee.std_logic_1164.all;

entity add is
    port(
        i0 : in  std_logic;
        i1 : in  std_logic;
        ci : in  std_logic;
        s  : out std_logic;
        co : out std_logic
    );
end entity add;

architecture rtl of add is
begin
    s <= i0 xor i1 xor ci;
    co <= (i0 and i1) or (i0 and ci) or (i1 and ci);
end rtl;
