### descriptive_data.csv

* group: the group to which a player belongs, High-Risk or Low-Risk.
* id_player: the anonymous id of a player.
* age: age of a player.
* gender: gender of a player, Female or Male.
* risk_0: whether the player receives a risk level of 0 in the data, 1 = yes, 0 = no.
* risk_3: whether the player receives a risk level of 3 in the data, 1 = yes, 0 = no.
* risk_4: whether the player receives a risk level of 4 in the data, 1 = yes, 0 = no.
* risk_5: whether the player receives a risk level of 5 in the data, 1 = yes, 0 = no.
* n_session: the total number of sessions played by each player.
* n_round_total: the total number of rounds played by each player.
* n_round_mean: the mean number of rounds played per session.
* n_round_median: the median number of rounds played per session.
* bet_max: the maximum bet size across all rounds, in euro.
* bet_min: the minimum bet size across all rounds, in euro.
* bet_mean: the mean bet size across all rounds, in euro.
* bet_median: the median bet size across all rounds, in euro.
* win_prob: the probability of winning (%) across all rounds.
* win_max: the maximum amount of win on rounds when players win, in euro. Win defined as the win amount minus the stake amount.
* win_min: the minimum amount of win on rounds when players win, in euro.
* win_mean: the mean amount of win on rounds when players win, in euro.
* win_median:  the median amount of win on rounds when players win, in euro.
* loss_max: the maximum amount of loss on rounds when players lose, in euro. Loss amount equals the stake amount.
* loss_min: the minimum amount of loss on rounds when players lose, in euro.
* loss_mean: the mean amount of loss on rounds when players lose, in euro.
* loss_median: the median amount of loss on rounds when players lose, in euro.
* total_spent: the total amount of money spent (i.e., lost), in euro. A negative value indicates that players overall won money.

### bet_counts.csv

* group: the group to which a player belongs, High-Risk or Low-Risk.
* id_player: the anonymous id of a player.
* stake: the amount of money a player bets on a round, from 0.25 till 20, in euro.
* n_round: the number of rounds where a player chose a certain bet size.
* n_round_total: the total number of rounds played by each player.
* prop: the relative proportion of choosing a certain bet size for each player, from 0 (%) till 100 (%).

### stop.csv

* group: the group to which a player belongs, High-Risk or Low-Risk.
* id_player: the anonymous id of a player.
* outcome: the outcome of a round, win or loss.
* total_count: the total number of rounds with a particular outcome (win or loss).
* stop_count: the total number of rounds after which a player decided to end a session.
* stop_prob: the probability (%) of ending a session after a particular outcome. This variable is computed by dividing stop_count by total_count and then multiplied by 100.
* stop_overall: the overall probability (%) of ending a session regardless of the outcome of a round. This variable is computed by dividing the number of rounds at the end of a session by the total number of rounds (all sessions combined), and then multiplied by 100.

### stop_breaks.csv

Players might take a break without logging off. To take such breaks in play into account, we assume that whenever players took more than 10 minutes to make a move, it means that they had taken a break. A new session starts after such a break.

* group: the group to which a player belongs, High-Risk or Low-Risk.
* id_player: the anonymous id of a player.
* outcome: the outcome of a round, win or loss.
* total_count: the total number of rounds with a particular outcome (win or loss).
* stop_count: the total number of rounds after which a player decided to end a session.
* stop_prob: the probability (%) of ending a session after a particular outcome. This value is computed by dividing stop_count by total_count and then multiplied by 100.
* stop_overall: the overall probability (%) of ending a session regardless of the outcome of a round. This variable is computed by dividing the number of rounds at the end of a session by the total number of rounds (all sessions combined), and then multiplied by 100.

### stake_change.csv

* group: the group to which a player belongs, High-Risk or Low-Risk.
* id_player: the anonymous id of a player.
* prev_outcome: the outcome on the previous round, win (win amount > 0) or loss (win amount = 0).
* n_round: the total number of rounds following a win or a loss.
* n_round_change: the number of rounds where a player changed the stake.
* stake_change_prop: the proportion of rounds where players changed the stake (%).
* stake_change_size_overall: the average change in stake sizes in all rounds. A positive value indicates an increase in stake (euro).
* stake_change_level_overall: the average change in stake levels in all rounds. A positive value indicates an increase in stake level.
* stake_change_size: the average change in stake sizes when players did change the stake. In other words, rounds where players did not change the stake are excluded.
* stake_change_level: the average change in stake levels when players did change the stake. In other words, rounds where players did not change the stake are excluded.

### rt.csv

* group: the group to which a player belongs, High-Risk or Low-Risk.
* id_player: the anonymous id of a player.
* prev_outcome: the outcome on the previous trial, win (win amount > 0) or loss (win amount = 0).
* n_round: the number of rounds following a win or a loss.
* rt_mean: the mean response time (of putting in the first column) after a win or a loss, in milliseconds.
* rt_z_mean: the mean of response time z score (of putting in the first column) after a win or a loss.
