# Use Ubuntu as the base image
FROM ubuntu:22.04

# Install required tools and dependencies
RUN apt-get update && apt-get install -y \
    curl python3 python3-pip bpfcc-tools libbpf-dev clang llvm iproute2 \
    linux-headers-$(uname -r)

# Install Wasmtime for ARM64
RUN curl -L https://github.com/bytecodealliance/wasmtime/releases/download/v10.0.0/wasmtime-v10.0.0-aarch64-linux.tar.xz \
    | tar -xJ && mv wasmtime-v10.0.0-aarch64-linux/wasmtime /usr/local/bin/wasmtime

# Install Python dependencies for eBPF
RUN pip3 install bcc

# Set working directory
WORKDIR /app

# Copy the WebAssembly module
COPY target/wasm32-wasi/release/hello_wasm.wasm /app/hello_wasm.wasm

# Copy the Python eBPF script
COPY monitor_network.py /app/monitor_network.py

# Run the WebAssembly module and start eBPF monitoring
CMD ["sh", "-c", "wasmtime /app/hello_wasm.wasm & python3 /app/monitor_network.py"]
