library ieee;
use ieee.std_logic_1164.all;

entity alu is
    port(
        x  : in  std_logic_vector(15 downto 0);
        y  : in  std_logic_vector(15 downto 0);
        zx : in  std_logic;
        nx : in  std_logic;
        zy : in  std_logic;
        ny : in  std_logic;
        f  : in  std_logic;
        no : in  std_logic;
        o  : out std_logic_vector(15 downto 0);
        zr : out std_logic;
        ng : out std_logic
    );
end entity alu;

architecture rtl of alu is
    signal x1 : std_logic_vector(15 downto 0);
    signal y1 : std_logic_vector(15 downto 0);
    signal x2 : std_logic_vector(15 downto 0);
    signal y2 : std_logic_vector(15 downto 0);

    signal a  : std_logic_vector(15 downto 0); 

    signal s  : std_logic_vector(15 downto 0);
    signal c  : std_logic_vector(16 downto 0);

    component add 
        port(
            i0 : in  std_logic;
            i1 : in  std_logic;
            ci : in  std_logic;
            s  : out std_logic;
            co : out std_logic
        );
    end component;

    signal o1 : std_logic_vector(15 downto 0);
    signal o2 : std_logic_vector(15 downto 0);
begin

    c(0) <= '0';

    gen1: for i in 15 downto 0 generate
        x1(i) <= x(i) and not zx;
        x2(i) <= x1(i) xor nx;

        y1(i) <= y(i) and not zy;
        y2(i) <= y1(i) xor ny;

        a(i) <= x2(i) and y2(i);
    
        adder: add
            port map (
                i0 => x2(i),
                i1 => y2(i),
                ci => c(i),
                s  => s(i),
                co => c(i+1)
            );

        o1(i) <= (s(i) and f) or (a(i) and not f);
        o2(i) <= o1(i) xor no;

        o(i) <= o2(i);
    end generate;

    zr <= not (
        (
            (
                (o2(15) or o2(14)) or 
                (o2(13) or o2(12))
            ) or (
                (o2(11) or o2(10)) or 
                (o2(9) or o2(8))
            )
        ) or (
            (
                (o2(7) or o2(6)) or 
                (o2(5) or o2(4))
            ) or (
                (o2(3) or o2(2)) or 
                (o2(1) or o2(0))
            )
        )
    );

    ng <= o2(15);
end rtl;
