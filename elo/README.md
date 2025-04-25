# Poisson Elo-based Soccer Rating System Explanation

This document explains a rating system for soccer teams based on modeling goal scoring as a Poisson process, inspired by Elo rating systems. Each team is assigned an offensive strength ($O$) and a defensive strength ($D$). The Python script `poisson_elo.py` implements a specific version of this concept.

## 1. Model Definition

* **Offensive Strength ($O$)**: A numerical rating representing a team's attacking capability.
* **Defensive Strength ($D$)**: A numerical rating representing a team's defensive capability. In the model where $\mu_H = \exp(O_H - D_A)$, a *higher* $D$ value indicates a *weaker* defense (as it reduces the opponent's $O$ value in the exponent).

## 2. Initialization

* All teams start with the same initial ratings (as per `poisson_elo.py`):
    * Initial Offensive Strength: $O_{initial} = \log(1.4) \approx 0.336$
    * Initial Defensive Strength: $D_{initial} = 0$
* The choice of $\log(1.4)$ implies that against a team with baseline defense ($D=0$), a team is initially expected to score $\exp(\log(1.4) - 0) = 1.4$ goals.

## 3. Expected Goals Calculation

* When Team H (Home) plays Team A (Away), the expected number of goals scored by each team ($\mu_H$ and $\mu_A$) is calculated based on their respective strengths:
    * $\mu_H = \exp(O_H - D_A)$
    * $\mu_A = \exp(O_A - D_H)$
* This means a team's expected goals increase with their own offensive strength and decrease with the opponent's defensive strength.
* **Poisson Assumption**: It is assumed that the actual goals scored ($S_H, S_A$) follow Poisson distributions with these expected values as their means:
    * $S_H \sim \text{Poisson}(\mu_H)$
    * $S_A \sim \text{Poisson}(\mu_A)$

## 4. Rating Update Rule (As Implemented in `poisson_elo.py`)

* After a match with actual scores $S_H$ for the home team and $S_A$ for the away team, the ratings in the provided script `poisson_elo.py` are updated iteratively.
* This implementation uses a specific **non-linear** update rule involving a weight $w$ (set to $1/20.0$ in the code).
* **For Home Team Goals ($S_H$)**:
    1. Calculate $\mu_H = \exp(O_H - D_A)$.
    2. Calculate the adjustment term $d_H$:
       $d_H = \frac{1}{2} \left( -\log(\mu_H) + \log(w S_H + (1-w)\mu_H) \right)$
       Which is equivalent to: $d_H = \frac{1}{2} \log\left( w \frac{S_H}{\mu_H} + (1-w) \right)$
    3. Update the ratings:
       $O_H' = O_H + d_H$
       $D_A' = D_A - d_H$
* **For Away Team Goals ($S_A$)**:
    1. Calculate $\mu_A = \exp(O_A - D_H)$.
    2. Calculate the adjustment term $d_A$:
       $d_A = \frac{1}{2} \left( -\log(\mu_A) + \log(w S_A + (1-w)\mu_A) \right)$
       Which is equivalent to: $d_A = \frac{1}{2} \log\left( w \frac{S_A}{\mu_A} + (1-w) \right)$
    3. Update the ratings:
       $O_A' = O_A + d_A$
       $D_H' = D_H - d_A$
* The update adjusts the offensive rating of the scoring team and the defensive rating of the conceding team based on how the actual score compares to the expectation, modulated non-linearly by the weight $w$.

## 5. Derivation of Alternative (Linear) Update Rules

An alternative approach is to use an update rule analogous to standard Elo, where the change is linearly proportional to the prediction error. This rule is *not* implemented in the provided `poisson_elo.py` script but can be derived in two ways:

### 5.1 Simple Analogy to Elo

* **General Elo Principle:** $\Delta \text{Rating} = K \times (\text{Actual Score} - \text{Expected Score})$, where $K$ is a learning rate.
* **Application to Poisson:**
    * Actual Score = $S$ (goals scored).
    * For a Poisson distribution, the Expected Score is its mean parameter $\mu$.
    * Prediction Error = $S - \mu$.
* **Updates:** Applying this principle to the parameters involved in predicting $S_H$:
    * $\Delta O_H = K (S_H - \mu_H)$ (Offense increases if $S_H > \mu_H$)
    * $\Delta D_A = K (S_H - \mu_H)$ (Defense *weakens* (D increases) if $S_H > \mu_H$)
* Similarly for $S_A$:
    * $\Delta O_A = K (S_A - \mu_A)$
    * $\Delta D_H = K (S_A - \mu_A)$
* **Resulting Rule:**
    * $O_H' = O_H + K (S_H - \mu_H)$
    * $D_A' = D_A + K (S_H - \mu_H)$
    * $O_A' = O_A + K (S_A - \mu_A)$
    * $D_H' = D_H + K (S_A - \mu_A)$

### 5.2 Derivation via Maximum Likelihood (Gradient Ascent)

This provides a more formal justification based on the Poisson assumption ($S \sim \text{Poisson}(\mu)$ where $\mu = \exp(O-D)$). We aim to maximize the log-likelihood of observing the scores by adjusting the parameters $O$ and $D$.

* **Log-Likelihood (for $S_H$):** Let $\theta_H = O_H - D_A$. Then $\mu_H = e^{\theta_H}$.
    $L_H = \log P(S_H | \mu_H) = -\mu_H + S_H \log \mu_H - \log(S_H!) = -e^{\theta_H} + S_H \theta_H - \log(S_H!)$
* **Gradient Calculation:** We find the gradient of $L_H$ w.r.t $O_H$ and $D_A$ using the chain rule ($\frac{\partial L_H}{\partial \text{param}} = \frac{\partial L_H}{\partial \theta_H} \frac{\partial \theta_H}{\partial \text{param}}$):
    * $\frac{\partial L_H}{\partial \theta_H} = S_H - e^{\theta_H} = S_H - \mu_H$
    * $\frac{\partial \theta_H}{\partial O_H} = 1$
    * $\frac{\partial \theta_H}{\partial D_A} = -1$
    * $\implies \frac{\partial L_H}{\partial O_H} = (S_H - \mu_H) \cdot 1 = S_H - \mu_H$
    * $\implies \frac{\partial L_H}{\partial D_A} = (S_H - \mu_H) \cdot (-1) = \mu_H - S_H$
* **Gradient Ascent Update:** $\text{Parameter}' = \text{Parameter} + K \cdot \text{Gradient}$
    * $O_H' = O_H + K \frac{\partial L_H}{\partial O_H} = O_H + K (S_H - \mu_H)$
    * $D_A' = D_A + K \frac{\partial L_H}{\partial D_A} = D_A + K (\mu_H - S_H) = D_A - K (S_H - \mu_H)$
* **Updates based on $S_A$ follow similarly.**
* **Resulting Rule:**
    * $O_H' = O_H + K (S_H - \mu_H)$
    * $D_A' = D_A - K (S_H - \mu_H)$
    * $O_A' = O_A + K (S_A - \mu_A)$
    * $D_H' = D_H - K (S_A - \mu_A)$

* **Note on $D$ update:** Both derivations yield updates proportional to $(S-\mu)$. The maximum likelihood derivation naturally includes the negative sign for the $D$ update relative to the $O$ update, aligning with the sign convention used (though not the functional form) in the `poisson_elo.py` script. The simple analogy derivation can be interpreted either way depending on whether $D$ is viewed as strength or weakness.

## 6. Final Ranking (As Implemented in `poisson_elo.py`)

* After processing all games, the script calculates a final strength score ($S_{team}$) for each team:
    $S_{team} = \exp(O_{team} + D_{team})$
* Teams are then ranked based on this score in descending order.
* **Interpretation**: This metric represents $\exp(\text{Offensive Strength} + \text{Defensive Strength})$. As a higher $D$ seems to imply weaker defense, the meaning of this sum as an overall quality metric is specific to this model.

## 7. How to Run the Program (`poisson_elo.py`)

1.  **Save the Code**: Save the Python code provided in previous turns as `poisson_elo.py`.
2.  **Install Dependencies**: You need Python 3 and the `pandas` library. If you don't have pandas, install it using pip:
    ```bash
    pip install pandas
    ```
3.  **Prepare Data File**:
    * The script expects a CSV file named `E0.csv` (or whatever you set `input_csv_file` to inside the script) to be present in the *same directory* as `poisson_elo.py`.
    * This CSV file must contain historical match data with at least the following columns: `HomeTeam`, `AwayTeam`, `FTHG` (Full Time Home Goals), `FTAG` (Full Time Away Goals).
    * You can often find suitable data files from sports statistics websites (like football-data.co.uk, which was referenced in the original code comments).
4.  **Run from Terminal**: Open a terminal or command prompt, navigate to the directory where you saved `poisson_elo.py` and `E0.csv`, and run the script using:
    ```bash
    python poisson_elo.py
    ```
5.  **Output**: The script will print the initialization parameters, indicate when processing starts and finishes, and finally output the ranked list of teams with their final score, offensive strength (O), and defensive strength (D).
