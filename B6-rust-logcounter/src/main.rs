use std::collections::HashMap;
use std::env;
use std::fs;
use std::process;

#[derive(Debug, Default, PartialEq, Eq)]
pub struct LogCounts {
    pub info: u32,
    pub warn: u32,
    pub error: u32,
}

pub fn count_log_levels(content: &str) -> LogCounts {
    let mut counts = LogCounts::default();
    for line in content.lines() {
        if line.contains("ERROR") {
            counts.error += 1;
        } else if line.contains("WARN") {
            counts.warn += 1;
        } else if line.contains("INFO") {
            counts.info += 1;
        }
    }
    counts
}

pub fn read_file(path: &str) -> Result<String, String> {
    fs::read_to_string(path).map_err(|err| format!("Failed to read file '{path}': {err}"))
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() != 2 {
        eprintln!("Usage: logcounter <log-file-path>");
        process::exit(1);
    }

    let path = &args[1];
    let content = match read_file(path) {
        Ok(text) => text,
        Err(message) => {
            eprintln!("{message}");
            process::exit(1);
        }
    };

    let counts = count_log_levels(&content);
    let output = HashMap::from([
        ("INFO", counts.info),
        ("WARN", counts.warn),
        ("ERROR", counts.error),
    ]);

    for (level, count) in output {
        println!("{level}: {count}");
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn counts_info_warn_error_lines() {
        let input = "INFO started\nWARN low memory\nERROR failed\nINFO done\n";
        let counts = count_log_levels(input);
        assert_eq!(counts, LogCounts { info: 2, warn: 1, error: 1 });
    }

    #[test]
    fn empty_file_returns_zero_counts() {
        let counts = count_log_levels("");
        assert_eq!(counts, LogCounts::default());
    }

    #[test]
    fn read_file_returns_error_for_missing_path() {
        let result = read_file("/path/does/not/exist.log");
        assert!(result.is_err());
        assert!(result.unwrap_err().contains("Failed to read file"));
    }
}
