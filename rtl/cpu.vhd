library ieee;
use ieee.std_logic_1164.all;

entity cpu is
    port(
        clock     : in  std_logic;
        reset     : in  std_logic;
        
        data_addr : out std_logic_vector(14 downto 0); 
        data_in   : in  std_logic_vector(15 downto 0);
        data_out  : out std_logic_vector(15 downto 0);
        data_w    : out std_logic;

        inst_addr : out std_logic_vector(14 downto 0);
        inst_in   : in  std_logic_vector(15 downto 0)
    );
end entity cpu;

architecture rtl of cpu is
    signal op  : std_logic_vector(0 downto 0);
    signal min : std_logic;
    signal c   : std_logic_vector(5 downto 0);
    signal d   : std_logic_vector(2 downto 0);
    signal j   : std_logic_vector(2 downto 0);

    signal A_in  : std_logic_vector(15 downto 0);
    signal A_reg : std_logic_vector(15 downto 0);
    signal A_en  : std_logic;

    signal D_in  : std_logic_vector(15 downto 0);
    signal D_reg : std_logic_vector(15 downto 0);
    signal D_en  : std_logic;

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

    component pc 
        port(
            clock  : in  std_logic;
            reset  : in  std_logic;
            input  : in  std_logic_vector(14 downto 0);
            set    : in  std_logic;
            output : out std_logic_vector(14 downto 0)
        );
    end component;

    signal pc_set  : std_logic;
    signal pc_out  : std_logic_vector(14 downto 0);

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

    signal jump_j : std_logic;

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

    signal alu_x   : std_logic_vector(15 downto 0);
    signal alu_y   : std_logic_vector(15 downto 0);
    signal alu_out : std_logic_vector(15 downto 0);
    signal alu_zr  : std_logic;
    signal alu_ng  : std_logic;
begin

    -- Decode
    op  <= inst_in(15 downto 15);
    min <= inst_in(12);
    c   <= inst_in(11 downto 6);
    d   <= inst_in(5 downto 3);
    j   <= inst_in(2 downto 0);

    -- Mux on A register input
    AMUX: mux
        port map(
            in0 => inst_in,
            in1 => alu_out,
            sel => op(0),
            o   => A_in
        );

    -- A register
    A_en <= (not op(0)) or d(2);

    process(clock)
    begin
        if rising_edge(clock) then
            if reset = '0' then
                A_reg <= (others => '0');
            else
                if A_en = '1' then
                    A_reg <= A_in;
                end if;
            end if;
        end if;
    end process;

    -- Memory access

    data_addr <= A_reg(14 downto 0) after 1 ns;
    data_w    <= (op(0) and d(0)) after 1 ns;
    data_out  <= alu_out after 1 ns;

    -- D register
    D_en <= op(0) and d(1);
    D_in <= alu_out;

    process(clock)
    begin
        if rising_edge(clock) then
            if reset = '0' then
                D_reg <= (others => '0');
            else
                if D_en = '1' then
                    D_reg <= D_in;
                end if;
            end if;
        end if;
    end process;

    -- A/M mux

    AMMUX: mux
        port map (
            in0 => A_reg,
            in1 => data_in,
            sel => min,
            o   => alu_y
        );

    -- Jump calculator
    JUMPCALC: jump
        port map (
            jlt => j(2),
            jz  => j(1),
            jgt => j(0),
            zr  => alu_zr,
            ng  => alu_ng,
            j   => jump_j
        );

    -- PC
    pc_set <= op(0) and jump_j;
    PCOUNT: pc
        port map (
            clock  => clock,
            reset  => reset,
            input  => A_reg(14 downto 0),
            set    => pc_set, 
            output => pc_out
        );

    inst_addr <= pc_out after 1 ns;

    -- ALU
    alu_x <= D_reg;

    ALU_i: alu
        port map(
            x => alu_x,
            y => alu_y,
            zx => c(5),
            nx => c(4),
            zy => c(3),
            ny => c(2),
            f  => c(1),
            no => c(0),
            o  => alu_out,
            zr => alu_zr,
            ng => alu_ng
        );

end rtl;
