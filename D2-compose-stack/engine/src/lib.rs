use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize, PartialEq)]
pub struct ScoreRequest {
    pub transaction_id: String,
    pub amount: f64,
    pub currency: String,
    pub user_id: String,
    pub merchant_id: String,
}

#[derive(Debug, Serialize, PartialEq)]
pub struct ScoreResponse {
    pub transaction_id: String,
    pub risk_score: u8,
    pub risk_level: String,
    pub reasons: Vec<String>,
}

pub fn score_transaction(req: &ScoreRequest) -> ScoreResponse {
    let mut score: u32 = 10;
    let mut reasons: Vec<String> = Vec::new();

    if req.amount <= 0.0 {
        reasons.push("invalid_amount".into());
        return ScoreResponse {
            transaction_id: req.transaction_id.clone(),
            risk_score: 100,
            risk_level: "HIGH".into(),
            reasons,
        };
    }

    if req.amount > 1000.0 {
        score += 45;
        reasons.push("high_amount_over_1000".into());
    } else if req.amount > 500.0 {
        score += 25;
        reasons.push("amount_over_500".into());
    } else {
        reasons.push("amount_under_500".into());
    }

    if req.merchant_id == "M999" {
        score += 50;
        reasons.push("blocked_merchant".into());
    }

    if req.user_id.starts_with("bad-") {
        score += 30;
        reasons.push("flagged_user_prefix".into());
    }

    if score > 100 {
        score = 100;
    }

    let risk_level = if score >= 70 {
        "HIGH"
    } else if score >= 40 {
        "MEDIUM"
    } else {
        "LOW"
    };

    ScoreResponse {
        transaction_id: req.transaction_id.clone(),
        risk_score: score as u8,
        risk_level: risk_level.into(),
        reasons,
    }
}

pub fn score_transactions(requests: &[ScoreRequest]) -> Vec<ScoreResponse> {
    requests.iter().map(score_transaction).collect()
}
