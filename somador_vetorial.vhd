LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity somador_vetorial is
	port(
		A_i, B_i  : in std_logic_vector(31 downto 0);
		mode_i	 : in std_logic;
		vecSize_i : in std_logic_vector(1 downto 0);
		S_o		 : out std_logic_vector(31 downto 0)
	);
end somador_vetorial;

architecture Behavioral of somador_vetorial is

	component CLA_4 is
		port(
			X : in std_logic_vector(3 downto 0);
			y : in std_logic_vector(3 downto 0);
			ci : in std_logic;
			co : out std_logic;
			z : out std_logic_vector(3 downto 0)
		);
	end component CLA_4;
	
	signal B, saida8, saida4, saida2, saida1 : std_logic_vector(31 downto 0) := (others => '0');
	signal carrys : std_logic_vector(8 downto 0) := (others => '0'); -- sinal auxiliar 7 downto 0 = carrys, e carrys(0) sempre depende de mode_i
	
	begin
	
	-- carry (0) = 1 se mode_i = 0
	carrys(0) <= mode_i;

	ints_8: for i in 0 to 7 generate
		adder0to7: CLA_4 port map(A_i(4*(i+1)-1 downto 4*i), B(4*(i+1)-1 downto 4*i), carrys(0), carrys(i+1), saida8(4*(i+1)-1 downto 4*i));
	end generate;

	-- to do: corrigir lógica
	ints_4: for i in 0 to 3 generate
		adder8to11: CLA_4 port map(A_i(4*(2*i+1)-1 downto 8*i), B(4*(i*2+1)-1 downto 8*i), carrys(0), carrys(2*i+1), saida4(4*(i*2+1)-1 downto 8*i));
		adder12to15: CLA_4 port map(A_i(4*(2*i+2)-1 downto 4*(i*2+1)), B(4*(2*i+2)-1 downto 4*(i*2+1)), carrys(2*i+1), carrys(2*i+2), saida4(4*(2*i+2)-1 downto 4*(i*2+1)));
	end generate;

	ints_2: for i in 0 to 1 generate
		adder16to17: CLA_4 port map(A_i(4*(4*i+1)-1 downto 16*i), B(4*(4*i+1)-1 downto 16*i), carrys(0), carrys(4*i+1), saida2(4*(4*i+1)-1 downto 16*i));
		adder18to19: CLA_4 port map(A_i(4*(4*i+2)-1 downto 4*(i*4+1)), B(4*(4*i+2)-1 downto 4*(i*4+1)), carrys(4*i+1), carrys(4*i+2), saida2(4*(4*i+2)-1 downto 4*(i*4+1)));
		adder20to21: CLA_4 port map(A_i(4*(4*i+3)-1 downto 4*(i*4+2)), B(4*(4*i+3)-1 downto 4*(i*4+2)), carrys(4*i+2), carrys(4*i+3), saida2(4*(4*i+3)-1 downto 4*(i*4+2)));
		adder22to23: CLA_4 port map(A_i(4*(4*i+4)-1 downto 4*(i*4+3)), B(4*(4*i+4)-1 downto 4*(i*4+3)), carrys(4*i+3), carrys(4*i+4), saida2(4*(4*i+4)-1 downto 4*(i*4+3)));
	end generate;

	ints_1: for i in 0 to 7 generate
		adder24to30: CLA_4 port map(A_i(4*(i+1)-1 downto 4*i), B(4*(i+1)-1 downto 4*i), carrys(i), carrys(i+1), saida1(4*(i+1)-1 downto 4*i));
	end generate;
	
	process(vecSize_i, saida8, saida4, saida2, saida1, mode_i) is
		begin
			case vecSize_i is
				when "00" =>
					S_o <= saida8;
				when "01" =>
					S_o <= saida4;
				when "10" =>	
					S_o <= saida2;
				when "11" =>
					S_o <= saida1;
				when others =>
					S_o <= (others => 'Z');
			end case;
			
			--inverte B_i e soma 1 se mode_i = 1, se não B_i = B_i
			if mode_i = '0' then
				B <= B_i;
			elsif mode_i = '1' then
				B <= not B_i;
			end if;
	end process;
end Behavioral;
