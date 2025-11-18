 library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shifter is
generic(nb_bits : natural :=32);
port(	A : in std_logic_vector(nb_bits-1 downto 0);
		dec : in unsigned((nb_bits-1) downto 0);
		S : out std_logic_vector(2*nb_bits-1 downto 0)
	);
end shifter;

architecture proced of shifter is
	
signal Aint, Bint : unsigned(nb_bits-1 downto 0);
begin
	Aint <= unsigned(A);
	
	gen_shifters : for i in 0 to (2*nb_bits-1) generate
		S(i) <= A(i-to_integer(dec)) when i > dec and i < (nb_bits+to_integer(dec))
			else '0';
	end generate;

end proced;