use clap::Parser;
use rand::rngs::SmallRng;
use rand::{Rng, SeedableRng};
use std::fs::File;
use std::io::{BufRead, BufReader, stdin};
use std::time::Instant;
use std::time::{SystemTime, UNIX_EPOCH};

mod lol;

#[derive(Parser)]
#[command(
    author,
    about,
    version,
    after_help = "Examples:\n\tdotacat f - g\tOutput f's contents, then stdin, then g's contents.\n\tfortune | dotacat\tDisplay a rainbow cookie."
)]
struct CmdOpts {
    #[arg(short = 'p', long, default_value = "1.0")]
    /// Rainbow spread
    spread: f64,

    /// Rainbow frequency
    #[arg(short = 'F', long, default_value = "0.1")]
    freq: f64,

    /// Rainbow seed, 0 = random
    #[arg(short = 'S', long, default_value = "0.0")]
    seed: f64,

    /// Invert fg and bg
    #[arg(short = 'i', long)]
    invert: bool,

    #[arg(short = 't', long)]
    /// Print elapsed timing to stderr
    timing: bool,

    /// Files to concatenate(`-` for STDIN)
    files: Vec<String>,
}

fn read_line() -> Option<(String, usize)> {
    let mut input = String::new();
    match stdin().read_line(&mut input) {
        Ok(n) => Some((input, n)),
        _ => None,
    }
}

fn main() {
    let start = Instant::now();

    let opts: CmdOpts = CmdOpts::parse();

    let now = SystemTime::now().duration_since(UNIX_EPOCH).unwrap();
    let seed = now.as_secs() ^ (now.subsec_nanos() as u64); // simple mixing
    let mut rng = SmallRng::seed_from_u64(seed);

    let mut files = opts.files;
    if files.is_empty() {
        files.push("-".to_string());
    }

    let mut seed: f64 = opts.seed;
    if seed.abs() < 0.00001 {
        seed = rng.random_range(0.0..1_000_000.0)
    }

    for file_path in files {
        if file_path == "-" {
            while let Some((x, n)) = read_line() {
                if lol::print_rainbow(&x, opts.freq, seed, opts.spread, opts.invert).is_err() {
                    std::process::exit(1);
                }
                if n == 0 {
                    // EOF
                    break;
                }
                seed += 1.0;
            }
        } else {
            let file = match File::open(&file_path) {
                Ok(x) => x,
                Err(e) => {
                    eprintln!("Could not open {file_path}: {e}.");
                    continue;
                }
            };
            let buf = BufReader::new(file);
            for x in buf.lines() {
                match x {
                    Ok(x) => {
                        if lol::print_rainbow(&x, opts.freq, seed, opts.spread, opts.invert)
                            .is_err()
                        {
                            std::process::exit(1);
                        }
                        seed += 1.0;
                    }
                    Err(e) => {
                        eprintln!("Error while reading {file_path}: {e}.");
                        continue;
                    }
                }
            }
        }
    }
    if opts.timing {
        let duration = start.elapsed();
        println!();
        println!("Elapsed: {duration:.3?}");
    }
}
