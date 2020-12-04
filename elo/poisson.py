import pandas as pd
from math import log,exp

#epl = pd.read_csv("http://www.football-data.co.uk/mmz4281/1718/E0.csv")
epl = pd.read_csv("E0.csv")
epl = epl[['HomeTeam','AwayTeam','FTHG','FTAG']]
epl = epl.rename(columns={'FTHG': 'HomeGoals', 'FTAG': 'AwayGoals'})

teams = set(epl['HomeTeam'])

# Every team starts O = log(1.4), D = 0

O = {}
D = {}
for team in teams:
    O[team] = log(1.4)
    D[team] = 0

w = 1/20.0
for game in epl.iterrows():
    
    H = game[1]['HomeTeam']
    A = game[1]['AwayTeam']
    
    S_H = game[1]['HomeGoals']
    S_A = game[1]['AwayGoals']

    l_H = O[H]-D[A]
    E_H = exp(l_H)

    l_A = O[A]-D[H]
    E_A = exp(l_A)

    d = (-l_H+log(w*S_H + (1-w)*E_H))/2
    O[H] = O[H]+d
    D[A] = D[A]-d

    d = (-l_A+log(w*S_A + (1-w)*E_A))/2
    O[A] = O[A]+d
    D[H] = D[H]-d

S = {}
for team in teams:
    S[team] = exp(O[team]+D[team])

ranked = sorted(S.items(), reverse=True, key=lambda x: x[1])

for team in ranked:
    print(team[0], '%.3f' % team[1])
