library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu_tb is
    generic(
        filename : string := "data/hello.rom"
    );
end entity cpu_tb;

architecture test of cpu_tb is
    signal clock : std_logic := '0';
    signal reset : std_logic := '0';

    signal data_addr : std_logic_vector(14 downto 0);
    signal data_in   : std_logic_vector(15 downto 0);
    signal data_out  : std_logic_vector(15 downto 0);
    signal data_w    : std_logic;

    signal inst_addr : std_logic_vector(14 downto 0);
    signal inst_in   : std_logic_vector(15 downto 0);

    component cpu
        port(
            clock  : in  std_logic;
            reset  : in  std_logic;
            
            data_addr : out std_logic_vector(14 downto 0); 
            data_in   : in  std_logic_vector(15 downto 0);
            data_out  : out std_logic_vector(15 downto 0);
            data_w    : out std_logic;
    
            inst_addr : out std_logic_vector(14 downto 0);
            inst_in   : in  std_logic_vector(15 downto 0)
        );
    end component;

    component mem
        port(
            CLK  : in  std_logic;
            RST  : in  std_logic;
            A    : in  std_logic_vector(14 downto 0);
            DIN  : in  std_logic_vector(15 downto 0);
            W    : in  std_logic;
            DOUT : out std_logic_vector(15 downto 0)
        );
    end component;

    component rom
        generic (
            filename : string := "data.rom"
        );
        port(
            A    : in  std_logic_vector(14 downto 0);
            DOUT : out std_logic_vector(15 downto 0)
        );
    end component;

    signal stop_sim : boolean := false;
begin

    UUT: cpu
        port map (
            clock  => clock,
            reset  => reset,
            data_addr => data_addr,
            data_in   => data_in,
            data_out  => data_out,
            data_w    => data_w,
            inst_addr => inst_addr,
            inst_in   => inst_in
        );

    RAM: mem
        port map (
            CLK  => clock,
            RST  => reset,
            A    => data_addr,
            DIN  => data_out,
            DOUT => data_in,
            W    => data_w
        );
    
    PROG: rom
        generic map (
            filename => filename
        )
        port map (
            A    => inst_addr,
            DOUT => inst_in
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
        
        wait for 17 ns;

        wait until falling_edge(clock);

        reset <= '1';
        
        for i in 0 to 256 loop
            wait until rising_edge(clock);
        end loop;
            
        wait for 10 ns;

        stop_sim <= true;
        wait;
    end process stim;

    process (clock)
        variable buf : string(1 to 1024);
        variable cnt : integer range 1 to 1024 := 1;
    begin
        if rising_edge(clock) then
            if data_w = '1' then
                if data_addr = "000000000000000" then
                    buf(cnt) := character'val(to_integer(unsigned(data_out(15 downto 8))));
                    cnt := cnt + 1;
                    if data_out(15 downto 8) = x"00" then
                        report buf;
                        cnt := 1;
                    end if;
                    
                    buf(cnt) := character'val(to_integer(unsigned(data_out(7 downto 0))));
                    cnt := cnt + 1;
                    if data_out(7 downto 0) = x"00" then
                        report buf;
                        cnt := 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

end architecture test;