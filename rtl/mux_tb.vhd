library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_tb is
end entity mux_tb;

architecture test of mux_tb is
    signal in0 : std_logic_vector(15 downto 0) := (others => '0');
    signal in1 : std_logic_vector(15 downto 0) := (others => '0');
    signal sel : std_logic := '0';
    signal o   : std_logic_vector(15 downto 0);

    signal exp_o : std_logic_vector(15 downto 0);

    component mux 
        generic (
            WIDTH : integer := 16
        );
        port(
            in0 : in  std_logic_vector(WIDTH - 1 downto 0);
            in1 : in  std_logic_vector(WIDTH - 1 downto 0);
            sel : in  std_logic;
            o   : out std_logic_vector(WIDTH - 1 downto 0)
        );
    end component;

    signal good : std_logic;
begin

    UUT: mux
        port map (
            in0 => in0,
            in1 => in1,
            sel => sel,
            o   => o
        );

    stim: process
        constant A : std_logic_vector(15 downto 0) := x"BBC1";
        constant B : std_logic_vector(15 downto 0) := x"CAFE";
    begin
        wait for 17 ns;

        in0 <= A;
        in1 <= B;

        sel <= '0';

        exp_o <= A;

        wait for 5 ns;

        assert(good = '1');

        sel <= '1';
        exp_o <= B;

        wait for 5 ns;

        assert(good = '1');

        wait for 5 ns;

        wait;
    end process stim;

    good <= '1' when exp_o = o else '0';

end architecture test;