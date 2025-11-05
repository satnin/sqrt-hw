library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
	generic(
		nb_bits : integer := 32
	);
   PORT
	(
		SW: IN UNSIGNED(17 downto 0);
		KEY: IN	UNSIGNED(3 downto 0);
		CLOCK_50 : IN STD_LOGIC;
		LEDR: OUT 	UNSIGNED(17 downto 0);
		LEDG : OUT UNSIGNED(8 downto 0)
	);
end top;

architecture inst of top is

-- signal sig_A : unsigned(2*nb_bits-1 downto 0);
-- signal sig_S, sig_S2 : unsigned(nb_bits-1 downto 0);
signal sig_A_v : std_logic_vector(2*nb_bits-1 downto 0);
signal sig_S_v, sig_S2, sig_S3, sig_S4, sig_S5 : std_logic_vector(nb_bits-1 downto 0);
signal sig_clk, sig_reset, sig_debut, sig_fin, sig_fin2, sig_fin3, sig_fin4, sig_fin5 : std_logic;

component nios_system is
  port (
     clk_clk       : in std_logic := 'X'; -- clk
     reset_reset_n : in std_logic := 'X'  -- reset_n
  );
end component nios_system;

begin

-- sig_clk <= CLOCK_50;
-- sig_debut <= SW(17);
-- sig_reset <= not KEY(0);
-- sig_A <= SW(15 downto 0)&SW(15 downto 0)&SW(15 downto 0)&SW(15 downto 0);
-- LEDR(17 downto 0) <= sig_S(17 downto 0);
-- LEDG(0) <= sig_fin;

circuit: entity work.sqrt_seq(archi1)
		generic map(nb_bits => nb_bits)
		port map(A => sig_A_v, clk => sig_clk, debut => sig_debut, Resultat => sig_S_v, reset => sig_reset, fini => sig_fin);

circuit2: entity work.sqrt_seq(archi2)
		generic map(nb_bits => nb_bits)
		port map(A => sig_A_v, clk => sig_clk, debut => sig_debut, Resultat => sig_S2, reset => sig_reset, fini => sig_fin2);
	
circuit3: entity work.sqrt_seq(archi3)
		generic map(nb_bits => nb_bits)
		port map(A => sig_A_v, clk => sig_clk, debut => sig_debut, Resultat => sig_S3, reset => sig_reset, fini => sig_fin3);
		
circuit4: entity work.sqrt_seq(archi4)
		generic map(nb_bits => nb_bits)
		port map(A => sig_A_v, clk => sig_clk, debut => sig_debut, Resultat => sig_S4, reset => sig_reset, fini => sig_fin4);
		
circuit5: entity work.sqrt_seq(archi5)
		generic map(nb_bits => nb_bits)
		port map(A => sig_A_v, clk => sig_clk, debut => sig_debut, Resultat => sig_S5, reset => sig_reset, fini => sig_fin5);
		
	
NIOS0 : component nios_system
        port map (
            clk_clk       => sig_clk,       --   clk.clk
            reset_reset_n => KEY(0)  -- reset.reset_n
        );

pclk : process
        constant nb_period : natural := 500;
        begin
            sig_clk <= '0';
            wait for 10 ns;
            for i in 1 to nb_period loop
                sig_clk <= '1';
                wait for 10 ns;
                sig_clk <= '0';
                wait for 10 ns;
            end loop;
            wait;
        end process pclk;
		
pcarre : process
        begin
            for i in 1 to 2 loop
                sig_reset <= '1';
                wait for 5 ns;
                sig_reset <= '0';
                sig_A_v <= std_logic_vector(to_unsigned(0, 2*nb_bits));
                wait for 15 ns;
                sig_debut <= '1';
                wait for 15 ns;
                sig_debut <= '0';
                while sig_fin='0' loop
					wait for 1 ns;
				end loop;
                while sig_fin2='0' loop
					wait for 1 ns;
				end loop;
				while sig_fin3='0' loop
					wait for 1 ns;
				end loop;
				while sig_fin4='0' loop
					wait for 1 ns;
				end loop;
                wait for 5 ns;
				
				sig_reset <= '1';
                wait for 5 ns;
                sig_reset <= '0';
                sig_A_v <= std_logic_vector(to_unsigned(1, 2*nb_bits));
                wait for 15 ns;
                sig_debut <= '1';
                wait for 15 ns;
                sig_debut <= '0';
                while sig_fin='0' loop
					wait for 1 ns;
				end loop;
                while sig_fin2='0' loop
					wait for 1 ns;
				end loop;
				while sig_fin3='0' loop
					wait for 1 ns;
				end loop;
				while sig_fin4='0' loop
					wait for 1 ns;
				end loop;
                wait for 5 ns;
				
				sig_reset <= '1';
                wait for 5 ns;
                sig_reset <= '0';
                sig_A_v <= std_logic_vector(to_unsigned(512, 2*nb_bits));
                wait for 15 ns;
                sig_debut <= '1';
                wait for 15 ns;
                sig_debut <= '0';
                while sig_fin='0' loop
					wait for 1 ns;
				end loop;
                while sig_fin2='0' loop
					wait for 1 ns;
				end loop;
				while sig_fin3='0' loop
					wait for 1 ns;
				end loop;
				while sig_fin4='0' loop
					wait for 1 ns;
				end loop;
                wait for 5 ns;
				
				sig_reset <= '1';
                wait for 5 ns;
                sig_reset <= '0';
                sig_A_v <= std_logic_vector(to_unsigned(1194877489, 2*nb_bits));
                wait for 15 ns;
                sig_debut <= '1';
                wait for 15 ns;
                sig_debut <= '0';
                while sig_fin='0' loop
					wait for 1 ns;
				end loop;
                while sig_fin2='0' loop
					wait for 1 ns;
				end loop;
				while sig_fin3='0' loop
					wait for 1 ns;
				end loop;
				while sig_fin4='0' loop
					wait for 1 ns;
				end loop;
                wait for 5 ns;
				
				sig_reset <= '1';
                wait for 5 ns;
                sig_reset <= '0';
                sig_A_v <= "0000000000000000000000000000000011111111111111111111111111111111";
                wait for 15 ns;
                sig_debut <= '1';
                wait for 15 ns;
                sig_debut <= '0';
                while sig_fin='0' loop
					wait for 1 ns;
				end loop;
                while sig_fin2='0' loop
					wait for 1 ns;
				end loop;
				while sig_fin3='0' loop
					wait for 1 ns;
				end loop;
				while sig_fin4='0' loop
					wait for 1 ns;
				end loop;
                wait for 5 ns;
            end loop;
            wait;
        end process pcarre;

		
-- pcarre : process
        -- begin
            -- for i in 1 to 2 loop
                -- sig_A_v <= std_logic_vector(to_unsigned(0, 2*nb_bits));
                -- wait for 20 ns;
                
                -- sig_A_v <= std_logic_vector(to_unsigned(1, 2*nb_bits));
                -- wait for 20 ns;
                
                -- sig_A_v <= std_logic_vector(to_unsigned(512, 2*nb_bits));
                -- wait for 20 ns;
                
                -- sig_A_v <= std_logic_vector(to_unsigned(1194877489, 2*nb_bits));
                -- wait for 20 ns;
                
                -- sig_A_v <= "0000000000000000000000000000000011111111111111111111111111111111";
                -- wait for 20 ns;
            -- end loop;
            -- wait;
        -- end process pcarre;
		
end inst;