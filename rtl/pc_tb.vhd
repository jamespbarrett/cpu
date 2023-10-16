library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_tb is
end entity pc_tb;

architecture test of pc_tb is
    signal clock : std_logic := '0';
    signal reset : std_logic := '0';

    signal input  : std_logic_vector(15 downto 0) := (others => 'X');
    signal set    : std_logic := '0';
    signal output : std_logic_vector(15 downto 0);

    signal exp_output : std_logic_vector(15 downto 0) := (others => 'U');

    component pc 
        generic(
            WIDTH : integer := 15
        );
        port(
            clock  : in  std_logic;
            reset  : in  std_logic;
            input  : in  std_logic_vector(WIDTH-1 downto 0);
            set    : in  std_logic;
            output : out std_logic_vector(WIDTH-1 downto 0)
        );
    end component;

    signal good : std_logic;

    signal stop_sim : boolean := false;
begin

    UUT: pc
        generic map (
            WIDTH => 16
        )
        port map (
            clock  => clock,
            reset  => reset,
            input  => input,
            set    => set,
            output => output
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

    stim: process 
        variable n : integer range 0 to 65535;
    begin
        stop_sim <= false;
        reset <= '0';
        set   <= '0';

        wait for 17 ns;


        n := 0;
        wait until rising_edge(clock);
        exp_output <= std_logic_vector(to_unsigned(n, 16));
        n := n + 1;
        wait until falling_edge(clock);
        assert good = '1';

        reset <= '1';
        set   <= '0';

        for i in 0 to 255 loop
            wait until rising_edge(clock);
            exp_output <= std_logic_vector(to_unsigned(n, 16));
            n := n + 1;

            wait until falling_edge(clock);
            assert good = '1';
        end loop;

        wait until falling_edge(clock);

        n := 3467;
        input <= std_logic_vector(to_unsigned(n, 16));
        set <= '1';

        wait until rising_edge(clock);

        exp_output <= std_logic_vector(to_unsigned(n, 16));
        n := n + 1;

        wait until falling_edge(clock);

        set <= '0';
        assert good = '1';

        for i in 0 to 255 loop
            wait until rising_edge(clock);
            exp_output <= std_logic_vector(to_unsigned(n, 16));
            n := n + 1;

            wait until falling_edge(clock);
            assert good = '1';
        end loop;

        wait until falling_edge(clock);

        wait for 10 ns;
        stop_sim <= true;
        wait;
    end process stim;

    good <= '1' when (output = exp_output) else '0';

end architecture test;