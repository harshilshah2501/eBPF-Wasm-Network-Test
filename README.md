
# eBPF + WebAssembly + Docker Network Test Project

This project combines **WebAssembly (Wasm)**, **eBPF**, and **Docker** to create a system for monitoring network activities such as ping, traceroute, and iperf. The WebAssembly module handles the user’s network test requests, while eBPF traces the relevant system calls to gather metrics, such as average round-trip time (RTT), packet loss, and bandwidth. Docker provides a containerized environment for running the project.

## Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Requirements](#requirements)
- [Installation and Setup](#installation-and-setup)
- [Running the Project](#running-the-project)
- [Network Test Types](#network-test-types)
- [Expected Output](#expected-output)
- [License](#license)

---

## Features

- **WebAssembly**: Handles user requests for network tests (ping, traceroute, iperf).
- **eBPF**: Monitors network traffic and collects statistics (e.g., RTT, hops, bandwidth).
- **Docker**: Isolates the application for portability and ensures the same behavior across environments.
- **UI Ready**: The project is designed to integrate with a simple user interface (UI) that allows users to select network tests and view results in real-time.

## Architecture
This project is divided into three main components:

1. **User Interface (Optional)**: Allows users to select the type of network test they want to run (ping, traceroute, iperf).
2. **WebAssembly Module**: Delegates the user's network test request to the underlying system and returns the results. Compiled from Rust code into a WebAssembly binary.
3. **eBPF**: Runs in the background and monitors network activities such as RTT, hops, bandwidth, etc., using kernel-level probes.

## Project Structure
```
eBPF-Wasm-Network-Test/
├── Dockerfile  # Dockerfile to build the environment
├── README.md # Project documentation
├── .gitignore  # Git ignored files
├── src/  # Rust WebAssembly source code
│ ├── main.rs # Rust code for WebAssembly
├── wasm/ # Compiled WebAssembly files
│ └── network_test.wasm # Final WebAssembly binary
├── monitor_network.py  # eBPF monitoring Python script
└── scripts/  # Additional helper scripts
└── run_tests.sh  # Bash script to run network tests
```

## Requirements
To run this project, you need:

- **Docker**: Install Docker [here](https://docs.docker.com/get-docker/).
- **Rust**: Install Rust [here](https://www.rust-lang.org/tools/install) to build the WebAssembly module.
- **Python 3**: Required to run the eBPF monitoring script.
- **Linux headers**: Ensure that your system has the necessary kernel headers for eBPF.

## Installation and Setup
Follow these steps to set up the project:

1. **Clone the Repository**:
   Clone the GitHub repository to your local machine.
 ```bash
   git clone https://github.com/yourusername/eBPF-Wasm-Network-Test.git
   cd eBPF-Wasm-Network-Test
 ```

 2. **Install Rust and Build the WebAssembly Module**:
Install Rust and build the WebAssembly module using the wasm32-wasi target.
```bash
rustup target add wasm32-wasi
cargo build --target wasm32-wasi --release
```
The compiled Wasm file will be located in target/wasm32-wasi/release/network_test.wasm.

3. **Build the Docker Image**:
Build the Docker container that will run the WebAssembly and eBPF components.
```bash
sudo docker build -t wasm-ebpf-container .
```
4. **Run the Docker Container**:
Run the Docker container with privileged access (required for eBPF).
```bash
sudo docker run --privileged --rm wasm-ebpf-container
```

**Running the Project**
Once the Docker container is up and running, you can trigger various network tests (ping, traceroute, iperf) via the WebAssembly module, and the eBPF program will collect statistics on the network activity.

1. **Choose a Network Test**:

You can use a script or integrate the WebAssembly module with a UI to choose between different network tests (ping, traceroute, iperf).

If using a script, you can create a simple bash script (scripts/run_tests.sh) to run each test:
```bash
#!/bin/bash

echo "Running Ping Test"
curl https://example.com
```
**Network Test Types**

The following network tests can be run via the WebAssembly module:

1.  **Ping**:
•  Measures the **Round-Trip Time (RTT)** between your system and a destination host.
•  eBPF collects the RTT for each packet and reports the average time.

2. **Traceroute**:
•  Determines the number of **hops** between your system and a destination host.
•  eBPF monitors each hop’s RTT and displays the path taken.

3. **Iperf**:
•  Measures the **bandwidth** between two systems.
•  eBPF tracks the bandwidth usage during the iperf test.

**Expected Output**
When running the project, you should see the following types of output:
1. **WebAssembly**: Outputs the test result header, e.g., Running Ping Test....
2. **eBPF**: Prints detailed information about the network test, such as:
•  **Ping**: Packet caught! Average RTT: 20ms
•  **Traceroute**: Hop 1: 10ms, Hop 2: 15ms, Hop 3: 30ms
•  **Iperf**: Bandwidth: 100Mbps

**Example Output:**
```bash
Hello from WebAssembly!
Tracing network packets... Press Ctrl+C to stop.
Packet caught! Average RTT: 20ms
Packet caught! Average RTT: 22ms
```
**License**
This project is licensed under the **MIT License**. Feel free to use it as you like, but please provide proper attribution.

**Additional Notes**
•  This project currently uses **Python’s BCC (BPF Compiler Collection)** to monitor network tests via eBPF. You can extend the project by integrating additional network tools or metrics.
•  Future improvements could include adding a UI layer for ease of use and visualizing the network test results.