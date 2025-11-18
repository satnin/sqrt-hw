 library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator is
generic(nb_bits : natural :=32);
port(	A,B : in std_logic_vector(nb_bits-1 downto 0);
		Seq, Sinf, Ssup : out std_logic
	);
end comparator;

architecture proced of comparator is
signal Aint, Bint, Diff : signed(nb_bits-1 downto 0);
begin
	Aint <= signed(A);
	Bint <= signed(B);
	Diff <= Aint - Bint;
	P1: process(A, B)
	begin
		Seq <= '0';
		Sinf <= '0';
		Ssup <= '0';
		if (Diff < 0) then
			Sinf <= '1';
		elsif (Diff > 0) then
			Ssup <= '1';
		else
			Seq <= '1';
		end if;
	end process;
end proced;