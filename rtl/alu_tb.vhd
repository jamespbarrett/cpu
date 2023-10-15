library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_tb is
end entity alu_tb;

architecture test of alu_tb is
    signal x  : std_logic_vector(15 downto 0) := (others => '0');
    signal y  : std_logic_vector(15 downto 0) := (others => '0');
    signal zx : std_logic;
    signal nx : std_logic;
    signal zy : std_logic;
    signal ny : std_logic;
    signal f  : std_logic;
    signal no : std_logic;
    signal o  : std_logic_vector(15 downto 0);
    signal zr : std_logic;
    signal ng : std_logic;

    signal exp_o: std_logic_vector(15 downto 0);
    signal exp_zr : std_logic;
    signal exp_ng : std_logic;
    signal good: std_logic;

    component alu 
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
    end component;
begin

    UUT: alu
        port map (
            x => x,
            y => y,
            zx => zx,
            nx => nx,
            zy => zy,
            ny => ny,
            f => f,
            no => no,
            o => o,
            zr => zr,
            ng => ng
        );

    stim: process 
        variable xx : integer;
        variable yy : integer;
        variable xi : integer;
        variable yi : integer; 
    begin
        for n in 0 to 63 loop
            (zx, nx, zy, ny, f, no) <= std_logic_vector(to_unsigned(n, 6));

            for i in 0 to 255 loop
                xx := xx + 177147;
                yy := xx + 117649;
                xi := xx mod 65536;
                yi := yy mod 65536;
                x <= std_logic_vector(to_unsigned(xi, 16));
                y <= std_logic_vector(to_unsigned(yi, 16));

                wait for 5 ns;

                if good = '0' then
                    wait for 5 ns;
                    assert false severity failure;
                end if;

                wait for 5 ns;
            end loop;
        end loop;
        wait;
    end process stim;

    process(x, zx, nx, y, zy, ny, f, no)
        variable xi : integer;
        variable yi : integer; 
    begin
        xi := to_integer(signed(x));
        yi := to_integer(signed(y));

        case std_logic_vector'(zx & nx & zy & ny & f & no) is
            when "000000" => exp_o <= (x and y) after 1 ns;
            when "000001" => exp_o <= not (x and y) after 1 ns;
            when "000010" => exp_o <= std_logic_vector(to_signed(xi + yi, 17)(15 downto 0)) after 1 ns;
            when "000011" => exp_o <= std_logic_vector(to_signed(- xi - yi - 1, 17)(15 downto 0)) after 1 ns;
            when "000100" => exp_o <= (x and not y) after 1 ns;
            when "000101" => exp_o <= (not x or y) after 1 ns;
            when "000110" => exp_o <= std_logic_vector(to_signed(xi - yi - 1, 17)(15 downto 0)) after 1 ns;
            when "000111" => exp_o <= std_logic_vector(to_signed(yi - xi, 17)(15 downto 0)) after 1 ns;
            when "001000" => exp_o <= "0000000000000000" after 1 ns;
            when "001001" => exp_o <= "1111111111111111" after 1 ns;
            when "001010" => exp_o <= x after 1 ns;
            when "001011" => exp_o <= std_logic_vector(to_signed(- xi - 1, 17)(15 downto 0)) after 1 ns;
            when "001100" => exp_o <= x after 1 ns;
            when "001101" => exp_o <= not x after 1 ns;
            when "001110" => exp_o <= std_logic_vector(to_signed(xi - 1, 17)(15 downto 0)) after 1 ns;
            when "001111" => exp_o <= std_logic_vector(to_signed(-xi, 17)(15 downto 0)) after 1 ns;
            when "010000" => exp_o <= (not x and y) after 1 ns;
            when "010001" => exp_o <= (x or not y) after 1 ns;
            when "010010" => exp_o <= std_logic_vector(to_signed(yi - xi - 1, 17)(15 downto 0)) after 1 ns;
            when "010011" => exp_o <= std_logic_vector(to_signed(xi - yi, 17)(15 downto 0)) after 1 ns;
            when "010100" => exp_o <= not (x or y) after 1 ns;
            when "010101" => exp_o <= (x or y) after 1 ns;
            when "010110" => exp_o <= std_logic_vector(to_signed(- xi - yi - 2, 17)(15 downto 0)) after 1 ns;
            when "010111" => exp_o <= std_logic_vector(to_signed(xi + yi + 1, 17)(15 downto 0)) after 1 ns;
            when "011000" => exp_o <= "0000000000000000" after 1 ns;
            when "011001" => exp_o <= "1111111111111111" after 1 ns;
            when "011010" => exp_o <= not x after 1 ns;
            when "011011" => exp_o <= x after 1 ns;
            when "011100" => exp_o <= not x after 1 ns;
            when "011101" => exp_o <= x after 1 ns;
            when "011110" => exp_o <= std_logic_vector(to_signed(- xi - 2, 17)(15 downto 0)) after 1 ns;
            when "011111" => exp_o <= std_logic_vector(to_signed(xi + 1, 17)(15 downto 0)) after 1 ns;
            when "100000" => exp_o <= "0000000000000000" after 1 ns;
            when "100001" => exp_o <= "1111111111111111" after 1 ns;
            when "100010" => exp_o <= y after 1 ns;
            when "100011" => exp_o <= std_logic_vector(to_signed(- yi - 1, 17)(15 downto 0)) after 1 ns;
            when "100100" => exp_o <= "0000000000000000" after 1 ns;
            when "100101" => exp_o <= "1111111111111111" after 1 ns;
            when "100110" => exp_o <= std_logic_vector(to_signed(- yi - 1, 17)(15 downto 0)) after 1 ns;
            when "100111" => exp_o <= y after 1 ns;
            when "101000" => exp_o <= "0000000000000000" after 1 ns;
            when "101001" => exp_o <= "1111111111111111" after 1 ns;
            when "101010" => exp_o <= "0000000000000000" after 1 ns;
            when "101011" => exp_o <= "1111111111111111" after 1 ns;
            when "101100" => exp_o <= "0000000000000000" after 1 ns;
            when "101101" => exp_o <= "1111111111111111" after 1 ns;
            when "101110" => exp_o <= "1111111111111111" after 1 ns;
            when "101111" => exp_o <= "0000000000000000" after 1 ns;
            when "110000" => exp_o <= y after 1 ns;
            when "110001" => exp_o <= not y after 1 ns;
            when "110010" => exp_o <= std_logic_vector(to_signed(yi - 1, 17)(15 downto 0)) after 1 ns;
            when "110011" => exp_o <= std_logic_vector(to_signed(-yi, 17)(15 downto 0)) after 1 ns;
            when "110100" => exp_o <= not y after 1 ns;
            when "110101" => exp_o <= y after 1 ns;
            when "110110" => exp_o <= std_logic_vector(to_signed(-yi - 2, 17)(15 downto 0)) after 1 ns;
            when "110111" => exp_o <= std_logic_vector(to_signed(yi + 1, 17)(15 downto 0)) after 1 ns;
            when "111000" => exp_o <= "0000000000000000" after 1 ns;
            when "111001" => exp_o <= "1111111111111111" after 1 ns;
            when "111010" => exp_o <= "1111111111111111" after 1 ns;
            when "111011" => exp_o <= "0000000000000000" after 1 ns;
            when "111100" => exp_o <= "1111111111111111" after 1 ns;
            when "111101" => exp_o <= "0000000000000000" after 1 ns;
            when "111110" => exp_o <= std_logic_vector(to_signed(-2, 17)(15 downto 0)) after 1 ns;
            when "111111" => exp_o <= std_logic_vector(to_signed(1, 17)(15 downto 0)) after 1 ns;
            when others   => exp_o <= (others => 'X') after 1 ns;
        end case;
    end process;

    exp_zr <= '1' when (exp_o = "0000000000000000") else '0';
    exp_ng <= exp_o(15);

    good <= '1' when ((o = exp_o) and (zr = exp_zr) and (ng = exp_ng)) else '0';

end architecture test;