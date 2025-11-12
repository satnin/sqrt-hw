library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is
generic(nb_bits : natural);
port(	Init : in STD_LOGIC;
		ld : in STD_LOGIC;
		clk : in STD_LOGIC;
		valeur : in unsigned(nb_bits-1 downto 0);
		E : in UNSIGNED(nb_bits-1 downto 0);
		S : out UNSIGNED(nb_bits-1 downto 0));
end reg;

architecture proced of reg is
signal Sint : unsigned(nb_bits-1 downto 0);
begin

Ps: process(clk, Init, valeur)
begin
	if (Init = '1') then
		Sint <= valeur;
	elsif (clk'event and (clk = '1')) then
		if ld = '1' then
			Sint <= E;
		end if;
	end if;
end process;

S <= Sint;

end proced;