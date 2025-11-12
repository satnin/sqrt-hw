library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decompteur is
generic(nb_bits : natural ;
		  nb_iter : natural );
port(	Init,encount : in STD_LOGIC;
		clk : in STD_LOGIC;
		S : out UNSIGNED(nb_bits-1 downto 0);
		ceqz : out STD_LOGIC);
end decompteur;

architecture proced of decompteur is
signal Sint : unsigned(nb_bits-1 downto 0);
signal ceqzint : std_logic;
begin

Ps: process(clk, Init)
begin
	if (Init = '1') then
		Sint <= TO_UNSIGNED(nb_iter-1,nb_bits);
	elsif (clk'event and (clk = '1') and (encount = '1')) then
		Sint <= Sint - 1;
	end if;
end process;

Pc : process(Sint)
begin
	if Sint > 0 then
		ceqzint <= '0';
	else
		ceqzint <= '1';
	end if;
end process;

S <= Sint;
ceqz <= ceqzint;

end proced;