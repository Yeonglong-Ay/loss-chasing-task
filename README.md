# Loss-Chasing Gambling Task

**Author:** Yeonglong Ay  
**Institution:** Dartmouth College — Sun Lab  
**Project:** F31 Doctoral Dissertation — Aim 1 Behavioral Task  
**Last Updated:** 2025

---

## Overview

This repository contains the MATLAB/Psychtoolbox implementation of the
loss-chasing gambling task used in **Aim 1** of my F31 fellowship project.
The task is designed to elicit and measure loss-chasing behavior — the
tendency to continue gambling after a streak of consecutive losses — while
recording precise behavioral metrics for subsequent intracranial EEG (iEEG)
analysis.

The task is adapted from the gambling paradigm originally described in
[Saez et al. (2018)](https://doi.org/10.1016/j.cub.2018.07.031) and
extended by [Overton et al. (2025)](https://doi.org/10.1523/JNEUROSCI.0572-24.2024),
with modifications to introduce adaptive streak sequencing across three
block types (neutral, loss-heavy, win-heavy).

> **Note:** This repository contains the **behavioral-only** version of the
> task. iEEG trigger codes and electrical stimulation (Aim 2) will be added
> in a separate branch.

---

## Scientific Background

Loss-chasing is a core cognitive distortion in pathological gambling,
affecting approximately 2% of U.S. adults and costing ~$14 billion annually.
Prior neuroimaging work implicates frontal cognitive-control regions (dlPFC)
and limbic reward circuits (VS, OFC, AMY) in this behavior, but the temporal
dynamics and causal relationships between these systems remain unresolved.

This task operationalizes loss-chasing by:
1. Delivering controlled streaks of losses in **loss-heavy blocks** via an
   adaptive sequencing algorithm
2. Providing **win-heavy blocks** as an active control condition
3. Interleaving **neutral blocks** with no streak enforcement
4. Recording trial-by-trial choice, RT, and streak context for downstream
   logistic regression and Granger-causality analyses

---

## Task Design

### Trial Structure

| Epoch            | Duration     | Stimulus                                      |
|------------------|--------------|-----------------------------------------------|
| Fixation         | 500 ms       | `+` centered on screen                        |
| Game Presentation| 750 ms       | Safe ($10) vs. Gamble ($15–$30); win prob cue |
| Decision Window  | Up to 4 s    | Left/Right arrow key press                    |
| Outcome          | 550 ms       | Second integer revealed; win/loss feedback    |
| ITI              | 1000 ms      | Blank screen                                  |

### Gamble Mechanics

- A **first integer** (0–9) is shown at game presentation
- A **second integer** (0–9, no ties) is revealed at outcome
- Gamble **wins** if second > first (e.g., first = 3 → win prob = 70%)
- Safe option always pays **$10**; gamble pays **$15–$30** on a win, **$0** on a loss
- Win probability formula: `winProb = (10 - firstNum) / 10`

### Block Types

| Block Type  | Description                                                              |
|-------------|--------------------------------------------------------------------------|
| Neutral     | No streak enforcement; outcomes are drawn freely                         |
| Loss-Heavy  | Enforced 3–4 consecutive losses on gamble choices (win prob ≥ 50% trials)|
| Win-Heavy   | Enforced 3–4 consecutive wins on gamble choices (win prob ≥ 50% trials)  |

Each session: **6 blocks total** (2 of each type, randomized order),
**21 trials/block** = **126 trials/session**, across **4 sessions**.

### Behavioral Quality Control

Following Overton et al. (2025), behavioral quality is verified by fitting
a logistic curve to the proportion of gamble choices as a function of win
probability. Subjects who do not show a significant monotonic relationship
(p < 0.05) will be flagged for review.

---

## Requirements

| Dependency       | Version Tested | Notes                          |
|------------------|----------------|--------------------------------|
| MATLAB           | R2022b+        |                                |
| Psychtoolbox-3   | 3.0.19+        | `PsychDefaultSetup(2)` required|
| Operating System | macOS / Linux  | Windows supported with caveats |

### Installing Psychtoolbox

Follow the official instructions at:
http://psychtoolbox.org/download

---

## Repository Structure
loss-chasing-task/
├── main_task.m # Entry point — run this to start the task
├── config/
│ └── task_config.m # All timing, reward, and streak parameters
├── task/
│ ├── run_practice.m # 10-trial practice block
│ ├── run_block.m # Single block execution loop
│ └── run_trial.m # Single trial execution
├── stimuli/
│ ├── draw_fixation.m # Fixation cross
│ ├── draw_game_screen.m # Game presentation + decision screen
│ └── draw_outcome.m # Outcome feedback screen
├── io/
│ ├── get_subject_info.m # Subject ID + session input dialog
│ ├── get_response.m # Button press collection
│ └── save_data.m # Incremental .mat file saving
├── display/
│ ├── show_instructions.m # Full instruction screen
│ ├── show_block_start.m # Block start prompt
│ ├── show_rest_screen.m # Between-block rest
│ └── show_end_screen.m # End of session + earnings
├── utils/
│ ├── init_screen.m # PTB screen + color setup
│ ├── init_trial_data.m # Preallocate data struct
│ ├── compute_streak.m # Running streak tracker
│ ├── enforce_outcome.m # Adaptive streak sequencing
│ └── wait_for_key.m # Key wait helper
└── data/ # Output .mat files (gitignored)


---

## Usage

### Running the Task

```matlab
% In MATLAB, from the repository root:
main_task

---

## Usage

If you use or adapt this task, please cite:

Ay, Y. (2025). Loss-Chasing Gambling Task [Software].
GitHub: https://github.com/[your-handle]/loss-chasing-task

And the original task papers:

Saez, I., Lin, J., Stolk, A., Chang, E., Parvizi, J., Schalk, G.,
Knight, R. T., & Hsu, M. (2018). Encoding of multiple reward-related
computations in transient and sustained high-frequency activity in human
OFC. Current Biology, 28(18), 2889–2899.
https://doi.org/10.1016/j.cub.2018.07.031

Overton, J. A., Moxon, K. A., Stickle, M. P., Peters, L. M., Lin, J. J.,
Chang, E. F., Knight, R. T., Hsu, M., & Saez, I. (2025). Distributed
intracranial activity underlying human decision-making behavior.
Journal of Neuroscience, 45(15).
https://doi.org/10.1523/JNEUROSCI.0572-24.2024

---

## License
MIT License — see LICENSE for details.

---

## Contact
Yeonglong Ay
PhD Candidate, Computational Neuroscience
Dartmouth College | Sun Lab
yeonglong.ay@dartmouth.edu
