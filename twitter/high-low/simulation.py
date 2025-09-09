import numpy as np

def run_detailed_simulation(num_wagers=10): #, seed=1):
    """
    Runs a single, 10-wager game with detailed step-by-step output
    using the corrected analytical order statistics method.
    """
    #np.random.seed(seed)
    
    # Generate the sequence of true values for the entire game
    true_x_sequence = np.random.uniform(0, 1, num_wagers + 1)
    
    bankroll = 1.0
    
    # Initialize: The posterior for the conceptual x_0.
    # Its rank is 1 in a set of size 1.
    rank_probs = np.array([1.0])

    print("--- Starting Simulation ---")
    print(f"Initial Bankroll: ${bankroll:.4f}\n")

    # In wager i, we bet on x_i vs x_{i-1}.
    for i in range(1, num_wagers + 1):
        print(f"--- Wager {i} on x_{i} vs x_{i-1} ---")
        print(f"Bankroll before wager: ${bankroll:.4f}")

        # 1. ANALYZE POSTERIOR FOR x_{i-1}
        # The set for x_{i-1} is {x_0, ..., x_{i-1}}, which has size n=i.
        n = i
        
        print(f"Posterior for x_{i-1} (among a set of {n} values):")
        for k, prob in enumerate(rank_probs):
            print(f"  P(x_{i-1} is {k+1}-th smallest) = {prob:.3f}")

        # Calculate the posterior mean of x_{i-1}
        ranks = np.arange(1, n + 1)
        expected_values = ranks / (n + 1)
        mu_posterior = np.sum(rank_probs * expected_values)
        
        print(f"Posterior Mean E[x_{i-1}]: {mu_posterior:.4f}")

        # 2. DETERMINE THE WAGER
        p = max(mu_posterior, 1 - mu_posterior)
        call = "LOWER" if mu_posterior > 0.5 else "HIGHER"
        f = 2 * p - 1
        bet_amount = f * bankroll
        
        print("\nDecision:")
        print(f"  Guess: x_{i} will be {call} than x_{i-1}")
        print(f"  Optimal Wager (f): {f:.2%}")
        print(f"  Bet Amount: ${bet_amount:.4f}")

        # 3. OBSERVE THE OUTCOME
        true_x_prev = true_x_sequence[i-1]
        true_x_curr = true_x_sequence[i]
        outcome_is_higher = true_x_curr > true_x_prev
        win = (call == "HIGHER" and outcome_is_higher) or \
              (call == "LOWER" and not outcome_is_higher)
              
        # 4. UPDATE BANKROLL
        bankroll += bet_amount if win else -bet_amount
        
        print("\nOutcome:")
        print(f"  True Values: x_{i-1} = {true_x_prev:.4f}, x_{i} = {true_x_curr:.4f}")
        print(f"  Result: x_{i} was {'HIGHER' if outcome_is_higher else 'LOWER'}")
        print(f"  Bet Result: {'WIN' if win else 'LOSS'}")
        print(f"Bankroll after wager: ${bankroll:.4f}\n")

        # 5. BAYESIAN RANK UPDATE FOR x_i
        # The new set {x_0, ..., x_i} has size n_new = i+1.
        n_new = i + 1
        new_rank_probs = np.zeros(n_new)
        
        # Loop over the previous possible ranks (k_prev) of x_{i-1}
        for k_prev in range(1, n + 1):
            prob_k_prev = rank_probs[k_prev-1]
            if prob_k_prev == 0: continue

            if outcome_is_higher:
                # new rank (k_new) is uniform over [k_prev + 1, ..., n_new]
                num_slots = n_new - k_prev
                prob_dist = prob_k_prev / num_slots
                for k_new in range(k_prev + 1, n_new + 1):
                    new_rank_probs[k_new-1] += prob_dist
            else: # Outcome was lower
                # new rank (k_new) is uniform over [1, ..., k_prev]
                num_slots = k_prev
                prob_dist = prob_k_prev / num_slots
                for k_new in range(1, k_prev + 1):
                    new_rank_probs[k_new-1] += prob_dist
        
        rank_probs = new_rank_probs

    print("--- Simulation Complete ---")
    print(f"Final Bankroll after {num_wagers} wagers: ${bankroll:.4f}")

# --- Run the Program ---
if __name__ == "__main__":
    run_detailed_simulation(num_wagers=100) #, seed=1)
