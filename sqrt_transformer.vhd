library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sqrt_transformer is
    generic (
        nb_bits : integer := 32
    );
    port (
        iX, iZ, iV        : in   std_logic_vector(2*nb_bits-1 downto 0); 
        oX, oZ, oV        : out  std_logic_vector(2*nb_bits-1 downto 0) 
    );
end entity sqrt_transformer;
architecture arch of sqrt_transformer is
begin
	oZ <= '0'&iZ(2*nb_bits-1 downto 1) when unsigned(iX) < (unsigned(iZ) + unsigned(iV))
		else std_logic_vector(unsigned('0'&iZ(2*nb_bits-1 downto 1))+unsigned(iV));
	oX <= iX when unsigned(iX) < (unsigned(iZ) + unsigned(iV))
		else std_logic_vector(unsigned(iX) - unsigned(iZ) - unsigned(iV));
	oV <= "00"&iV(2*nb_bits-1 downto 2);
end arch;