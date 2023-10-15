library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_tb is
end entity rom_tb;

architecture test of rom_tb is
    signal A    : std_logic_vector(14 downto 0) := (others => '0');
    signal DOUT : std_logic_vector(15 downto 0);

    component rom
        generic (
            filename : string := "data.rom"
        );
        port(
            A    : in  std_logic_vector(14 downto 0);
            DOUT : out std_logic_vector(15 downto 0)
        );
    end component;
begin

    UUT: rom
        generic map (
            filename => "data/test.rom"
        )
        port map (
            A    => A,
            DOUT => DOUT
        );

    stim: process begin
        A   <= (others => '0');

        wait for 17 ns;

        for addr in 0 to 32767 loop
            A   <= std_logic_vector(to_unsigned(addr, 15));
            
            wait for 5 ns;
            
            assert(to_integer(unsigned(DOUT)) = 65535 - addr) report integer'image(to_integer(unsigned(DOUT))) & " != " & integer'image(65535 - addr) severity failure;

            wait for 5 ns;
        end loop;

        wait;
    end process stim;

end architecture test;