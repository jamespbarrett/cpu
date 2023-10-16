library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity jump_tb is
end entity jump_tb;

architecture test of jump_tb is
    signal jlt : std_logic := '0';
    signal jz  : std_logic := '0';
    signal jgt : std_logic := '0';
    signal zr  : std_logic := '0';
    signal ng  : std_logic := '0';
    signal j   : std_logic;

    signal exp_j : std_logic;

    component jump 
        port(
            jlt : in  std_logic;
            jz  : in  std_logic;
            jgt : in  std_logic;
    
            zr  : in  std_logic;
            ng  : in  std_logic;
    
            j   : out std_logic
        );
    end component;

    signal good : std_logic;
begin

    UUT: jump
        port map (
            jlt => jlt,
            jz  => jz,
            jgt => jgt,
            zr  => zr,
            ng  => ng,
            j   => j
        );

    stim: process
    begin
        wait for 17 ns;

        (jlt, jz, jgt, zr, ng) <= std_logic_vector'("00000");
        exp_j <= '0';
        wait for 5 ns;
        assert(good = '1');

        (jlt, jz, jgt, zr, ng) <= std_logic_vector'("00001");
        exp_j <= '0';
        wait for 5 ns;
        assert(good = '1');

        (jlt, jz, jgt, zr, ng) <= std_logic_vector'("00010");
        exp_j <= '0';
        wait for 5 ns;
        assert(good = '1');

        (jlt, jz, jgt, zr, ng) <= std_logic_vector'("00100");
        exp_j <= '1';
        wait for 5 ns;
        assert(good = '1');

        (jlt, jz, jgt, zr, ng) <= std_logic_vector'("00101");
        exp_j <= '0';
        wait for 5 ns;
        assert(good = '1');
        
        (jlt, jz, jgt, zr, ng) <= std_logic_vector'("00110");
        exp_j <= '0';
        wait for 5 ns;
        assert(good = '1');

        (jlt, jz, jgt, zr, ng) <= std_logic_vector'("01000");
        exp_j <= '0';
        wait for 5 ns;
        assert(good = '1');

        (jlt, jz, jgt, zr, ng) <= std_logic_vector'("01001");
        exp_j <= '0';
        wait for 5 ns;
        assert(good = '1');

        (jlt, jz, jgt, zr, ng) <= std_logic_vector'("01010");
        exp_j <= '1';
        wait for 5 ns;
        assert(good = '1');

        (jlt, jz, jgt, zr, ng) <= std_logic_vector'("01100");
        exp_j <= '1';
        wait for 5 ns;
        assert(good = '1');

        (jlt, jz, jgt, zr, ng) <= std_logic_vector'("01101");
        exp_j <= '0';
        wait for 5 ns;
        assert(good = '1');

        (jlt, jz, jgt, zr, ng) <= std_logic_vector'("01110");
        exp_j <= '1';
        wait for 5 ns;
        assert(good = '1');

        (jlt, jz, jgt, zr, ng) <= std_logic_vector'("10000");
        exp_j <= '0';
        wait for 5 ns;
        assert(good = '1');

        (jlt, jz, jgt, zr, ng) <= std_logic_vector'("10001");
        exp_j <= '1';
        wait for 5 ns;
        assert(good = '1');

        (jlt, jz, jgt, zr, ng) <= std_logic_vector'("10010");
        exp_j <= '0';
        wait for 5 ns;
        assert(good = '1');

        (jlt, jz, jgt, zr, ng) <= std_logic_vector'("10100");
        exp_j <= '1';
        wait for 5 ns;
        assert(good = '1');

        (jlt, jz, jgt, zr, ng) <= std_logic_vector'("10101");
        exp_j <= '1';
        wait for 5 ns;
        assert(good = '1');

        (jlt, jz, jgt, zr, ng) <= std_logic_vector'("10110");
        exp_j <= '0';
        wait for 5 ns;
        assert(good = '1');

        (jlt, jz, jgt, zr, ng) <= std_logic_vector'("11000");
        exp_j <= '0';
        wait for 5 ns;
        assert(good = '1');

        (jlt, jz, jgt, zr, ng) <= std_logic_vector'("11001");
        exp_j <= '1';
        wait for 5 ns;
        assert(good = '1');

        (jlt, jz, jgt, zr, ng) <= std_logic_vector'("11010");
        exp_j <= '1';
        wait for 5 ns;
        assert(good = '1');

        (jlt, jz, jgt, zr, ng) <= std_logic_vector'("11100");
        exp_j <= '1';
        wait for 5 ns;
        assert(good = '1');

        (jlt, jz, jgt, zr, ng) <= std_logic_vector'("11101");
        exp_j <= '1';
        wait for 5 ns;
        assert(good = '1');

        (jlt, jz, jgt, zr, ng) <= std_logic_vector'("11110");
        exp_j <= '1';
        wait for 5 ns;
        assert(good = '1');

        wait for 5 ns;

        wait;
    end process stim;

    good <= '1' when exp_j = j else '0';

end architecture test;