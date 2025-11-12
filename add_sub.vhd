 library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub is
generic(nb_bits : natural);
port(	A,B : in std_logic_vector(nb_bits-1 downto 0);
		Op : in STD_LOGIC;
		S : out std_logic_vector(nb_bits-1 downto 0);
		Cout : out STD_LOGIC);
end add_sub;

architecture proced of add_sub is
signal Aint, Bint : unsigned(nb_bits downto 0);
--signal Sint : signed(nb_bits downto 0);
signal Cin : natural range 0 to 1;
signal Sint : unsigned(nb_bits downto 0);
--signal Cin : std_logic;
begin

-- Aint <= '0' & A;
-- Bint <= '0' & B;
--
--process(Op, Aint, Bint)
--begin
--	if (Op = '0') then
--		Sint <= signed(Aint + Bint);
--	else
--		Sint <= signed(Aint - Bint);
--	end if;
--end process;
--
--S <= unsigned(Sint(nb_bits-1 downto 0));
--Cout <= Sint(nb_bits);

Aint <= '0' & unsigned(A);

P1: process(Op, B)
begin
	if (Op = '0') then
		Bint <= unsigned('0' & B);
		Cin <= 0;
	else
		Bint <= unsigned('1' & (NOT B));
		Cin <= 1;
	end if;
end process;

Sint <= Aint + Bint + Cin;

S <= std_logic_vector(Sint (nb_bits-1 downto 0));
Cout <= Sint(nb_bits);

--P2: process(A,Bint,Cin)
--	variable CC : std_logic_vector(nb_bits downto 0);
--begin
--	CC(0) := Cin;
--	for i in 0 to nb_bits-1 loop
--		S(i) <= A(i) XOR Bint(i) XOR CC(i);
--		CC(i+1) := (A(i) AND Bint(i)) OR (CC(i) AND (A(i) OR Bint(i)));
--	end loop;
--	Cout <= CC(nb_bits);
--end process P2;



end proced;