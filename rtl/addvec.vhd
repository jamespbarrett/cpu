library ieee;
use ieee.std_logic_1164.all;

entity addvec is
    generic(
        N : integer := 16
    );
    port(
        i0 : in  std_logic_vector(N - 1 downto 0);
        i1 : in  std_logic_vector(N - 1 downto 0);
        s  : out std_logic_vector(N - 1 downto 0);
        co : out std_logic
    );
end entity addvec;

architecture rtl of addvec is
    signal c : std_logic_vector(N downto 0) := (others => '0');

    component add 
        port(
            i0 : in  std_logic;
            i1 : in  std_logic;
            ci : in  std_logic;
            s  : out std_logic;
            co : out std_logic
        );
    end component;
begin
    c(0) <= '0';

    gen1: for i in N - 1 downto 0 generate
        adder: add
            port map (
                i0 => i0(i),
                i1 => i1(i),
                ci => c(i),
                s  => s(i),
                co => c(i+1)
            );
    end generate;

    co <= c(N);

end rtl;
