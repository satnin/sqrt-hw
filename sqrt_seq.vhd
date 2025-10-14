library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sqrt_seq is
    generic (
        nb_bits : integer := 32
    );
    port (
        clk      : in  std_logic;                        -- Horloge
        reset    : in  std_logic;                        -- Réinitialisation active à '1'
        debut    : in  std_logic;                        -- Signal de démarrage
        A        : in  std_logic_vector(2*nb_bits-1 downto 0);  -- Entrée (valeur dont on calcule la racine)
        Resultat : out std_logic_vector((nb_bits)-1 downto 0); -- Sortie (racine carrée)
        count    : out  std_logic_vector(2*nb_bits-1 downto 0);
		  fini     : out std_logic                         -- Signal de fin
    );
end entity sqrt_seq;

--architecture archi1 of sqrt_seq is 
--	type TState is (IDLE, COMPUTE, DONE);
--    signal state       	: TState := IDLE;
--    signal f_state       : TState := IDLE;
--begin
--	process(clk, reset)
--	begin
--		if(reset='1') then
--			state <= IDLE;
--		else
--			if rising_edge(clk) then
--				state <= f_state;	
--			end if;
--		end if;
--	end process ; -- state
--	
--	process(state)
--	begin
--		case state is
--			when IDLE =>	
--
--			when COMPUTE =>
--			   
--			when DONE =>
--
--			when others =>
--			   f_state <= IDLE;
--		end case;
--	end process;
--	
--	process(state)
--	begin
--		case state is
--			when IDLE =>	
--
--			when COMPUTE =>
--			   
--			when DONE =>
--
--			when others =>
--		end case;
--	end process;
--end architecture;

architecture archi1 of sqrt_seq is 
	type TState is (IDLE, COMPUTE, DONE);
   signal state       	: TState := IDLE;
   signal f_state       : TState := IDLE;
	
	signal reg_A	: std_logic_vector(2*nb_bits-1 downto 0);
	signal reg_R	: std_logic_vector(2*nb_bits-1 downto 0);
	signal reg_R_prev	: std_logic_vector(2*nb_bits-1 downto 0);
	signal s_count : natural :=0; 
begin
	process(clk, reset)
	begin
		if(reset='1') then
			state <= IDLE;
		else
			if rising_edge(clk) then
				state <= f_state;
				case state is
					when IDLE =>
						reg_A <= A;
						s_count <= 0;
						reg_R <= '0'&reg_A(2*nb_bits-1 downto 1);
						reg_R_prev <= reg_A;
					when COMPUTE =>
						reg_A <= reg_A;
						s_count <= s_count + 1;
						reg_R_prev <= reg_R;
						reg_R <= std_logic_vector((unsigned(reg_R)+unsigned(reg_A)/unsigned(reg_R))/to_unsigned(2, 2*nb_bits));
					when DONE =>
						reg_A <= reg_A;
						s_count <= s_count;
					when others =>
						reg_A <= reg_A;
						s_count <= s_count;
				end case;
			end if;
		end if;
	end process ; -- state
	
	process(state,reg_R,reg_R_prev,debut)
	begin
		case state is
			when IDLE =>	
				if debut='1' then
					f_state <= COMPUTE;
				else
					f_state <= IDLE;
				end if;
			when COMPUTE =>
				if unsigned(reg_R) = unsigned(reg_R_prev) then
					f_state <= DONE;
				else
					f_state <= COMPUTE;
				end if;
			when DONE =>
				f_state <= DONE;
			when others =>
			   f_state <= IDLE;
		end case;
	end process;
	
	process(state, reg_R,reg_R_prev, reg_A)
	begin
		case state is
			when IDLE =>	
				fini <= '0';

			when COMPUTE =>
				fini <= '0';
			when DONE =>
				Resultat <= reg_R((nb_bits)-1 downto 0);
				fini <= '1';
			when others =>
		end case;
	end process;
	
	count <= std_logic_vector(to_unsigned(s_count, 2*nb_bits));
end archi1;
--
architecture archi2 of sqrt_seq is 

type TState is (IDLE, COMPUTE, DONE);
    signal state       	: TState := IDLE;
    signal f_state       : TState := IDLE;
	
	signal reg_A	: std_logic_vector(2*nb_bits-1 downto 0);
	signal reg_Z	: std_logic_vector(2*nb_bits-1 downto 0);
	signal reg_X	: std_logic_vector(2*nb_bits-1 downto 0);
	signal reg_V	: std_logic_vector(2*nb_bits-1 downto 0);
	signal s_count : natural :=0; 
	signal s_idx : natural :=0;
begin
	process(clk, reset)
	begin
		if(reset='1') then
			state <= IDLE;
		else
			if rising_edge(clk) then
				state <= f_state;
				case state is
					when IDLE =>
						reg_A <= A;
						s_count <= 0;
						reg_X <= std_logic_vector(to_unsigned(2**(2*nb_bits-2), 2*nb_bits));
						reg_V <= std_logic_vector(to_unsigned(2**(nb_bits-2), 2*nb_bits));
						reg_Z <= std_logic_vector(to_unsigned(2**(nb_bits-1), 2*nb_bits));
						s_idx <= 0;
					when COMPUTE =>
						reg_A <= reg_A;
						s_count <= s_count + 1;
						reg_V <= '0'&reg_V(2*nb_bits-1 downto 1);
						if unsigned(reg_X) > unsigned(reg_A) then
							reg_X <= std_logic_vector(unsigned(reg_X)+unsigned(reg_V)*(unsigned(reg_V)-unsigned(reg_Z(2*nb_bits-1 downto 1)&'0')));
							reg_Z <= std_logic_vector(unsigned(reg_Z)-unsigned(reg_V));
						elsif unsigned(reg_X) < unsigned(reg_A) then
							reg_X <= std_logic_vector(unsigned(reg_X)+unsigned(reg_V)*(unsigned(reg_V)+unsigned(reg_Z(2*nb_bits-1 downto 1)&'0')));
							reg_Z <= std_logic_vector(unsigned(reg_Z)+unsigned(reg_V));
						end if;
						s_idx <= s_idx + 1;
					when DONE =>
						reg_A <= reg_A;
						s_count <= s_count;
						if unsigned(reg_X) > unsigned(reg_A) then
							Resultat <= (std_logic_vector(unsigned(reg_Z)-1))(nb_bits-1 downto 0);
						else
							Resultat <= reg_Z(nb_bits-1 downto 0);
						end if;
					when others =>
						reg_A <= reg_A;
						s_count <= s_count;
				end case;
			end if;
		end if;
	end process ; -- state
	
	process(state,reg_Z,reg_X,reg_V,debut)
	begin
		case state is
			when IDLE =>	
				if debut='1' then
					f_state <= COMPUTE;
				else
					f_state <= IDLE;
				end if;
			when COMPUTE =>
				if s_idx = (nb_bits - 2) then
					f_state <= DONE;
				else
					f_state <= COMPUTE;
				end if;
			when DONE =>
				f_state <= DONE;
			when others =>
			   f_state <= IDLE;
		end case;
	end process;
	
	process(state)
	begin
		case state is
			when IDLE =>	
				fini <= '0';

			when COMPUTE =>
				fini <= '0';
			when DONE =>
				fini <= '1';
			when others =>
		end case;
	end process;
	
	count <= std_logic_vector(to_unsigned(s_count, 2*nb_bits));
	 
end archi2;
--
--architecture archi3 of sqrt_seq is 
--begin
--end archi3;
--
--architecture archi4 of sqrt_seq is 
--begin
--end archi4;
--
--architecture archi5 of sqrt_seq is 
--begin
--end archi5;