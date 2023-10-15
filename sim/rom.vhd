-- This is a model of memory for the simulation test benches that need it

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity rom is
    generic (
        filename : string := "data.rom"
    );
    port(
        A    : in  std_logic_vector(14 downto 0);
        DOUT : out std_logic_vector(15 downto 0)
    );
end entity rom;

architecture sim of rom is
    type MEMDATA is array (natural range <>) of integer range 0 to 65535;

    signal DATA : MEMDATA(32767 downto 0) := (others => 0);
begin

    process
        file romfile : text open read_mode is filename;
        variable row : line;
        variable d : unsigned(15 downto 0);
        variable i : integer;
    begin
        DATA <= (others => 0);
        
        i := 0;
        while (not endfile(romfile)) loop
            readline(romfile, row);
            
            for j in 0 to 15 loop
                hread(row, d);
                DATA(i*16 + j) <= to_integer(d);
            end loop;

            i := i + 1;
        end loop;

        wait;
    end process;

    process (A, DATA)
    begin
        DOUT <= std_logic_vector(to_unsigned(DATA(to_integer(unsigned(A))), 16)) after 1 ns;
    end process;

end sim;
