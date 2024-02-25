library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity project_reti_logiche is
    port (
        i_clk : in std_logic;
        i_rst: in std_logic;
        i_start : in std_logic;
        i_w : in std_logic;
        o_z0 : out std_logic_vector(7 downto 0);
        o_z1 : out std_logic_vector(7 downto 0);
        o_z2 : out std_logic_vector(7 downto 0);
        o_z3 : out std_logic_vector(7 downto 0);
        o_done : out std_logic;
        o_mem_addr : out std_logic_vector(15 downto 0);
        i_mem_data : in std_logic_vector(7 downto 0);
        o_mem_we : out std_logic;
        o_mem_en : out std_logic
    );
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is

component datapath is
    port (
        i_clk:  in STD_LOGIC;
        i_str:  in STD_LOGIC;
        i_rst:  in STD_LOGIC;
        i_clr:  in STD_LOGIC;
        i_sel:  in STD_LOGIC;
        i_flag:  in STD_LOGIC;
        i_w:    in STD_LOGIC;
        i_mem_data: in STD_LOGIC_VECTOR (7 downto 0);
        r0_load: in STD_LOGIC;
        r1_load: in STD_LOGIC;
        o_r0: out STD_LOGIC_VECTOR (15 downto 0);
        --r2_load: in STD_LOGIC;
        --r2_sel:  in STD_LOGIC;
        --o_end: out STD_LOGIC
        o_z0: out STD_LOGIC_VECTOR (7 downto 0);
        o_z1: out STD_LOGIC_VECTOR (7 downto 0);
        o_z2: out STD_LOGIC_VECTOR (7 downto 0);
        o_z3: out STD_LOGIC_VECTOR (7 downto 0);
        o_end: out STD_LOGIC

    );
end component;

signal clr: STD_LOGIC;
signal sel: STD_LOGIC;
signal flag: STD_LOGIC;
signal r0_load: STD_LOGIC;
signal r1_load: STD_LOGIC;
signal ended: STD_LOGIC;
signal o_r0: STD_LOGIC_VECTOR (15 downto 0);
--signal r2_load: STD_LOGIC;
--signal r2_sel: STD_LOGIC;
--signal o_end: STD_LOGIC;

type S is (S0, S1, S2, S3, S4, S4_1, S5, S6, S7, S8, S9);
signal cur_state, next_state  : S;

begin

    DATAPATH0: datapath port map(
        i_clk,
        i_start,
        i_rst,
        clr,
        sel,
        flag,
        i_w,
        i_mem_data,
        r0_load,
        r1_load,
        o_r0,
        o_z0,
        o_z1,
        o_z2,
        o_z3,
        ended
        --r2_load,
        --r2_sel,
        --o_end
    );

    process(i_clk, i_rst)
    begin
        if (i_rst = '1') then      
            -- quando resetto padding avviene automaticamente
            --clr <= '1'; 
            cur_state <= S0;
        elsif rising_edge(i_clk) then
            cur_state <= next_state;
        end if;
    end process;
    
    process(cur_state, i_start, ended)
    begin
    
        --o_z0 <= "00000000";
        --o_z1 <= "00000000";
        --o_z2 <= "00000000";
        --o_z3 <= "00000000";
        flag <= '0';
        o_done <= '0';
        o_mem_addr <= "0000000000000000";
        o_mem_we <= '0';
        o_mem_en <= '0';        
        clr <= '0';
        sel <= '0';
        r0_load <= '0';
        r1_load <= '0';
    
        next_state <= cur_state;
        
        case cur_state is
            when S0 =>
                if i_start = '1' then
                    sel <= '1';
                    --clr <= '1';
                
                    next_state <= S2;
                end if;
            when S2 =>
                sel <= '1';
            
                next_state <= S3;
            when S3 =>
                --if o_end = '1' then
                    -- skips counter
                    --next_state <= S4;
                --end if;
                
                r1_load <= '1';
                             
                next_state <= S5;
                if i_start = '0' then
                    r0_load <= '1';
                    next_state <= S7;
                end if;                        
            when S5 =>
                if i_start = '0' then
                    r0_load <= '1';
                    next_state <= S7;
                end if;
            --when S6 =>
            --    next_state <= S7;
            when S7 =>
                o_mem_en <= '1';
                o_mem_addr <= o_r0;
                next_state <= S8;
            when S8 =>
                flag <= '1';
                next_state <= S9;
            when S9 =>
                if ended = '1' then
                    o_done <= '1';
                    clr <= '1';
                    next_state <= S0;
                end if;                
            when others =>
            
         end case;
         
     end process;

end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity datapath is
    port ( i_clk:  in STD_LOGIC;
           i_str:  in STD_LOGIC;
           i_rst:  in STD_LOGIC;
           i_clr:  in STD_LOGIC;
           i_sel:  in STD_LOGIC;
           i_flag: in STD_LOGIC;
           i_w:    in STD_LOGIC;
           i_mem_data: in STD_LOGIC_VECTOR (7 downto 0);
           r0_load: in STD_LOGIC;
           r1_load: in STD_LOGIC;
           o_r0: out STD_LOGIC_VECTOR (15 downto 0);
           --r2_load: in STD_LOGIC;
           --r2_sel:  in STD_LOGIC;
           --o_end: out STD_LOGIC
           o_z0: out STD_LOGIC_VECTOR (7 downto 0);
           o_z1: out STD_LOGIC_VECTOR (7 downto 0);
           o_z2: out STD_LOGIC_VECTOR (7 downto 0);
           o_z3: out STD_LOGIC_VECTOR (7 downto 0);
           o_end: out STD_LOGIC
    );
end datapath;

architecture Behavioral of datapath is

signal o_sel: STD_LOGIC_VECTOR (1 downto 0);
signal o_r1: STD_LOGIC_VECTOR (1 downto 0);
signal rz0_load: STD_LOGIC;
signal rz1_load: STD_LOGIC;
signal rz2_load: STD_LOGIC;
signal rz3_load: STD_LOGIC;

signal o_rz0: STD_LOGIC_VECTOR (7 downto 0);
signal o_rz1: STD_LOGIC_VECTOR (7 downto 0);
signal o_rz2: STD_LOGIC_VECTOR (7 downto 0);
signal o_rz3: STD_LOGIC_VECTOR (7 downto 0);

signal r0_vec: STD_LOGIC_VECTOR (15 downto 0);
signal r1_vec: STD_LOGIC_VECTOR (1 downto 0);

signal show: STD_LOGIC;



begin
    process(i_clk, i_rst)
        begin
        
        --azzero componenti
        if i_rst = '1' then
            o_r0 <= "0000000000000000";
            o_r1 <= "00";
            o_rz0 <= "00000000";
            o_rz1 <= "00000000";
            o_rz2 <= "00000000";
            o_rz3 <= "00000000";
            r0_vec <= "0000000000000000";
            r1_vec <= "00";
            show <= '0';
            rz0_load <= '0';
            rz1_load <= '0';
            rz2_load <= '0';
            rz3_load <= '0';
            o_end <= '0';
        else                                        
        
            if rising_edge(i_clk) then
                
                --azzero shifter
                if i_clr = '1' then
                    r0_vec <= "0000000000000000";
                    r1_vec <= "00";
                end if;                        
                
                --campionamento su ffs
                case i_sel is
                    when '1' =>
                        r1_vec <= r1_vec (0) & (i_w and i_str);                
                    when '0' =>
                        r0_vec <= r0_vec (14 downto 0) & (i_w and i_str);      
                    when others =>    
                          
                end case;
                
                --scrittura su registri
                --indirizzo e canale
                if r0_load = '1' then
                    o_r0 <= r0_vec;
                end if;
                if r1_load = '1' then
                    o_r1 <= r1_vec;
                    o_sel <= r1_vec;         
                end if;
                --registri in uscita
                if rz0_load = '1' then
                    o_rz0 <= i_mem_data;                
                    rz0_load <= '0';
                end if;
                if rz1_load = '1' then
                    o_rz1 <= i_mem_data;
                    rz1_load <= '0';
                end if;
                if rz2_load = '1' then
                    o_rz2 <= i_mem_data;
                    rz2_load <= '0';
                end if;
                if rz3_load = '1' then
                    o_rz3 <= i_mem_data;
                    rz3_load <= '0';
                end if;
                
                --demux dato in output
                if i_flag = '1' then
                    show <= '1';
                    case o_sel is
                        when "00" =>
                            --rz0_load <= '1';
                            o_rz0 <= i_mem_data;
                        when "01" =>
                            --rz1_load <= '1';
                            o_rz1 <= i_mem_data;
                        when "10" =>
                            --rz2_load <= '1';
                            o_rz2 <= i_mem_data;
                        when "11" =>
                            --rz3_load <= '1';
                            o_rz3 <= i_mem_data;
                        when others =>    
                                              
                    end case;                                             
                 end if;
                 
                 --mostro valori in uscita, sig show dovrebbe essere simultaneo a done
                 if show = '1' then
                    o_z0 <= o_rz0;
                    o_z1 <= o_rz1;
                    o_z2 <= o_rz2;
                    o_z3 <= o_rz3;
                    show <= '0';
                    o_end <= '1';
                 else
                     o_z0 <= "00000000";
                     o_z1 <= "00000000";
                     o_z2 <= "00000000";
                     o_z3 <= "00000000";
                     o_end <= '0';
                 end if;
                 
            end if;
            
        end if;
        
    end process;  
        
end Behavioral;
