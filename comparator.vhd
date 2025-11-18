 library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator is
generic(nb_bits : natural);
port(	A,B : in std_logic_vector(nb_bits-1 downto 0);
		Seq, Sinf, Ssup : out std_logic
	);
end comparator;

architecture proced of comparator is
signal Aint, Bint : unsigned(nb_bits-1 downto 0);
begin
	Aint <= unsigned(A);
	Bint <= unsigned(B);
	P1: process(A, B)
	begin
		Seq <= '0';
		Sinf <= '0';
		Ssup <= '0';
		if (Aint < Bint) then
			Sinf <= '1';
		elsif (Bint > Aint) then
			Ssup <= '1';
		else
			Seq <= '1';
		end if;
	end process;
end proced;