# Filename: poisson_elo.py

import pandas as pd
from math import log, exp
import os # Import os to check for file existence

# --- Configuration ---
# Input file containing match data
# Assumes columns 'HomeTeam', 'AwayTeam', 'FTHG' (Full Time Home Goals), 'FTAG' (Full Time Away Goals)
# Defaulting to "E0.csv" as used in the original file
input_csv_file = "E0.csv"

# Initial Offensive strength value for all teams
initial_offensive_strength = log(1.4)
# Initial Defensive strength value for all teams
initial_defensive_strength = 0.0

# Weight factor used in the update rule
# Controls how much emphasis is placed on the actual score vs the prior expectation
update_weight = 1 / 20.0

# --- Data Loading and Preparation ---

# Check if the input file exists
if not os.path.exists(input_csv_file):
    print(f"Error: Input file '{input_csv_file}' not found.")
    print("Please ensure the CSV file is in the same directory as the script,")
    print("or provide the correct path.")
    # Attempt to download if the original URL is uncommented (Optional)
    # try:
    #     print("Attempting to download from football-data.co.uk...")
    #     # Original source mentioned in file
    #     epl_data = pd.read_csv("http://www.football-data.co.uk/mmz4281/1718/E0.csv")
    #     epl_data.to_csv(input_csv_file, index=False)
    #     print(f"Downloaded and saved data to '{input_csv_file}'.")
    # except Exception as e:
    #     print(f"Failed to download data: {e}")
    #     exit() # Exit if download fails or is not attempted
    exit() # Exit if local file not found

# Load the dataset
epl_data = pd.read_csv(input_csv_file)

# Select relevant columns
epl_data = epl_data[['HomeTeam', 'AwayTeam', 'FTHG', 'FTAG']]

# Rename columns for clarity (using convention from original file)
epl_data = epl_data.rename(columns={'FTHG': 'HomeGoals', 'FTAG': 'AwayGoals'})

# Get a unique set of all teams participating
# Using pd.unique preserves order roughly, set does not. set is fine here.
teams = set(epl_data['HomeTeam']).union(set(epl_data['AwayTeam']))

# --- Initialization ---

# Dictionaries to store Offensive (O) and Defensive (D) strengths for each team
offensive_strengths = {}
defensive_strengths = {}

# Initialize strengths for all teams
print("Initializing team strengths...")
for team in teams:
    offensive_strengths[team] = initial_offensive_strength
    defensive_strengths[team] = initial_defensive_strength
print(f"Initial O = {initial_offensive_strength:.3f}, Initial D = {initial_defensive_strength:.3f}")

# --- Rating Update Loop ---

print(f"Processing {len(epl_data)} games...")
# Iterate through each game row in the dataframe
for index, game in epl_data.iterrows():

    # Get team names and scores for the current game
    home_team = game['HomeTeam']
    away_team = game['AwayTeam']
    home_goals_scored = game['HomeGoals']
    away_goals_scored = game['AwayGoals']

    # --- Calculate Expected Goals ---

    # Log of expected goals for Home team based on Home Offense (O[H]) and Away Defense (D[A])
    log_expected_home_goals = offensive_strengths[home_team] - defensive_strengths[away_team]
    # Expected goals for Home team
    expected_home_goals = exp(log_expected_home_goals)

    # Log of expected goals for Away team based on Away Offense (O[A]) and Home Defense (D[H])
    log_expected_away_goals = offensive_strengths[away_team] - defensive_strengths[home_team]
    # Expected goals for Away team
    expected_away_goals = exp(log_expected_away_goals)

    # --- Calculate Rating Adjustments ---

    # Adjustment based on Home Goals (S_H vs E_H)
    # Formula used in the original code
    # d = (-l_H + log(w*S_H + (1-w)*E_H))/2
    # This is equivalent to d = 0.5 * log( (w * S_H / E_H) + (1-w) )
    # Handle potential division by zero or log(0) if expected_home_goals is very low or zero
    if expected_home_goals <= 0: expected_home_goals = 1e-6 # Add small epsilon
    if home_goals_scored < 0: home_goals_scored = 0 # Ensure goals are non-negative

    try:
        home_goal_adjustment = 0.5 * (
            -log_expected_home_goals +
            log(update_weight * home_goals_scored + (1 - update_weight) * expected_home_goals)
        )
    except ValueError:
        # Handle potential log domain error if argument is negative (shouldn't happen with w<1 and S,E>=0)
        print(f"Warning: Log domain error for Home update game {index}. Skipping adjustment.")
        home_goal_adjustment = 0


    # Adjustment based on Away Goals (S_A vs E_A)
    # Formula used in the original code
    if expected_away_goals <= 0: expected_away_goals = 1e-6 # Add small epsilon
    if away_goals_scored < 0: away_goals_scored = 0 # Ensure goals are non-negative

    try:
        away_goal_adjustment = 0.5 * (
            -log_expected_away_goals +
            log(update_weight * away_goals_scored + (1 - update_weight) * expected_away_goals)
        )
    except ValueError:
        print(f"Warning: Log domain error for Away update game {index}. Skipping adjustment.")
        away_goal_adjustment = 0

    # --- Update Strengths ---

    # Update Home Offense and Away Defense based on Home Goals
    offensive_strengths[home_team] += home_goal_adjustment
    defensive_strengths[away_team] -= home_goal_adjustment

    # Update Away Offense and Home Defense based on Away Goals
    offensive_strengths[away_team] += away_goal_adjustment
    defensive_strengths[home_team] -= away_goal_adjustment

print("Finished processing games.")

# --- Final Ranking Calculation ---

# Calculate the final strength score for each team
# S = exp(O + D) as per original code
final_strength_scores = {}
for team in teams:
    final_strength_scores[team] = exp(offensive_strengths[team] + defensive_strengths[team])

# Sort teams by the final strength score in descending order
ranked_teams = sorted(final_strength_scores.items(), reverse=True, key=lambda item: item[1])

# --- Output Results ---

print("\n--- Final Team Rankings ---")
print(f"{'Team':<20} {'Final Score':<15} {'Off Strength (O)':<20} {'Def Strength (D)':<20}")
print("-" * 75)
for team, score in ranked_teams:
    o_strength = offensive_strengths[team]
    d_strength = defensive_strengths[team]
    # Print format similar to original code
    print(f"{team:<20} {score:<15.3f} {o_strength:<20.3f} {d_strength:<20.3f}")

print("\nNote: Higher 'Final Score' indicates higher rank.")
print("      O = Offensive Strength, D = Defensive Strength (Higher D implies weaker defense in this model).")
print(f"      Final Score = exp(O + D)")
