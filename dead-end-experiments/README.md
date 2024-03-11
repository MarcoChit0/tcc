# With-Detector

- **Time:** 30 mins
- **Memory:** 60 GB
- **Threads:** 4
- **Dead-End Detection:** Reachable states
- **Heuristics:** Trie-Star (State), Delta-Nearest (Policy)

## Observation

Two test runs were conducted to assess performance variations with different `delpf` settings:

1. **First Run (`delpf = 0`):** identified dead-ends.
2. **Second Run (`delpf = 2`):** executed the AND* algorithm.

# Without-Detector

- **Time:** 30 mins
- **Memory:** 60 GB
- **Threads:** 4
- **Dead-End Detection:** None
- **Heuristics:** Trie-Star (State), Delta-Nearest (Policy)