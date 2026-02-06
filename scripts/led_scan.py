# led_scan.py
import time
import mido

outs = mido.get_output_names()
print("MIDI outputs:")
for i, name in enumerate(outs):
    print(f"  [{i}] {name}")

idx = int(input("Output index: "))
mode = (input("Mode (note/cc) [note]: ") or "note").strip().lower()
channels_raw = (input("Channels (e.g. 6 or 0,1,2 or all) [all]: ") or "all").strip().lower()
delay = float(input("Delay seconds [0.08]: ") or "0.08")

if channels_raw == "all":
    channels = list(range(16))
else:
    channels = [int(c.strip()) for c in channels_raw.split(",") if c.strip() != ""]

out = mido.open_output(outs[idx])

def send_note(ch, note, on):
    out.send(mido.Message("note_on", channel=ch, note=note, velocity=127 if on else 0))

def send_cc(ch, control, on):
    out.send(mido.Message("control_change", channel=ch, control=control, value=127 if on else 0))

for ch in channels:
    print(f"Scanning channel {ch} ({'0x%02X' % (0x90 + ch)})")
    for num in range(128):
        if mode == "cc":
            send_cc(ch, num, True)
            time.sleep(delay)
            send_cc(ch, num, False)
        else:
            send_note(ch, num, True)
            time.sleep(delay)
            send_note(ch, num, False)
        time.sleep(delay / 2)

out.close()
