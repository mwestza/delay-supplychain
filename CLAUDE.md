# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Purpose

This tool delays updates from various package managers by >7 days as a cheap mitigation against supply-chain attacks (typosquatting, account takeover, malicious new versions).

## Tech Stack

- POSIX shell (`/bin/sh`) — must be portable across systems, no bashisms
- Project is in early/greenfield stage
- Main script is `run.sh`

## Development

No build system, dependencies, or tests are configured yet. Work should focus on keeping `run.sh` portable, idempotent, and non-destructive. When tooling is added, update this section.

## Shell Guidelines

- Use `#!/bin/sh` shebang, not `#!/bin/bash`
- Stick to POSIX-compatible constructs (no arrays, no `[[ ]]`, no `local` beyond simple cases, no process substitution)
- Aim for minimal external dependencies — prefer tools available on a base POSIX system
