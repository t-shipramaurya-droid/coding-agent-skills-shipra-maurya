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

#[cfg(test)]
mod tests {
    use super::*;

    fn sample(amount: f64, user: &str, merchant: &str) -> ScoreRequest {
        ScoreRequest {
            transaction_id: "tx-test".into(),
            amount,
            currency: "USD".into(),
            user_id: user.into(),
            merchant_id: merchant.into(),
        }
    }

    #[test]
    fn low_risk_small_amount() {
        let result = score_transaction(&sample(100.0, "user-1", "M100"));
        assert_eq!(result.risk_level, "LOW");
        assert!(result.risk_score < 40);
    }

    #[test]
    fn high_risk_blocked_merchant_and_amount() {
        let result = score_transaction(&sample(1500.0, "user-1", "M999"));
        assert_eq!(result.risk_level, "HIGH");
        assert_eq!(result.risk_score, 100);
    }

    #[test]
    fn medium_risk_flagged_user() {
        let result = score_transaction(&sample(600.0, "bad-user", "M100"));
        assert_eq!(result.risk_level, "MEDIUM");
    }

    #[test]
    fn batch_matches_individual_scores() {
        let requests = vec![
            sample(100.0, "user-1", "M100"),
            sample(1500.0, "user-1", "M999"),
        ];
        let batch = score_transactions(&requests);
        assert_eq!(batch.len(), 2);
        assert_eq!(batch[0].risk_level, score_transaction(&requests[0]).risk_level);
        assert_eq!(batch[1].risk_score, score_transaction(&requests[1]).risk_score);
    }
}
