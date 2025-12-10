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
						if unsigned(reg_A) > 1 then
							reg_R <= '0'&reg_A(2*nb_bits-1 downto 1);
						else
							reg_R <= reg_A;
						end if;
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
				elsif unsigned(reg_R)-1 = unsigned(reg_R_prev) then
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
	
	signal reg_mult_1, reg_mult_2	: std_logic_vector(4*nb_bits-1 downto 0);
	signal s_count : integer :=0; 
	signal s_idx : integer :=0;
	
	signal reg_Z_v	: std_logic_vector(2*nb_bits-1 downto 0);
begin
	
	reg_Z_v <= std_logic_vector(unsigned(reg_Z)-1);
	reg_mult_1 <= std_logic_vector(unsigned(reg_X)+unsigned(reg_V)*(unsigned(reg_V)-unsigned(reg_Z(2*nb_bits-2 downto 0)&'0')));
	reg_mult_2 <= std_logic_vector(unsigned(reg_X)+unsigned(reg_V)*(unsigned(reg_V)+unsigned(reg_Z(2*nb_bits-2 downto 0)&'0')));
	
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
						reg_X <= std_logic_vector(to_unsigned(2**(nb_bits-2), nb_bits))&std_logic_vector(to_unsigned(0, nb_bits));
						reg_V <= std_logic_vector(to_unsigned(2**(nb_bits-2), 2*nb_bits));
						reg_Z <= std_logic_vector(to_unsigned(2**(nb_bits-1), 2*nb_bits));
						s_idx <= 0;
					when COMPUTE =>
						reg_A <= reg_A;
						s_count <= s_count + 1;
						reg_V <= '0'&reg_V(2*nb_bits-1 downto 1);
						if unsigned(reg_X) > unsigned(reg_A) then
							reg_X <= reg_mult_1(2*nb_bits-1 downto 0);
							reg_Z <= std_logic_vector(unsigned(reg_Z)-unsigned(reg_V));
						elsif unsigned(reg_X) < unsigned(reg_A) then
							reg_X <= reg_mult_2(2*nb_bits-1 downto 0);
							reg_Z <= std_logic_vector(unsigned(reg_Z)+unsigned(reg_V));
						end if;
						s_idx <= s_idx + 1;
					when DONE =>
						reg_A <= reg_A;
						s_count <= s_count;
					when others =>
				end case;
			end if;
		end if;
	end process ; -- state
	
	process(state,reg_Z,reg_X,reg_V,debut, s_idx)
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
	
	process(state, reg_A, reg_X, reg_Z_v, reg_Z)
	begin
		case state is
			when IDLE =>	
				fini <= '0';

			when COMPUTE =>
				fini <= '0';
			when DONE =>
				fini <= '1';
				if unsigned(reg_A) < 2 then
					Resultat <= reg_A(nb_bits-1 downto 0);
				elsif unsigned(reg_X) > unsigned(reg_A) then
					Resultat <= reg_Z_v(nb_bits-1 downto 0);
				else
					Resultat <= reg_Z(nb_bits-1 downto 0);
				end if;
			when others =>
		end case;
	end process;
	
	count <= std_logic_vector(to_unsigned(s_count, 2*nb_bits));
	 
end archi2;

architecture archi3 of sqrt_seq is 

type TState is (IDLE, COMPUTE, DONE);
    signal state       	: TState := IDLE;
    signal f_state       : TState := IDLE;
	
	signal reg_A	: std_logic_vector(2*nb_bits-1 downto 0);
	signal reg_Z	: std_logic_vector(2*nb_bits-1 downto 0);
	signal reg_X	: std_logic_vector(2*nb_bits-1 downto 0);
	signal reg_V	: std_logic_vector(2*nb_bits-1 downto 0);
	
	-- signal reg_mult_1, reg_mult_2	: std_logic_vector(4*nb_bits-1 downto 0);
	signal s_count : integer :=0; 
	signal s_idx : integer :=0;
	
	-- signal reg_Z_v	: std_logic_vector(2*nb_bits-1 downto 0);
begin
	
	-- reg_Z_v <= std_logic_vector(unsigned(reg_Z)-1);
	-- reg_mult_1 <= std_logic_vector(unsigned(reg_X)+unsigned(reg_V)*(unsigned(reg_V)-unsigned(reg_Z(2*nb_bits-2 downto 0)&'0')));
	-- reg_mult_2 <= std_logic_vector(unsigned(reg_X)+unsigned(reg_V)*(unsigned(reg_V)+unsigned(reg_Z(2*nb_bits-2 downto 0)&'0')));
	
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
						reg_X <= A;
						reg_V <= std_logic_vector(to_unsigned(2**(nb_bits-2), nb_bits))&std_logic_vector(to_unsigned(0, nb_bits));
						reg_Z <= std_logic_vector(to_unsigned(0, 2*nb_bits));
						s_idx <= 0;
					when COMPUTE =>
						reg_A <= reg_A;
						s_count <= s_count + 1;
						
						if unsigned(reg_X) < (unsigned(reg_Z) + unsigned(reg_V)) then
							reg_Z <= '0'&reg_Z(2*nb_bits-1 downto 1);
						else
							reg_Z <= std_logic_vector(unsigned('0'&reg_Z(2*nb_bits-1 downto 1))+unsigned(reg_V));
							reg_X <= std_logic_vector(unsigned(reg_X) - unsigned(reg_Z) - unsigned(reg_V));
						end if;
						reg_V <= "00"&reg_V(2*nb_bits-1 downto 2);
						s_idx <= s_idx + 1;
					when DONE =>
						reg_A <= reg_A;
						s_count <= s_count;
					when others =>
				end case;
			end if;
		end if;
	end process ; -- state
	
	process(state,reg_Z,reg_X,reg_V,debut, s_idx)
	begin
		case state is
			when IDLE =>	
				if debut='1' then
					f_state <= COMPUTE;
				else
					f_state <= IDLE;
				end if;
			when COMPUTE =>
				if s_idx = (nb_bits - 1) then
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
	
	process(state, reg_A, reg_Z)
	begin
		case state is
			when IDLE =>	
				fini <= '0';

			when COMPUTE =>
				fini <= '0';
			when DONE =>
				fini <= '1';
				if unsigned(reg_A) < 2 then
					Resultat <= reg_A(nb_bits-1 downto 0);
				else
					Resultat <= reg_Z(nb_bits-1 downto 0);
				end if;
				
			when others =>
		end case;
	end process;
	
	count <= std_logic_vector(to_unsigned(s_count, 2*nb_bits));
	 
end archi3;
--

--
architecture archi4 of sqrt_seq is 
type b_array is array (0 to nb_bits) of std_logic_vector(2*nb_bits-1 downto 0);
signal s_X_tab, s_Z_tab, s_V_tab : b_array;
begin

	s_X_tab(0) <= A;
	s_V_tab(0) <= std_logic_vector(to_unsigned(2**(nb_bits-2), nb_bits))&std_logic_vector(to_unsigned(0, nb_bits));
	s_Z_tab(0) <= std_logic_vector(to_unsigned(0, 2*nb_bits));
	
	Resultat <= s_Z_tab(nb_bits)(nb_bits-1 downto 0);
	
	gen_components : for i in 0 to (nb_bits - 1) generate
		trans_i: entity work.sqrt_transformer(arch)
		generic map(nb_bits => nb_bits)
        port map (
            iX => s_X_tab(i),
            iZ => s_Z_tab(i),
            iV => s_V_tab(i),
            oX => s_X_tab(i+1),
            oZ => s_Z_tab(i+1),
            oV => s_V_tab(i+1)
        );
	end generate;
end archi4;

architecture archi5 of sqrt_seq is 
type b_array is array (0 to nb_bits) of std_logic_vector(2*nb_bits-1 downto 0);
signal s_X_tab, s_Z_tab, s_V_tab : b_array;
signal s_X_tab_r, s_Z_tab_r, s_V_tab_r : b_array;
begin

	s_X_tab_r(0) <= A;
	s_V_tab_r(0) <= std_logic_vector(to_unsigned(2**(nb_bits-2), nb_bits))&std_logic_vector(to_unsigned(0, nb_bits));
	s_Z_tab_r(0) <= std_logic_vector(to_unsigned(0, 2*nb_bits));
	
	Resultat <= s_Z_tab(nb_bits)(nb_bits-1 downto 0);
	
	gen_components : for i in 0 to (nb_bits - 1) generate
		trans_i: entity work.sqrt_transformer(arch)
		generic map(nb_bits => nb_bits)
        port map (
            iX => s_X_tab(i),
            iZ => s_Z_tab(i),
            iV => s_V_tab(i),
            oX => s_X_tab_r(i+1),
            oZ => s_Z_tab_r(i+1),
            oV => s_V_tab_r(i+1)
        );
	end generate;
	
	gen_registers : for i in 0 to (nb_bits) generate
		reg_i: entity work.sqrt_transformer_reg(arch)
		generic map(nb_bits => nb_bits)
        port map (
			clk => clk,
            iX => s_X_tab_r(i),
            iZ => s_Z_tab_r(i),
            iV => s_V_tab_r(i),
            oX => s_X_tab(i),
            oZ => s_Z_tab(i),
            oV => s_V_tab(i)
        );
	end generate;
	
end archi5;
--
architecture archi6 of sqrt_seq is 
	type TState is (IDLE, COMPUTE, FINISHED, DONE);
    signal state       	: TState := IDLE;
    signal f_state       : TState := IDLE;
	signal s_ceq, s_end, s_init_C, s_init_A, s_init_X, s_init_V, s_init_Z, s_init_R : STD_LOGIC; 
	signal s_encount_C, s_ld_A, s_ld_X, s_ld_V, s_ld_Z, s_ld_R : STD_LOGIC; 
	signal s_regA_S, s_regX_S, s_regA_E, s_regX_E 						: STD_LOGIC_VECTOR(2*nb_bits-1 downto 0); 
	signal s_regZ_S, s_regR_S, s_regV_S, s_regZ_E, s_regR_E, s_regV_E 	: STD_LOGIC_VECTOR(nb_bits-1 downto 0); 
	signal s_regA_S_u, s_regX_S_u 										: unsigned(2*nb_bits-1 downto 0); 
	signal s_regZ_S_u, s_regR_S_u, s_regV_S_u 										: unsigned(nb_bits-1 downto 0); 
	
	signal s_regZ_S2	: STD_LOGIC_VECTOR(nb_bits+1 downto 0); 
	signal s_regV_S2	: STD_LOGIC_VECTOR(nb_bits+1 downto 0); 
	
	signal s_count_S : UNSIGNED(nb_bits+1 downto 0); 
	signal s_comp_inf, s_comp_eq, s_comp_sup : STD_LOGIC; 
	signal s_muxV_S : UNSIGNED(nb_bits -1 downto 0);
	signal s_shift_S : STD_LOGIC_VECTOR(2*nb_bits +3 downto 0);
	signal s_shift_E : STD_LOGIC_VECTOR(nb_bits+1 downto 0);
	signal s_muxV2_S : UNSIGNED(2*nb_bits -1 downto 0);
	signal s_muxZ_S : UNSIGNED(nb_bits -1 downto 0);
	signal s_Res : STD_LOGIC_VECTOR(nb_bits -1 downto 0);

	-- signal s_Aint : unsigned(2*nb_bits-1 downto 0);

begin

	s_regZ_S2 <= '0'&s_regZ_S&'0';
	s_regV_S2 <= "00"&s_regV_S;
	process(clk, reset)
	begin
		if(reset='1') then
			state <= IDLE;
		else
			if rising_edge(clk) then
				state <= f_state;
			end if;
		end if;
	end process ; -- state
	
	process(state, debut, s_ceq)
	begin
		s_init_C <= '0';
		s_encount_C <= '0';

		s_init_R <= '0';
		s_ld_R <= '0';
		
		s_init_A <= '0';
		s_init_X <= '0';
		s_init_V <= '0';
		s_init_Z <= '0';
		s_ld_A <= '0';
		s_ld_X <= '0';
		s_ld_V <= '0';
		s_ld_Z <= '0';

		s_end <= '0';
		
		fini <= '0';
		case state is
			when IDLE =>
				if(debut='1') then
					f_state <= COMPUTE;
				else
					f_state <= IDLE;
				end if;
				s_init_C <= '1';

				s_init_A <= '1';
				s_init_X <= '1';
				s_init_V <= '1';
				s_init_Z <= '1';
			when COMPUTE =>
				if(s_ceq='1') then
					f_state <= FINISHED;
				else
					f_state <= COMPUTE;
				end if;
				s_ld_R <= '1';

				s_ld_A <= '1';
				s_ld_X <= '1';
				s_ld_V <= '1';
				s_ld_Z <= '1';

				s_encount_C <= '1';
			
			when FINISHED =>
				f_state <= DONE;
				s_ld_R <= '1';
				s_ld_A <= '1';
				s_ld_X <= '1';
				s_ld_V <= '1';
				s_ld_Z <= '1';
				s_end <= '1';
				if to_integer(unsigned(A)) = 0 then
					s_init_R <= '1';
				end if;
			when DONE =>
				if(debut='1') then
					f_state <= DONE;
				else
					f_state <= IDLE;
				end if;
				
				fini <= '1';
				s_end <= '1';
				Resultat <= s_regR_E;
				
				
			when others =>
				f_state <= IDLE;
		end case;
	end process ; -- state

	
	regA: entity work.reg(proced)
	generic map(nb_bits => 2*nb_bits)
	port map (
		clk => clk,
		valeur => unsigned(A),
		Init => s_init_A,
		ld => s_ld_A,
		E => unsigned(s_regA_E),
		S => s_regA_S_u 
	);
	s_regA_E <= s_regA_S;

	regX: entity work.reg(proced)
	generic map(nb_bits => 2*nb_bits)
	port map (
		clk => clk,
		valeur => unsigned(std_logic_vector(to_unsigned(2**(nb_bits-2), nb_bits))&std_logic_vector(to_unsigned(0, nb_bits))),
		Init => s_init_X,
		ld => s_ld_X,
		E => unsigned(s_regX_E),
		S => s_regX_S_u 
	);

	regV: entity work.reg(proced)
	generic map(nb_bits => nb_bits)
	port map (
		clk => clk,
		valeur => to_unsigned(2**(nb_bits-2), nb_bits),
		Init => s_init_V,
		ld => s_ld_V,
		E => unsigned(s_regV_E),
		S => s_regV_S_u 
	);

	s_regV_E <= '0'&s_regV_S(nb_bits-1 downto 1);

	
	regZ: entity work.reg(proced)
	generic map(nb_bits => nb_bits)
	port map (
		clk => clk,
		valeur => to_unsigned(2**(nb_bits-1), nb_bits),
		Init => s_init_Z,
		ld => s_ld_Z,
		E => unsigned(s_regZ_E),
		S => s_regZ_S_u 
	);
	regR: entity work.reg(proced)
	generic map(nb_bits => nb_bits)
	port map (
		clk => clk,
		valeur => to_unsigned(0, nb_bits),
		Init => s_init_R,
		ld => s_ld_R,
		E => unsigned(s_regR_E),
		S => s_regR_S_u 
	);
	s_regR_E <= std_logic_vector(s_muxZ_S);
	
	s_count_S(nb_bits+1 downto nb_bits) <= "00";

	counter: entity work.decompteur(proced)
	generic map(nb_bits => nb_bits, nb_iter => nb_bits-1)
	port map (
		clk => clk,
		Init => s_init_C,
		encount => s_encount_C,
		S => s_count_S(nb_bits-1 downto 0),
		ceqz => s_ceq
	);

	comparator : entity work.comparator(proced)
	generic map(nb_bits => 2*nb_bits)
	port map (
		A => s_regX_S,
		B => s_regA_S,
		Seq => s_comp_eq,
		Sinf => s_comp_inf,
		Ssup => s_comp_sup
	);

	u_mux3_1 : entity work.mux3_1(proced)
	generic map(
		nb_bits  => nb_bits)
	port map(
		-- ports
		I0   => unsigned(s_regV_S),
		I1   => TO_UNSIGNED(0, nb_bits),
		I2   => TO_UNSIGNED(1, nb_bits),
		sel(1)  => s_end,
		sel(0)  => s_comp_eq,
		S    => s_muxV_S
	);
	u_mux2_1_z : entity work.mux2_1(proced)
	generic map(
		nb_bits  => nb_bits)
	port map(
		-- ports
		I0   => s_regZ_S_u,
		I1   => unsigned(s_regZ_E),
		sel  => s_comp_sup,
		S    => s_muxZ_S
	);

	s_regR_E <= STD_LOGIC_VECTOR(s_muxZ_S);
	
	u_mux2_1_v : entity work.mux2_1(proced)
	generic map(
		nb_bits  => 2*nb_bits)
	port map(
		-- ports
		I0   => unsigned(s_shift_S(2*nb_bits - 1 downto 0)),
		I1   => TO_UNSIGNED(0, 2*nb_bits),
		sel  => s_comp_eq,
		S    => s_muxV2_S
	);

	shifter: entity work.shifter(proced)
	generic map(
		nb_bits => nb_bits + 2
	)
	port map(
		A => s_shift_E,
		dec => s_count_S,
		S => s_shift_S
	);

	add_z : entity work.add_sub(proced)
	generic map(
		nb_bits  => nb_bits)
	port map(
		-- ports
		A     => s_regZ_S,
		B     => STD_LOGIC_VECTOR(s_muxV_S),
		Op    => s_comp_sup,
		S     => s_regZ_E
	);

	add_v : entity work.add_sub(proced)
	generic map(
		nb_bits  => nb_bits+2)
	port map(
		-- ports
		A     => s_regV_S2,
		B     => s_regZ_S2,
		Op    => s_comp_sup,
		S     => s_shift_E
	);
	add_x : entity work.add_sub(proced)
	generic map(
		nb_bits  => 2*nb_bits)
	port map(
		-- ports
		A     => s_regX_S,
		B     => STD_LOGIC_VECTOR(s_muxV2_S),
		Op    => '0',
		S     => s_regX_E
	);

	s_regA_S <= STD_LOGIC_VECTOR(s_regA_S_u); 
	s_regX_S <= STD_LOGIC_VECTOR(s_regX_S_u); 
	s_regV_S <= STD_LOGIC_VECTOR(s_regV_S_u); 
	s_regZ_S <= STD_LOGIC_VECTOR(s_regZ_S_u); 
	s_regR_S <= STD_LOGIC_VECTOR(s_regR_S_u);
end archi6;

architecture archi7 of sqrt_seq is 
	type TState is (IDLE, COMPUTE, DONE);
    signal state       	: TState := IDLE;
    signal f_state       : TState := IDLE;
	signal s_ceq, s_end, s_init_C, s_init_A, s_init_V, s_init_Z, s_init_R : STD_LOGIC; 
	signal s_encount_C, s_ld_A, s_ld_V, s_ld_Z, s_ld_R : STD_LOGIC; 
	signal s_regA_S, s_regA_E 						: STD_LOGIC_VECTOR(2*nb_bits-1 downto 0); 
	signal s_regZ_S, s_regR_S, s_regV_S, s_regZ_E, s_regR_E, s_regV_E 	: STD_LOGIC_VECTOR(2*nb_bits-1 downto 0); 
	signal s_regA_S_u 										: unsigned(2*nb_bits-1 downto 0); 
	signal s_regZ_S_u, s_regR_S_u, s_regV_S_u 										: unsigned(2*nb_bits-1 downto 0); 
	
	
	signal s_count_S : UNSIGNED(nb_bits+1 downto 0); 
	signal s_comp_inf, s_comp_eq, s_comp_sup : STD_LOGIC; 
	signal s_muxV2_S : UNSIGNED(2*nb_bits -1 downto 0);
	signal s_muxZ_S : UNSIGNED(2*nb_bits -1 downto 0);
	signal s_add_S, s_regV_S_l1, s_orZ_S, s_orA_S : STD_LOGIC_VECTOR(2*nb_bits-1 downto 0);

begin

	process(clk, reset)
	begin
		if(reset='1') then
			state <= IDLE;
		else
			if rising_edge(clk) then
				state <= f_state;
			end if;
		end if;
	end process ; -- state
	
	process(state, debut, s_ceq)
	begin
		s_init_C <= '0';
		s_encount_C <= '0';
		
		s_init_A <= '0';
		s_init_V <= '0';
		s_init_Z <= '0';
		s_ld_A <= '0';
		s_ld_V <= '0';
		s_ld_Z <= '0';

		s_end <= '0';
		
		fini <= '0';
		case state is
			when IDLE =>
				if(debut='1') then
					f_state <= COMPUTE;
				else
					f_state <= IDLE;
				end if;
				s_init_C <= '1';

				s_init_A <= '1';
				s_init_V <= '1';
				s_init_Z <= '1';
			when COMPUTE =>
				if(s_ceq='1') then
					f_state <= DONE;
				else
					f_state <= COMPUTE;
				end if;
				s_ld_R <= '1';

				s_ld_A <= '1';
				s_ld_V <= '1';
				s_ld_Z <= '1';

				s_encount_C <= '1';
			
			when DONE =>
				if(debut='1') then
					f_state <= DONE;
				else
					f_state <= IDLE;
				end if;
				
				fini <= '1';
				s_end <= '1';
			when others =>
				f_state <= IDLE;
		end case;
	end process ; -- state

	Resultat <= s_regZ_S(nb_bits-1 downto 0);
	
	regA: entity work.reg(proced)
	generic map(nb_bits => 2*nb_bits)
	port map (
		clk => clk,
		valeur => unsigned(A),
		Init => s_init_A,
		ld => s_ld_A,
		E => unsigned(s_regA_E),
		S => s_regA_S_u 
	);
	

	-- regX: entity work.reg(proced)
	-- generic map(nb_bits => 2*nb_bits)
	-- port map (
	-- 	clk => clk,
	-- 	valeur => unsigned(std_logic_vector(to_unsigned(2**(nb_bits-2), nb_bits))&std_logic_vector(to_unsigned(0, nb_bits))),
	-- 	Init => s_init_X,
	-- 	ld => s_ld_X,
	-- 	E => unsigned(s_regX_E),
	-- 	S => s_regX_S_u 
	-- );

	regV: entity work.reg(proced)
	generic map(nb_bits => 2*nb_bits)
	port map (
		clk => clk,
		valeur => unsigned(std_logic_vector(to_unsigned(2**(nb_bits-2), nb_bits))&std_logic_vector(to_unsigned(0, nb_bits))),
		Init => s_init_V,
		ld => s_ld_V,
		E => unsigned(s_regV_E),
		S => s_regV_S_u 
	);

	s_regV_E <= "00"&s_regV_S(2*nb_bits-1 downto 2);

	
	regZ: entity work.reg(proced)
	generic map(nb_bits => 2*nb_bits)
	port map (
		clk => clk,
		valeur => to_unsigned(0, 2*nb_bits),
		Init => s_init_Z,
		ld => s_ld_Z,
		E => unsigned(s_regZ_E),
		S => s_regZ_S_u 
	);

	
	
	counter: entity work.decompteur(proced)
	generic map(nb_bits => nb_bits, nb_iter => nb_bits)
	port map (
		clk => clk,
		Init => s_init_C,
		encount => s_encount_C,
		ceqz => s_ceq
	);

	comparator : entity work.comparator(proced)
	generic map(nb_bits => 2*nb_bits)
	port map (
		B => s_regA_S,
		A => s_orA_S,
		Seq => s_comp_eq,
		Sinf => s_comp_inf,
		Ssup => s_comp_sup
	);

	s_regV_S_l1 <= s_regV_S(2*nb_bits-2 downto 0)&'0';
	u_mux2_1_z : entity work.mux2_1(proced)
	generic map(
		nb_bits  => 2*nb_bits)
	port map(
		-- ports
		I0   => unsigned(s_regV_S_l1),
		I1   => to_unsigned(0, 2*nb_bits),
		sel  => s_comp_inf,
		S    => s_muxZ_S
	);

	or_op_z : entity work.or_op(proced)
	generic map(nb_bits => 2*nb_bits)
	port map (
		A => s_regZ_S,
		B => std_logic_vector(s_muxZ_S),
		S => s_orZ_S
	);
	s_regZ_E <= '0'&s_orZ_S(2*nb_bits-1 downto 1);

	or_op_a : entity work.or_op(proced)
	generic map(nb_bits => 2*nb_bits)
	port map (
		A => s_regZ_S,
		B => s_regV_S,
		S => s_orA_S
	);
	
	u_mux2_1_v : entity work.mux2_1(proced)
	generic map(
		nb_bits  => 2*nb_bits)
	port map(
		-- ports
		I0   => unsigned(s_add_S),
		I1   => s_regA_S_u,
		sel  => s_comp_inf,
		S    => s_muxV2_S
	);

	s_regA_E <= STD_LOGIC_VECTOR(s_muxV2_S);

	add : entity work.add_sub(proced)
	generic map(
		nb_bits  => 2*nb_bits)
	port map(
		-- ports
		A     => s_regA_S,
		B     => s_orA_S,
		Op   => '1',
		S => s_add_S
	);
	
	s_regA_S <= STD_LOGIC_VECTOR(s_regA_S_u); 
	s_regV_S <= STD_LOGIC_VECTOR(s_regV_S_u); 
	s_regZ_S <= STD_LOGIC_VECTOR(s_regZ_S_u); 
	s_regR_S <= STD_LOGIC_VECTOR(s_regR_S_u);
end archi7;