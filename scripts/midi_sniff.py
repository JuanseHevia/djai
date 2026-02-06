#!/usr/bin/env python3
import sys
import time

try:
    import mido
except ImportError:
    print("Missing mido. Install with:")
    print("  python3 -m pip install mido python-rtmidi")
    sys.exit(1)

def list_ports():
    ports = mido.get_input_names()
    if not ports:
        print("No MIDI input ports found.")
        sys.exit(1)
    print("Available MIDI input ports:")
    for i, name in enumerate(ports):
        print(f"  [{i}] {name}")
    return ports

def main():
    ports = list_ports()
    idx = 0
    if len(sys.argv) > 1:
        try:
            idx = int(sys.argv[1])
        except ValueError:
            print("Usage: midi_sniff.py [port_index]")
            sys.exit(1)

    port_name = ports[idx]
    print(f"\nListening on: {port_name}")
    print("Press Ctrl+C to stop.\n")

    with mido.open_input(port_name) as port:
        for msg in port:
            raw = msg.bytes()
            hex_bytes = " ".join(f"{b:02X}" for b in raw)
            print(f"{hex_bytes}  |  {msg}")

if __name__ == "__main__":
    main()