use fraud_score_engine::{ScoreRequest, score_transaction, score_transactions};
use std::io::{self, Read};

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).expect("read stdin");
    let trimmed = input.trim();

    if trimmed.starts_with('[') {
        let requests: Vec<ScoreRequest> =
            serde_json::from_str(trimmed).expect("valid json array input");
        let responses = score_transactions(&requests);
        println!("{}", serde_json::to_string(&responses).expect("serialize"));
    } else {
        let req: ScoreRequest = serde_json::from_str(trimmed).expect("valid json input");
        let response = score_transaction(&req);
        println!("{}", serde_json::to_string(&response).expect("serialize"));
    }
}
