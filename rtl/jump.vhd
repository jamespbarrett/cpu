library ieee;
use ieee.std_logic_1164.all;

entity jump is
    port(
        jlt : in  std_logic;
        jz  : in  std_logic;
        jgt : in  std_logic;

        zr  : in  std_logic;
        ng  : in  std_logic;

        j   : out std_logic
    );
end entity jump;

architecture rtl of jump is
begin
    j <= (jlt and ng) or (jz and zr) or (jgt and not zr and not ng);
end rtl;
