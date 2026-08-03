# v0.7.2 Full Random transaction report

Automated status: **Passed in regression fixtures**. Live status: **Pending
owner validation**.

Random Car and Full Random share an operation context but have explicit action
contracts. A Full Random operation discovers one candidate, transitions through
`UNBOUND`, `CANDIDATE_DISCOVERED`, `BINDING`, and `BOUND`, and applies later
stages only to the accepted concrete target ID. A binding mismatch terminates
as `BOUND_MISMATCH`; a destroyed target terminates as `DESTROYED`.

The transaction permits one accepted replacement, bounds retries and wall-clock
time, owns every temporary it creates, performs at most one rollback, and
requires zero owned temporaries at terminal cleanup. Token-mismatched callbacks
are ignored before any world mutation. Scramble is separately tested to retain
the exact source vehicle ID with zero spawn/replace calls and zero world-count
delta.

