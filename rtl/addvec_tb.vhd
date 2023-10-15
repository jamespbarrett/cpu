library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity addvec_tb is
end entity addvec_tb;

architecture test of addvec_tb is
    signal i0 : std_logic_vector(15 downto 0) := (others => '0');
    signal i1 : std_logic_vector(15 downto 0) := (others => '0');
    signal s  : std_logic_vector(15 downto 0);
    signal co : std_logic;

    signal exp_s : std_logic_vector(15 downto 0);
    signal exp_co : std_logic;

    component addvec 
        generic(
            N : integer := 16
        );
        port(
            i0 : in  std_logic_vector(N - 1 downto 0);
            i1 : in  std_logic_vector(N - 1 downto 0);
            s  : out std_logic_vector(N - 1 downto 0);
            co : out std_logic
        );
    end component;
begin

    UUT: addvec
        port map (
            i0 => i0,
            i1 => i1,
            s  => s,
            co => co
        );

    stim: process
        variable x_ctr : integer := 0;
        variable y_ctr : integer := 0;
        variable x : integer range 0 to 65535;
        variable y : integer range 0 to 65535;
    begin
        wait for 17 ns;

        for i in 0 to 255 loop
            x_ctr := x_ctr + 177147;
            y_ctr := y_ctr + 117649;
            x := x_ctr mod 65536;
            y := y_ctr mod 65536;

            i0 <= std_logic_vector(to_unsigned(x, 16));
            i1 <= std_logic_vector(to_unsigned(y, 16));

            exp_s <= std_logic_vector(to_unsigned((x + y) mod 65536, 16));
            exp_co <= '1' when (x + y > 65536) else '0';

            wait for 5 ns;

            assert( exp_s  = s);
            assert( exp_co = co);

            wait for 5 ns;
        end loop;

        wait;
    end process stim;

end architecture test;