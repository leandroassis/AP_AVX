library ieee;
use ieee.std_logic_1164.all;

entity CLA_4 is
	port(
		X : in STD_LOGIC_VECTOR(3 downto 0);
		y : in STD_LOGIC_VECTOR(3 downto 0);
		ci : in STD_LOGIC;
		co : out STD_LOGIC;
		z : out STD_LOGIC_VECTOR(3 downto 0)
	);
end CLA_4;

architecture Behavioral of CLA_4 is
	signal carrys : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
	signal p : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
	signal g : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
	
	begin
		 g <= x and y;
		 p <= x xor y;
		 carrys(0) <= ci;
		 
		 process(carrys, p, g) is
			 begin
				  for i in 0 to 3 loop
						carrys(i+1) <= g(i) or (p(i) and c(i));
				  end loop;
		 end process;
		 
		 co <= carrys(4);
		 s <= x xor y xor carrys(3 downto 0);
	
end Behavioral;


entity somador_vetorial is
	port(
		A_i, B_i  : in STD_LOGIC_VECTOR(31 downto 0);
		mode_i	 : in STD_LOGIC;
		vecSize_i : in STD_LOGIC_VECTOR(1 downto 0);
		S_o		 : out STD_LOGIC_VECTOR(31 downto 0)
	);
end somador_vetorial;

architecture Structural of somador_vetorial is

component CLA_4 is
	port(
		X : in STD_LOGIC_VECTOR(3 downto 0);
		y : in STD_LOGIC_VECTOR(3 downto 0);
		ci : in STD_LOGIC;
		co : out STD_LOGIC;
		z : out STD_LOGIC_VECTOR(3 downto 0)
	);
end component CLA_4;
	signal saida8int : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	signal saida4int : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	signal saida2int : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	signal saida1int : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	
	signal carrys : STD_LOGIC_VECTOR(8 downto 0) := (others => '0'); -- sinal auxiliar 7 downto 0 = carrys e carrys(0) sempre 0
	
	begin
	
	process(vecSize_i, saida) is
		begin
			case vecSize is
				when "00" =>
					8ints: for 0 to 7 loop
						CLA_4 port map(A_i(4*(i+1)-1 downto 4*i), B_i(4*(i+1)-1 downto 4*i), carrys(0), carrys(i+1), saida(4*(i+1)-1 downto 4*i));
					end loop;
					
				when "01" =>
					4ints: for 0 to 3 loop
						CLA_4 port map(A_i(4*(2*i+1)-1 downto 8*i), B_i(4*(i*2+1)-1 downto 8*i), carrys(0), carrys(2*i+1), saida(4*(i*2+1)-1 downto 4*i));
						CLA_4 port map(A_i(4*(2*i+2)-1 downto 4*(i*2+1)), B_i(4*(2*i+2)-1 downto 4*(i*2+1)), carrys(2*i+1), carrys(2*i+2), saida(4*(2*i+2)-1 downto 4*(i*2+1)));
					end loop;
				
				when "10" =>
					2ints: for 0 to 1 loop
						CLA_4 port map(A_i(4*(4*i+1)-1 downto 16*i), B_i(4*(i*2+1)-1 downto 16*i), carrys(0), carrys(4*i+1), saida(4*(i*4+1)-1 downto 16*i));
						CLA_4 port map(A_i(4*(4*i+2)-1 downto 4*(i*4+1)), B_i(4*(4*i+2)-1 downto 4*(i*4+1)), carrys(4*i+1), carrys(4*i+2), saida(4*(4*i+2)-1 downto 4*(i*4+1)));
						CLA_4 port map(A_i(4*(4*i+3)-1 downto 4*(i*4+2)), B_i(4*(4*i+3)-1 downto 4*(i*4+2)), carrys(4*i+2), carrys(4*i+3), saida(4*(4*i+3)-1 downto 4*(i*4+2)));
						CLA_4 port map(A_i(4*(4*i+4)-1 downto 4*(i*4+3)), B_i(4*(4*i+4)-1 downto 4*(i*4+3)), carrys(4*i+3), carrys(4*i+4), saida(4*(4*i+4)-1 downto 4*(i*4+3)));
					end loop;
					
				when "11" =>
					1int: for 0 to 7 loop
						CLA_4 port map(A_i(4*(i+1)-1 downto 4*i), B_i(4*(i+1)-1 downto 4*i), carrys(i), carrys(i+1), saida(4*(i+1)-1 downto 4*i));
					end loop;
					
				when others =>
					saida <= (others => 'Z');
			end case;
		
	end process;
	
	S_o <= saida;
	
end Structural;