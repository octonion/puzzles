# Poisson Elo-based Soccer Rating System Explanation

This document explains a rating system for soccer teams based on modeling goal scoring as a Poisson process, inspired by Elo rating systems. Each team is assigned an offensive strength ($O$) and a defensive strength ($D$).

## 1. Model Definition

* **Offensive Strength ($O$)**: A numerical rating representing a team's attacking capability.
* **Defensive Strength ($D$)**: A numerical rating representing a team's defensive capability. Note that in this specific model, a *higher* $D$ value appears to indicate a *weaker* defense.

## 2. Initialization

* All teams start with the same initial ratings:
    * Initial Offensive Strength: $O_{initial} = \log(1.4) \approx 0.336$
    * Initial Defensive Strength: $D_{initial} = 0$
* The choice of $\log(1.4)$ implies that against a team with baseline defense ($D=0$), a team is initially expected to score $\exp(\log(1.4) - 0) = 1.4$ goals.

## 3. Expected Goals Calculation

* When Team H (Home) plays Team A (Away), the expected number of goals scored by each team ($\mu_H$ and $\mu_A$) is calculated based on their respective strengths:
    * $\mu_H = \exp(O_H - D_A)$
    * $\mu_A = \exp(O_A - D_H)$
* This means a team's expected goals increase with their own offensive strength and decrease with the opponent's defensive strength (remembering higher $D$ implies weaker defense).

## 4. Rating Update Rule

* After a match with actual scores $S_H$ for the home team and $S_A$ for the away team, the ratings are updated iteratively.
* This implementation uses a specific non-linear update rule involving a weight $w$ (set to $1/20.0$ in the code).
* **For Home Team Goals ($S_H$)**:
    1.  Calculate the expected goals $\mu_H = \exp(O_H - D_A)$.
    2.  Calculate the adjustment term $d_H$:
        $d_H = \frac{1}{2} \log\left( w \frac{S_H}{\mu_H} + (1-w) \right)$
        *\*Note: The code calculates this as $d_H = (-\log(\mu_H) + \log(w S_H + (1-w)\mu_H))/2$, which is mathematically equivalent.\**
    3.  Update the ratings:
        $O_H' = O_H + d_H$
        $D_A' = D_A - d_H$
* **For Away Team Goals ($S_A$)**:
    1.  Calculate the expected goals $\mu_A = \exp(O_A - D_H)$.
    2.  Calculate the adjustment term $d_A$:
        $d_A = \frac{1}{2} \log\left( w \frac{S_A}{\mu_A} + (1-w) \right)$
        *\*Note: The code calculates this as $d_A = (-\log(\mu_A) + \log(w S_A + (1-w)\mu_A))/2$, which is mathematically equivalent.\**
    3.  Update the ratings:
        $O_A' = O_A + d_A$
        $D_H' = D_H - d_A$
* The update adjusts the offensive rating of the scoring team and the defensive rating of the conceding team based on how the actual score compares to the expectation, modulated by the weight $w$.

## 5. Final Ranking

* After processing all games, a final strength score ($S_{team}$) is calculated for each team:
    $S_{team} = \exp(O_{team} + D_{team})$
* Teams are then ranked based on this score in descending order.
* **Interpretation**: This metric represents $\exp(\text{Offensive Strength} + \text{Defensive Strength})$. As a higher $D$ seems to imply weaker defense, the meaning of this sum as an overall quality metric is specific to this model and may differ from standard approaches.

## 6. How to Run the Program (`poisson_elo.py`)

1.  **Save the Code**: Save the Python code provided below as `poisson_elo.py`.
2.  **Install Dependencies**: You need Python 3 and the `pandas` library. If you don't have pandas, install it using pip:
    ```bash
    pip install pandas
    ```
3.  **Prepare Data File**:
    * The script expects a CSV file named `E0.csv` (or whatever you set `input_csv_file` to inside the script) to be present in the *same directory* as `poisson_elo.py`.
    * This CSV file must contain historical match data with at least the following columns:
        * `HomeTeam`: Name of the home team.
        * `AwayTeam`: Name of the away team.
        * `FTHG`: Full Time Home Goals (integer).
        * `FTAG`: Full Time Away Goals (integer).
    * You can often find suitable data files from sports statistics websites (like football-data.co.uk, which was referenced in the original code comments).
4.  **Run from Terminal**: Open a terminal or command prompt, navigate to the directory where you saved `poisson_elo.py` and `E0.csv`, and run the script using:
    ```bash
    python poisson_elo.py
    ```
5.  **Output**: The script will print the initialization parameters, indicate when processing starts and finishes, and finally output the ranked list of teams with their final score, offensive strength (O), and defensive strength (D).
