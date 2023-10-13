library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_tb is
end entity rom_tb;

architecture test of rom_tb is
    signal clock : std_logic := '0';
    signal reset : std_logic := '0';

    signal A    : std_logic_vector(14 downto 0);
    signal DOUT : std_logic_vector(15 downto 0);
    signal VLD  : std_logic;

    component rom
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
    end component;

    signal stop_sim : boolean := false;
begin

    UUT: rom
        generic map (
            filename => "data/test.rom"
        )
        port map (
            CLK  => clock,
            RST  => reset,
            A    => A,
            DOUT => DOUT,
            VLD  => VLD
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

        A   <= (others => '0');

        wait for 17 ns;

        reset <= '1';

        wait until falling_edge(clock);
        for addr in 0 to 32767 loop
            A   <= std_logic_vector(to_unsigned(addr, 15));
            
            wait until falling_edge(clock);
            
            assert(to_integer(unsigned(DOUT)) = 65535 - addr) report integer'image(to_integer(unsigned(DOUT))) & " != " & integer'image(65535 - addr) severity failure;

            wait until falling_edge(clock);
        end loop;

        stop_sim <= true;
        wait;
    end process stim;

end architecture test;