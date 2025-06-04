	component TimeHoldOver_Qsys is
		port (
			clk_clk                                  : in    std_logic                      := 'X';             -- clk
			epcs_flash_controller_dclk               : out   std_logic;                                         -- dclk
			epcs_flash_controller_sce                : out   std_logic;                                         -- sce
			epcs_flash_controller_sdo                : out   std_logic;                                         -- sdo
			epcs_flash_controller_data0              : in    std_logic                      := 'X';             -- data0
			on_chip_rst_and_pps_switch_export        : out   std_logic_vector(8 downto 0);                      -- export
			io_update_ctrl_export                    : out   std_logic;                                         -- export
			ocxo_lock_export                         : in    std_logic                      := 'X';             -- export
			pps_interrupt_export                     : in    std_logic                      := 'X';             -- export
			reset_reset_n                            : in    std_logic                      := 'X';             -- reset_n
			sdram_controller_addr                    : out   std_logic_vector(11 downto 0);                     -- addr
			sdram_controller_ba                      : out   std_logic_vector(1 downto 0);                      -- ba
			sdram_controller_cas_n                   : out   std_logic;                                         -- cas_n
			sdram_controller_cke                     : out   std_logic;                                         -- cke
			sdram_controller_cs_n                    : out   std_logic;                                         -- cs_n
			sdram_controller_dq                      : inout std_logic_vector(15 downto 0)  := (others => 'X'); -- dq
			sdram_controller_dqm                     : out   std_logic_vector(1 downto 0);                      -- dqm
			sdram_controller_ras_n                   : out   std_logic;                                         -- ras_n
			sdram_controller_we_n                    : out   std_logic;                                         -- we_n
			timer_ecc_fault_itr_export               : in    std_logic                      := 'X';             -- export
			timer_interface_coe_sec_cnt_set_data_out : out   std_logic_vector(192 downto 0);                    -- coe_sec_cnt_set_data_out
			timer_interface_coe_sec_cnt_get_data_in  : in    std_logic_vector(191 downto 0) := (others => 'X'); -- coe_sec_cnt_get_data_in
			timer_interface_coe_ns_cnt_set_data_out  : out   std_logic_vector(96 downto 0);                     -- coe_ns_cnt_set_data_out
			timer_interface_coe_ns_cnt_get_data_in   : in    std_logic_vector(95 downto 0)  := (others => 'X'); -- coe_ns_cnt_get_data_in
			timer_interface_coe_ctrl_cnt_set_out     : out   std_logic_vector(24 downto 0);                     -- coe_ctrl_cnt_set_out
			timer_interface_coe_ctrl_cnt_get_in      : in    std_logic_vector(23 downto 0)  := (others => 'X'); -- coe_ctrl_cnt_get_in
			timer_interface_coe_err_cnt_in           : in    std_logic_vector(23 downto 0)  := (others => 'X'); -- coe_err_cnt_in
			timer_interface_coe_utc_time_in          : in    std_logic_vector(55 downto 0)  := (others => 'X'); -- coe_utc_time_in
			timer_interface_coe_time_zone_set_out    : out   std_logic_vector(8 downto 0);                      -- coe_time_zone_set_out
			timer_interface_coe_time_zone_get_in     : in    std_logic_vector(7 downto 0)   := (others => 'X'); -- coe_time_zone_get_in
			timer_interface_coe_leap_cnt_set_out     : out   std_logic_vector(16 downto 0);                     -- coe_leap_cnt_set_out
			timer_interface_coe_leap_cnt_get_in      : in    std_logic_vector(15 downto 0)  := (others => 'X'); -- coe_leap_cnt_get_in
			timer_interface_coe_leap_occur_set_out   : out   std_logic_vector(64 downto 0);                     -- coe_leap_occur_set_out
			timer_interface_coe_leap_occur_get_in    : in    std_logic_vector(63 downto 0)  := (others => 'X'); -- coe_leap_occur_get_in
			timer_interface_coe_dst_ingress_set_out  : out   std_logic_vector(64 downto 0);                     -- coe_dst_ingress_set_out
			timer_interface_coe_dst_ingress_get_in   : in    std_logic_vector(63 downto 0)  := (others => 'X'); -- coe_dst_ingress_get_in
			timer_interface_coe_dst_engress_set_out  : out   std_logic_vector(64 downto 0);                     -- coe_dst_engress_set_out
			timer_interface_coe_dst_engress_get_in   : in    std_logic_vector(63 downto 0)  := (others => 'X'); -- coe_dst_engress_get_in
			timer_interface_coe_leap_direct_get_in   : in    std_logic_vector(7 downto 0)   := (others => 'X'); -- coe_leap_direct_get_in
			timer_interface_coe_leap_direct_set_out  : out   std_logic_vector(8 downto 0);                      -- coe_leap_direct_set_out
			timer_interface_coe_io_update_in         : in    std_logic                      := 'X';             -- coe_io_update_in
			timer_interface_coe_time_quality_get_in  : in    std_logic_vector(7 downto 0)   := (others => 'X'); -- coe_time_quality_get_in
			timer_interface_coe_time_quality_set_out : out   std_logic_vector(8 downto 0);                      -- coe_time_quality_set_out
			uart_0_external_connection_rxd           : in    std_logic                      := 'X';             -- rxd
			uart_0_external_connection_txd           : out   std_logic;                                         -- txd
			uart_1_external_connection_rxd           : in    std_logic                      := 'X';             -- rxd
			uart_1_external_connection_txd           : out   std_logic;                                         -- txd
			uart_2_external_connection_rxd           : in    std_logic                      := 'X';             -- rxd
			uart_2_external_connection_txd           : out   std_logic;                                         -- txd
			uart_3_external_connection_rxd           : in    std_logic                      := 'X';             -- rxd
			uart_3_external_connection_txd           : out   std_logic                                          -- txd
		);
	end component TimeHoldOver_Qsys;

	u0 : component TimeHoldOver_Qsys
		port map (
			clk_clk                                  => CONNECTED_TO_clk_clk,                                  --                        clk.clk
			epcs_flash_controller_dclk               => CONNECTED_TO_epcs_flash_controller_dclk,               --      epcs_flash_controller.dclk
			epcs_flash_controller_sce                => CONNECTED_TO_epcs_flash_controller_sce,                --                           .sce
			epcs_flash_controller_sdo                => CONNECTED_TO_epcs_flash_controller_sdo,                --                           .sdo
			epcs_flash_controller_data0              => CONNECTED_TO_epcs_flash_controller_data0,              --                           .data0
			on_chip_rst_and_pps_switch_export        => CONNECTED_TO_on_chip_rst_and_pps_switch_export,        -- on_chip_rst_and_pps_switch.export
			io_update_ctrl_export                    => CONNECTED_TO_io_update_ctrl_export,                    --             io_update_ctrl.export
			ocxo_lock_export                         => CONNECTED_TO_ocxo_lock_export,                         --                  ocxo_lock.export
			pps_interrupt_export                     => CONNECTED_TO_pps_interrupt_export,                     --              pps_interrupt.export
			reset_reset_n                            => CONNECTED_TO_reset_reset_n,                            --                      reset.reset_n
			sdram_controller_addr                    => CONNECTED_TO_sdram_controller_addr,                    --           sdram_controller.addr
			sdram_controller_ba                      => CONNECTED_TO_sdram_controller_ba,                      --                           .ba
			sdram_controller_cas_n                   => CONNECTED_TO_sdram_controller_cas_n,                   --                           .cas_n
			sdram_controller_cke                     => CONNECTED_TO_sdram_controller_cke,                     --                           .cke
			sdram_controller_cs_n                    => CONNECTED_TO_sdram_controller_cs_n,                    --                           .cs_n
			sdram_controller_dq                      => CONNECTED_TO_sdram_controller_dq,                      --                           .dq
			sdram_controller_dqm                     => CONNECTED_TO_sdram_controller_dqm,                     --                           .dqm
			sdram_controller_ras_n                   => CONNECTED_TO_sdram_controller_ras_n,                   --                           .ras_n
			sdram_controller_we_n                    => CONNECTED_TO_sdram_controller_we_n,                    --                           .we_n
			timer_ecc_fault_itr_export               => CONNECTED_TO_timer_ecc_fault_itr_export,               --        timer_ecc_fault_itr.export
			timer_interface_coe_sec_cnt_set_data_out => CONNECTED_TO_timer_interface_coe_sec_cnt_set_data_out, --            timer_interface.coe_sec_cnt_set_data_out
			timer_interface_coe_sec_cnt_get_data_in  => CONNECTED_TO_timer_interface_coe_sec_cnt_get_data_in,  --                           .coe_sec_cnt_get_data_in
			timer_interface_coe_ns_cnt_set_data_out  => CONNECTED_TO_timer_interface_coe_ns_cnt_set_data_out,  --                           .coe_ns_cnt_set_data_out
			timer_interface_coe_ns_cnt_get_data_in   => CONNECTED_TO_timer_interface_coe_ns_cnt_get_data_in,   --                           .coe_ns_cnt_get_data_in
			timer_interface_coe_ctrl_cnt_set_out     => CONNECTED_TO_timer_interface_coe_ctrl_cnt_set_out,     --                           .coe_ctrl_cnt_set_out
			timer_interface_coe_ctrl_cnt_get_in      => CONNECTED_TO_timer_interface_coe_ctrl_cnt_get_in,      --                           .coe_ctrl_cnt_get_in
			timer_interface_coe_err_cnt_in           => CONNECTED_TO_timer_interface_coe_err_cnt_in,           --                           .coe_err_cnt_in
			timer_interface_coe_utc_time_in          => CONNECTED_TO_timer_interface_coe_utc_time_in,          --                           .coe_utc_time_in
			timer_interface_coe_time_zone_set_out    => CONNECTED_TO_timer_interface_coe_time_zone_set_out,    --                           .coe_time_zone_set_out
			timer_interface_coe_time_zone_get_in     => CONNECTED_TO_timer_interface_coe_time_zone_get_in,     --                           .coe_time_zone_get_in
			timer_interface_coe_leap_cnt_set_out     => CONNECTED_TO_timer_interface_coe_leap_cnt_set_out,     --                           .coe_leap_cnt_set_out
			timer_interface_coe_leap_cnt_get_in      => CONNECTED_TO_timer_interface_coe_leap_cnt_get_in,      --                           .coe_leap_cnt_get_in
			timer_interface_coe_leap_occur_set_out   => CONNECTED_TO_timer_interface_coe_leap_occur_set_out,   --                           .coe_leap_occur_set_out
			timer_interface_coe_leap_occur_get_in    => CONNECTED_TO_timer_interface_coe_leap_occur_get_in,    --                           .coe_leap_occur_get_in
			timer_interface_coe_dst_ingress_set_out  => CONNECTED_TO_timer_interface_coe_dst_ingress_set_out,  --                           .coe_dst_ingress_set_out
			timer_interface_coe_dst_ingress_get_in   => CONNECTED_TO_timer_interface_coe_dst_ingress_get_in,   --                           .coe_dst_ingress_get_in
			timer_interface_coe_dst_engress_set_out  => CONNECTED_TO_timer_interface_coe_dst_engress_set_out,  --                           .coe_dst_engress_set_out
			timer_interface_coe_dst_engress_get_in   => CONNECTED_TO_timer_interface_coe_dst_engress_get_in,   --                           .coe_dst_engress_get_in
			timer_interface_coe_leap_direct_get_in   => CONNECTED_TO_timer_interface_coe_leap_direct_get_in,   --                           .coe_leap_direct_get_in
			timer_interface_coe_leap_direct_set_out  => CONNECTED_TO_timer_interface_coe_leap_direct_set_out,  --                           .coe_leap_direct_set_out
			timer_interface_coe_io_update_in         => CONNECTED_TO_timer_interface_coe_io_update_in,         --                           .coe_io_update_in
			timer_interface_coe_time_quality_get_in  => CONNECTED_TO_timer_interface_coe_time_quality_get_in,  --                           .coe_time_quality_get_in
			timer_interface_coe_time_quality_set_out => CONNECTED_TO_timer_interface_coe_time_quality_set_out, --                           .coe_time_quality_set_out
			uart_0_external_connection_rxd           => CONNECTED_TO_uart_0_external_connection_rxd,           -- uart_0_external_connection.rxd
			uart_0_external_connection_txd           => CONNECTED_TO_uart_0_external_connection_txd,           --                           .txd
			uart_1_external_connection_rxd           => CONNECTED_TO_uart_1_external_connection_rxd,           -- uart_1_external_connection.rxd
			uart_1_external_connection_txd           => CONNECTED_TO_uart_1_external_connection_txd,           --                           .txd
			uart_2_external_connection_rxd           => CONNECTED_TO_uart_2_external_connection_rxd,           -- uart_2_external_connection.rxd
			uart_2_external_connection_txd           => CONNECTED_TO_uart_2_external_connection_txd,           --                           .txd
			uart_3_external_connection_rxd           => CONNECTED_TO_uart_3_external_connection_rxd,           -- uart_3_external_connection.rxd
			uart_3_external_connection_txd           => CONNECTED_TO_uart_3_external_connection_txd            --                           .txd
		);

