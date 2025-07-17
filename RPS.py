# the below function is an expert rock-paper-scissors player and swaps between 3 different strategies to defeat all freeCodeCamp opponents

# the statespace
states = ["R", "P", "S"]

def player(prev_play, opponent_history=[], transition_counts = {"RR": 0, "RP": 0, "RS": 0, "PR": 0, "PP": 0, "PS": 0, "SR": 0, "SP": 0, "SS": 0}, my_history = [], win_history = [], strategy_state={"s1": True, "s2": False, "s3": False}, counter = [0], last_switch = [0]):

    # recording opponent history
    opponent_history.append(prev_play)

    # updating win history to trigger strategy changes
    if my_history:
        if my_history[-1] == "R" and prev_play == "P":
            win_history.append("L")
        if my_history[-1] == "R" and prev_play == "S":
            win_history.append("W")
        if my_history[-1] == "S" and prev_play == "P":
            win_history.append("W")
        if my_history[-1] == "S" and prev_play == "R":
            win_history.append("L")
        if my_history[-1] == "P" and prev_play == "S":
            win_history.append("L")
        if my_history[-1] == "P" and prev_play == "R":
            win_history.append("W")
    
    # checks to see if we're winning every 100 iterations and if not, changes strategy
    if len(win_history) - last_switch[0] >= 100:
        recent = win_history[-100:]
        wins = recent.count("W")
        win_proportion = wins / len(recent)
        # cycle through the strategies if one is failing
        if win_proportion < 0.6:
            if strategy_state["s1"]:
                strategy_state["s1"] = False
                strategy_state["s2"] = True
                strategy_state["s3"] = False
            elif strategy_state["s2"]:
                strategy_state["s1"] = False
                strategy_state["s2"] = False
                strategy_state["s3"] = True
            elif strategy_state["s3"]:
                strategy_state["s1"] = True
                strategy_state["s2"] = False
                strategy_state["s3"] = False
            last_switch[0] = len(win_history)

    # STRATEGY 1 QUINCY KILLER
    if strategy_state["s1"]:
        counter[0] += 1
        choices = ["P", "P", "S", "S", "R"]
        guess = choices[counter[0] % len(choices)]

    # STRATEGY 2 KRIS KILLER
    if len(my_history) > 1 and strategy_state["s2"]:
        if my_history[-1] == "R":
            guess = "S"
        elif my_history[-1] == "P":
            guess = "R"
        elif my_history[-1] == "S":
            guess = "P"

    # STRATEGY 3 MRUGESH KILLER
    # updating transition counts for transition probability estimation
    transname = ""
    if len(opponent_history) > 2:
        transname = opponent_history[-2] + prev_play
        if transname in transition_counts:
            transition_counts[transname] += 1

    # choosing move based on previous play and transition probabilities
    if sum(transition_counts.values()) > 20 and strategy_state["s3"]:
        if prev_play =="R":
            # calculating transition probabilities
            R_total = transition_counts["RS"] + transition_counts["RR"] + transition_counts["RP"]
            RS_prob = transition_counts["RS"] / R_total
            RR_prob = transition_counts["RR"] / R_total
            RP_prob = transition_counts["RP"] / R_total
            # choosing move to beat highest transition probability
            if RS_prob > max(RR_prob, RP_prob):
                guess = "R"
            elif RR_prob > max(RP_prob, RS_prob):
                guess = "P"
            else:
                guess = "S"

        if prev_play =="S":
            S_total = transition_counts["SR"] + transition_counts["SS"] + transition_counts["SP"]
            SR_prob = transition_counts["SR"] / S_total
            SS_prob = transition_counts["SS"] / S_total
            SP_prob = transition_counts["SP"] / S_total
            if SR_prob > max(SS_prob, SP_prob):
                guess = "P"
            elif SS_prob > max(SP_prob, SR_prob):
                guess = "R"
            else:
                guess = "S"

        if prev_play =="P":
            P_total = transition_counts["PR"] + transition_counts["PP"] + transition_counts["PS"]
            PR_prob = transition_counts["PR"] / P_total
            PP_prob = transition_counts["PP"] / P_total
            PS_prob = transition_counts["PS"] / P_total
            if PR_prob > max(PP_prob, PS_prob):
                guess = "P"
            elif PP_prob > max(PS_prob, PR_prob):
                guess = "S"
            else:
                guess = "R"

    # keeping record of my previous play
    my_history.append(guess)

    # returning best move
    return guess
