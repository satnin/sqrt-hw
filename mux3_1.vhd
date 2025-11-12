library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux3_1 is
generic(nb_bits : natural );
port(	I0,I1,I2 : in UNSIGNED(nb_bits-1 downto 0);
		sel : in STD_LOGIC_VECTOR(1 downto 0);
		S : out UNSIGNED(nb_bits-1 downto 0));
end mux3_1;

architecture proced of mux3_1 is
signal Sint : UNSIGNED(nb_bits-1 downto 0);
begin
	process(sel, I0, I1, I2)
		begin 
			if (sel = "00") then
				Sint <= I0;
			elsif (sel = "01") then
			  Sint <= I1;
			else
				Sint <= I2;
			end if;
	end process;
	S <= Sint;
end proced;