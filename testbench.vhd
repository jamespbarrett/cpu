library ieee;
use ieee.std_logic_1164.all;

entity test_bench is
end entity test_bench;

architecture test of test_bench is
    signal clock : std_logic := '0';
    signal reset : std_logic := '0';

    signal stop_sim : boolean := false;
begin

    process begin
        while not stop_sim loop
            clock <= '0';
            wait for 5 ns;
            clock <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    stim: process begin
        stop_sim <= false;
        reset <= '0';

        wait for 17 ns;

        reset <= '1';
        
        wait for 100 ns;
        stop_sim <= true;
        wait;
    end process stim;

end architecture test;