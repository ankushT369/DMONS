use std::collections::HashMap;

// Whole redis INFO struct to hold all the information about the redis instance this data will be
// sent to server for further processing like UI updates.
#[derive(Debug)]
pub struct RedisInfo {
    pub server: ServerInfo,
    pub clients: ClientsInfo,
    pub memory: MemoryInfo,
    pub persistence: PersistenceInfo,
    pub stats: StatsInfo,
    pub replication: ReplicationInfo,
    pub cpu: CpuInfo,
    pub modules: Vec<String>,
    pub cluster: ClusterInfo,
    pub keyspace: HashMap<String, DbInfo>,
}

#[derive(Debug)]
pub struct ServerInfo {
    pub redis_version: String,
    pub redis_git_sha1: String,
    pub redis_git_dirty: u8,
    pub redis_build_id: String,
    pub redis_mode: String,
    pub os: String,
    pub arch_bits: u8,
    pub multiplexing_api: String,
    pub atomicvar_api: String,
    pub gcc_version: String,
    pub process_id: u32,
    pub run_id: String,
    pub tcp_port: u16,
    pub uptime_in_seconds: u64,
    pub uptime_in_days: u64,
    pub hz: u32,
    pub configured_hz: u32,
    pub lru_clock: u64,
    pub executable: String,
    pub config_file: String,
    pub io_threads_active: u8,
}

#[derive(Debug)]
pub struct ClientsInfo {
    pub connected_clients: u32,
    pub client_recent_max_input_buffer: usize,
    pub client_recent_max_output_buffer: usize,
    pub blocked_clients: u32,
    pub tracking_clients: u32,
    pub clients_in_timeout_table: u32,
}

#[derive(Debug)]
pub struct MemoryInfo {
    pub used_memory: u64,
    pub used_memory_human: String,
    pub used_memory_rss: u64,
    pub used_memory_rss_human: String,
    pub used_memory_peak: u64,
    pub used_memory_peak_human: String,
    pub used_memory_peak_perc: f64,
    pub used_memory_overhead: u64,
    pub used_memory_startup: u64,
    pub used_memory_dataset: u64,
    pub used_memory_dataset_perc: f64,
    pub allocator_allocated: u64,
    pub allocator_active: u64,
    pub allocator_resident: u64,
    pub total_system_memory: u64,
    pub total_system_memory_human: String,
    pub used_memory_lua: u64,
    pub used_memory_lua_human: String,
    pub used_memory_scripts: u64,
    pub used_memory_scripts_human: String,
    pub number_of_cached_scripts: u32,
    pub maxmemory: u64,
    pub maxmemory_human: String,
    pub maxmemory_policy: String,
    pub allocator_frag_ratio: f64,
    pub allocator_frag_bytes: u64,
    pub allocator_rss_ratio: f64,
    pub allocator_rss_bytes: u64,
    pub rss_overhead_ratio: f64,
    pub rss_overhead_bytes: u64,
    pub mem_fragmentation_ratio: f64,
    pub mem_fragmentation_bytes: u64,
    pub mem_not_counted_for_evict: u64,
    pub mem_replication_backlog: u64,
    pub mem_clients_slaves: u64,
    pub mem_clients_normal: u64,
    pub mem_aof_buffer: u64,
    pub mem_allocator: String,
    pub active_defrag_running: u8,
    pub lazyfree_pending_objects: u64,
}

#[derive(Debug)]
pub struct PersistenceInfo {
    pub loading: u8,
    pub rdb_changes_since_last_save: u64,
    pub rdb_bgsave_in_progress: u8,
    pub rdb_last_save_time: u64,
    pub rdb_last_bgsave_status: String,
    pub rdb_last_bgsave_time_sec: i64,
    pub rdb_current_bgsave_time_sec: i64,
    pub rdb_last_cow_size: u64,
    pub aof_enabled: u8,
    pub aof_rewrite_in_progress: u8,
    pub aof_rewrite_scheduled: u8,
    pub aof_last_rewrite_time_sec: i64,
    pub aof_current_rewrite_time_sec: i64,
    pub aof_last_bgrewrite_status: String,
    pub aof_last_write_status: String,
    pub aof_last_cow_size: u64,
    pub module_fork_in_progress: u8,
    pub module_fork_last_cow_size: u64,
}

#[derive(Debug)]
pub struct StatsInfo {
    pub total_connections_received: u64,
    pub total_commands_processed: u64,
    pub instantaneous_ops_per_sec: u64,
    pub total_net_input_bytes: u64,
    pub total_net_output_bytes: u64,
    pub instantaneous_input_kbps: f64,
    pub instantaneous_output_kbps: f64,
    pub rejected_connections: u64,
    pub sync_full: u64,
    pub sync_partial_ok: u64,
    pub sync_partial_err: u64,
    pub expired_keys: u64,
    pub expired_stale_perc: f64,
    pub expired_time_cap_reached_count: u64,
    pub expire_cycle_cpu_milliseconds: u64,
    pub evicted_keys: u64,
    pub keyspace_hits: u64,
    pub keyspace_misses: u64,
    pub pubsub_channels: u64,
    pub pubsub_patterns: u64,
    pub latest_fork_usec: u64,
    pub migrate_cached_sockets: u64,
    pub slave_expires_tracked_keys: u64,
    pub active_defrag_hits: u64,
    pub active_defrag_misses: u64,
    pub active_defrag_key_hits: u64,
    pub active_defrag_key_misses: u64,
    pub tracking_total_keys: u64,
    pub tracking_total_items: u64,
    pub tracking_total_prefixes: u64,
    pub unexpected_error_replies: u64,
    pub total_reads_processed: u64,
    pub total_writes_processed: u64,
    pub io_threaded_reads_processed: u64,
    pub io_threaded_writes_processed: u64,
}

#[derive(Debug)]
pub struct ReplicationInfo {
    pub role: String,
    pub connected_slaves: u32,
    pub master_replid: String,
    pub master_replid2: String,
    pub master_repl_offset: i64,
    pub second_repl_offset: i64,
    pub repl_backlog_active: u8,
    pub repl_backlog_size: u64,
    pub repl_backlog_first_byte_offset: u64,
    pub repl_backlog_histlen: u64,
}

#[derive(Debug)]
pub struct CpuInfo {
    pub used_cpu_sys: f64,
    pub used_cpu_user: f64,
    pub used_cpu_sys_children: f64,
    pub used_cpu_user_children: f64,
}

#[derive(Debug)]
pub struct ClusterInfo {
    pub cluster_enabled: u8,
}

#[derive(Debug)]
pub struct DbInfo {
    pub keys: u64,
    pub expires: u64,
    pub avg_ttl: u64,
}

