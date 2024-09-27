from bcc import BPF

# eBPF program: trace network packets
bpf_program = """
int trace_packet(struct __sk_buff *skb) {
    bpf_trace_printk("Packet caught!\\n");
    return 0;
}
"""

# Load and attach eBPF program
b = BPF(text=bpf_program)
b.attach_kprobe(event="tcp_sendmsg", fn_name="trace_packet")

# Print trace logs
print("Tracing network packets... Press Ctrl+C to stop.")
b.trace_print()
