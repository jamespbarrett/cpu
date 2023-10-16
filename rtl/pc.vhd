library ieee;
use ieee.std_logic_1164.all;

entity pc is
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
end entity pc;

architecture rtl of pc is
    signal pc_reg  : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
    signal pc_next : std_logic_vector(WIDTH-1 downto 0);

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

    output <= pc_reg;

    process(clock)
    begin
        if rising_edge(clock) then
            if not reset then
                pc_reg <= (others => '0');
            else
                if set = '1' then
                    pc_reg <= input;
                else
                    pc_reg <= pc_next;
                end if;
            end if;
        end if;
    end process;

    adder: addvec
        generic map (
            N => WIDTH
        )
        port map (
            i0 => pc_reg,
            i1 => (0 => '1', others => '0'),
            s  => pc_next,
            co => open
        );

end rtl;
