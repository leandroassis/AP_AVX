LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity STA_teste is
end STA_teste;

architecture Behavioral of STA_teste is

    component somador_vetorial is
        port(
            A_i, B_i  : in std_logic_vector(31 downto 0);
            mode_i	 : in std_logic;
            vecSize_i : in std_logic_vector(1 downto 0);
            S_o		 : out std_logic_vector(31 downto 0)
        );
    end component somador_vetorial;

    signal A, B, S : std_logic_vector(31 downto 0);
    signal mode : std_logic;
    signal vecSize : std_logic_vector(1 downto 0);

    begin
            
        UUT : somador_vetorial port map(A, B, mode, vecSize, S);
    
        process
            begin
                for i in 555555530 to 555555555 loop
                    A <= std_logic_vector(to_unsigned(867433833, 32));
                    B <= std_logic_vector(to_unsigned(494984588, 32));
                    mode <= '0';
                    vecSize <= "01";
                    wait for 1 ns;
                end loop;
        end process;

end Behavioral;