library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux2_1 is
generic(nb_bits : natural );
port(	I0,I1 : in UNSIGNED(nb_bits-1 downto 0);
		sel : in STD_LOGIC;
		S : out UNSIGNED(nb_bits-1 downto 0));
end mux2_1;

architecture proced of mux2_1 is
signal Sint : UNSIGNED(nb_bits-1 downto 0);
begin
	process(sel, I0, I1)
		begin 
			if (sel = '0') then
				Sint <= I0;
			else
				Sint <= I1;
			end if;
	end process;
	S <= Sint;
end proced;