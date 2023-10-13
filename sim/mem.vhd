-- This is a model of memory for the simulation test benches that need it

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem is
    port(
        CLK  : in  std_logic;
        RST  : in  std_logic;
        A    : in  std_logic_vector(14 downto 0);
        DIN  : in  std_logic_vector(15 downto 0);
        W    : in  std_logic;
        DOUT : out std_logic_vector(15 downto 0);
        VLD  : out std_logic
    );
end entity mem;

architecture sim of mem is
    type MEMDATA is array (natural range <>) of integer range 0 to 65535;

    signal DATA : MEMDATA(32767 downto 0);
begin

    process (CLK, RST)
        variable addr : integer range 0 to 32767;
    begin
        if rising_edge(CLK) then
            if RST = '0' then
                DATA <= (others => 0);
                VLD  <= '0';
                DOUT <= (others => '0');
            else
                addr := to_integer(unsigned(A));
                
                DOUT <= std_logic_vector(to_unsigned(DATA(addr), 16));
                VLD  <= '1';

                if W = '1' then
                    DATA(addr) <= to_integer(unsigned(DIN));
                end if;
            end if;
        end if;
    end process;

end sim;
