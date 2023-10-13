library ieee;
use ieee.std_logic_1164.all;

entity test_bench is
end entity test_bench;

architecture test of test_bench is
    signal clock : std_logic := '0';
    signal reset : std_logic := '0';

    signal i0 : std_logic;
    signal i1 : std_logic;
    signal ci : std_logic;
    signal s  : std_logic;
    signal co : std_logic;

    component add 
        port(
            i0 : in  std_logic;
            i1 : in  std_logic;
            ci : in  std_logic;
            s  : out std_logic;
            co : out std_logic
        );
    end component;

    signal stop_sim : boolean := false;
begin

    add0: add
        port map (
            i0 => i0,
            i1 => i1,
            ci => ci,
            s  => s,
            co => co
        );

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

        i0 <= '0';
        i1 <= '0';
        ci <= '0';

        wait for 20 ns;

        i0 <= '1';
        i1 <= '0';
        ci <= '0';

        wait for 20 ns;

        i0 <= '0';
        i1 <= '1';
        ci <= '0';

        wait for 20 ns;

        i0 <= '1';
        i1 <= '1';
        ci <= '0';

        wait for 20 ns;

        i0 <= '0';
        i1 <= '0';
        ci <= '1';

        wait for 20 ns;

        i0 <= '1';
        i1 <= '0';
        ci <= '1';

        wait for 20 ns;

        i0 <= '0';
        i1 <= '1';
        ci <= '1';

        wait for 20 ns;

        i0 <= '1';
        i1 <= '1';
        ci <= '1';
        
        wait for 20 ns;
        stop_sim <= true;
        wait;
    end process stim;

end architecture test;