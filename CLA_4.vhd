LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity CLA_4 is
	port(
		X : in std_logic_vector(3 downto 0);
		y : in std_logic_vector(3 downto 0);
		ci : in std_logic;
		co : out std_logic;
		z : out std_logic_vector(3 downto 0)
	);
end CLA_4;

architecture Behavioral of CLA_4 is
	signal carrys : std_logic_vector(4 downto 0) := (others => '0');
	signal p : std_logic_vector(3 downto 0) := (others => '0');
	signal g : std_logic_vector(3 downto 0) := (others => '0');
	
	begin
		 g <= x and y;
		 p <= x xor y;
		 carrys(0) <= ci;
		 
		 process(carrys, p, g) is
			 begin
				  for i in 0 to 3 loop
						carrys(i+1) <= g(i) or (p(i) and carrys(i));
				  end loop;
		 end process;
		 
		 co <= carrys(4);
		 z <= x xor y xor carrys(3 downto 0);
	
end Behavioral;