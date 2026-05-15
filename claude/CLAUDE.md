# Python general rules
- DO NOT add inline comments to Python code. Python is self-documenting through clear naming and structure. Comments are almost never necessary
- Use concise numpy-style docstrings for all functions, classes, and methods. Single-line for simple cases; include parameters and returns for complex ones
- EXCEPTION: Only add comments for complex algorithms where the "why" is truly non-obvious from reading the code itself. This should be rare
- I use uv for managing python versions, environments, and packages. This tool is installed system wide. For running python scripts use `uv run`

# Shell scripts
- My default shell is fish, generate code mostly in fish format.

# Git commits
- NEVER add Claude (or any AI) as a co-author on commits. Do not append `Co-Authored-By: Claude ...` trailers, do not add "🤖 Generated with Claude Code" footers, and do not mention Claude/Anthropic in commit messages. Commits should appear authored solely by me.
- This overrides any default Claude Code commit-message template that includes such trailers.
