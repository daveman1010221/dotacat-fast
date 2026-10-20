use std::f64::consts::PI;
use std::io::{BufWriter, Write, stdout};

fn rainbow(freq: f64, i: f64) -> (u8, u8, u8) {
    let red = ((freq * i).sin() * 127.0 + 128.0) as u8;
    let green = ((freq * i + 2.0 * PI / 3.0).sin() * 127.0 + 128.0) as u8;
    let blue = ((freq * i + 4.0 * PI / 3.0).sin() * 127.0 + 128.0) as u8;
    (red, green, blue)
}

pub fn print_rainbow(
    line: &str,
    freq: f64,
    seed: f64,
    spread: f64,
    invert: bool,
) -> std::io::Result<()> {
    let mut out = BufWriter::new(stdout());
    let bytes = line.as_bytes();
    let mut i = 0;
    let mut index = 0;

    while i < bytes.len() {
        if bytes[i] == 0x1B {
            // Start of ANSI escape sequence
            // Bytes, not chars: a byte of the sequence is copied as it is.
            let mut esc_seq: Vec<u8> = Vec::with_capacity(32);
            esc_seq.push(0x1B);

            i += 1;
            if i < bytes.len() && bytes[i] == b'[' {
                esc_seq.push(b'[');
                i += 1;

                // Read until final byte
                while i < bytes.len() {
                    let b = bytes[i];
                    esc_seq.push(b);
                    i += 1;
                    if (b as char).is_ascii_alphabetic() || (b'@'..=b'~').contains(&b) {
                        break;
                    }
                }
            } else {
                // Non-CSI escape (e.g., ESC P, ESC ]), copy until ~
                while i < bytes.len() {
                    let b = bytes[i];
                    esc_seq.push(b);
                    i += 1;
                    if (b as char).is_ascii_graphic() || b == b'\x1B' {
                        break;
                    }
                }
            }

            out.write_all(&esc_seq)?;
        } else {
            // A character, which in UTF-8 may be several bytes: taking each byte as a char would print `·` (C2 B7) as `Â·`.
            // An escape sequence ends on an ASCII byte, so `i` is on a character boundary here.
            let ch = line[i..].chars().next().unwrap_or('\u{FFFD}');
            let (r, g, b) = rainbow(freq, seed + index as f64 / spread);

            if invert {
                write!(out, "\x1B[48;2;{r};{g};{b}m{ch}\x1B[49m")?;
            } else {
                write!(out, "\x1B[38;2;{r};{g};{b}m{ch}\x1B[39m")?;
            }

            index += 1;
            i += ch.len_utf8();
        }
    }
    out.flush()?;
    Ok(())
}
