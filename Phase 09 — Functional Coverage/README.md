
# Phase 9 — Functional Coverage ✅

## Overview
This phase explores SystemVerilog functional coverage, which helps measure whether important values, scenarios, and combinations have been exercised during verification. It covers covergroups, coverpoints, bins, cross coverage, transition coverage, and coverage reporting.

## Topics Covered

### 1. Covergroups and Bins

| No. | Topic | Concepts Covered |
|---|---|---|
| SV-096 | Covergroup ✅ | Creation, sampling |
| SV-097 | Coverpoint ✅ | Signal/value coverage |
| SV-098 | Implicit Bins ✅ | Automatic bins |
| SV-099 | Explicit Bins ✅ | User-defined bins |
| SV-100 | Range/Array Bins ✅ | `{}`, `[]`, `bins[]` |
| SV-101 | Cross Coverage ✅ | Cross coverpoints |
| SV-102 | Cross Bins ✅ | Specific combinations |

### 2. Coverage Controls and Transitions

| No. | Topic | Concepts Covered |
|---|---|---|
| SV-103 | `ignore_bins` ✅ | Exclude irrelevant scenarios |
| SV-104 | `illegal_bins` ✅ | Detect illegal scenarios |
| SV-105 | `iff` ✅ | Conditional coverage |
| SV-106 | Transition Bins ✅ | Value/state transitions |
| SV-107 | Wildcard Bins ✅ | Wildcard coverage |
| SV-108 | Default Bins ✅ | Default coverage bucket |

### 3. Coverage Configuration and Reporting

| No. | Topic | Concepts Covered |
|---|---|---|
| SV-109 | Coverage Options ✅ | `option.goal`, `at_least`, `name`, `per_instance` |
| SV-110 | Coverage Reports ✅ | Coverage collection, reporting |

## Key Learning Areas

- **Coverage modeling:** Define covergroups and coverpoints to track verification scenarios.
- **Bin creation:** Use implicit, explicit, range, array, and wildcard bins to classify sampled values.
- **Cross coverage:** Measure combinations of values across multiple coverpoints.
- **Coverage filtering:** Apply `ignore_bins`, `illegal_bins`, and `iff` to control what is sampled or classified.
- **Transition tracking:** Monitor sequences of values or states using transition bins.
- **Coverage analysis:** Configure coverage options, collect results, and interpret coverage reports.

## Practical Work

Each topic is practiced through SystemVerilog examples and simulation to observe sampling behavior, bin hits, cross coverage, and coverage results.

## Learning Outcomes

After completing this phase, you should be able to:
- Create covergroups and coverpoints.
- Define bins for values, ranges, combinations, and transitions.
- Apply coverage controls to relevant and illegal scenarios.
- Configure coverage options and collect results.
- Interpret coverage reports to identify verification gaps.

## Tools
- **Language:** SystemVerilog
- **Simulator:** AMD Vivado
- **Practice:** Runnable code examples, simulation outputs, and GitHub learning notes
