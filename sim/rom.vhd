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
        CLK  : in  std_logic;
        RST  : in  std_logic;
        A    : in  std_logic_vector(14 downto 0);
        DOUT : out std_logic_vector(15 downto 0);
        VLD  : out std_logic
    );
end entity rom;

architecture sim of rom is
    type MEMDATA is array (natural range <>) of integer range 0 to 65535;

    signal DATA : MEMDATA(32767 downto 0);
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

    process (CLK, RST)
        variable addr : integer range 0 to 32767;
    begin
        if rising_edge(CLK) then
            if RST = '0' then
                VLD  <= '0';
                DOUT <= (others => '0');
            else
                addr := to_integer(unsigned(A));
                
                DOUT <= std_logic_vector(to_unsigned(DATA(addr), 16));
                VLD  <= '1';
            end if;
        end if;
    end process;

end sim;
