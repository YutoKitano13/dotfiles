# Guidelines

This document defines the project's rules, objectives, and progress management methods. Please proceed with the project according to the following content.

## Top-Level Rules

- While you must **think exclusively in English**, you are required to **respond in Japanese**.
- To understand how to use a library, **always use the Context7 MCP** to retrieve the latest information.
- When exploring the codebase, **actively use subagents** (Task tool with subagent_type=Explore) to gather context efficiently.

## Plan Mode Rules

- In plan mode, you **MUST include the expected code diffs (changes)** in your plan.
  - This allows the user to review the proposed code changes before implementation.
  - Show the specific file paths and the before/after code blocks for each modification.

## Documentation Rules

- When writing specification or design documents (e.g. `*.md` files for specs, designs, ADRs), **keep them concise**.
  - Long walls of text discourage reading. Prefer short sentences, bullet points, and tables over prose.
  - Write only what the reader needs to make a decision or implement the feature. Omit background that is obvious from the code or the repository.
  - If a section grows beyond a screen, split it or cut it.
