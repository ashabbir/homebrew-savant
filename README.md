# Savant Context - Code Indexer & MCP Server

A standalone MCP (Model Context Protocol) server with PostgreSQL-based code indexer. Index your repositories and search across all your code through an MCP interface or CLI.

## Quick Start (Out‑of‑the‑Box)

```bash
# 1) Install
brew tap ashabbir/savant https://github.com/ashabbir/homebrew-savant
brew install savant-context

# 2) Start PostgreSQL (choose one)
# Option A (convenience):
savant-context db start
# Option B (Homebrew services):
brew services start postgresql@15

# 3) Run Homebrew postinstall (pgvector)
brew postinstall ashabbir/savant/savant-context

# 4) Initialize database
savant-context db setup

# 5) Index a repo and check status
savant-context index repo /path/to/repo --name my-repo
savant-context status

# 6) Run MCP server (stdio)
savant-context run
```

No extra setup required: pgvector and the ML stack ship with the formula.

**Install via Homebrew:**

```bash
brew tap ashabbir/savant https://github.com/ashabbir/homebrew-savant
brew install savant-context
```

## Overview

Savant Context lets you index your code repositories and search across all your source code using either a command-line interface or through an MCP server that integrates with Claude Desktop and other MCP-compatible applications.

### Key Features

- **Semantic Vector Search** - pgvector-powered search across indexed repositories
- **Code Indexing** - Automatically detect language, intelligently chunk content, and index efficiently
- **MCP Compatible** - Works with Claude Desktop and any MCP client for seamless integration
- **Database Management** - Dump and restore indexed data for backups and migrations
- **Simple CLI** - Intuitive commands for all operations, no complex configuration
- **Zero Configuration** - Environment variables only, no config files to manage

## Installation

### Prerequisites

- **macOS or Linux** - Runs on both platforms
- **Python 3.10+** - Required by the package
- **PostgreSQL 15+** - For the indexing database

### Installation Methods

#### Option 1: Homebrew (Recommended)

```bash
brew tap ashabbir/savant https://github.com/ashabbir/homebrew-savant
brew install savant-context
```

## Quick Start

### View Help & Banner

```bash
savant-context
```

Shows the ASCII art banner with version info.

### View Documentation

```bash
savant-context readme
```

Displays the full README documentation.

### Full Setup

#### 1. Initialize the Database

Creates the PostgreSQL database and schema automatically:

```bash
savant-context db setup
```

#### 2. Index Your First Repository

```bash
# From the repository directory
cd ~/my-project
savant-context index repo
```

Or from anywhere with a path:

```bash
savant-context index repo ~/my-project
```

Or with a custom name:

```bash
savant-context index repo ~/my-project --name my-project
```

#### 3. Check What's Indexed

```bash
savant-context status
```

Shows all repositories with file counts, chunk counts, and last indexed time.

#### 4. Start the MCP Server

```bash
savant-context run
```

This launches the server listening on stdio transport, ready for MCP clients.

## CLI Commands Reference

### Database Management

```bash
# Initialize database and schema
savant-context db setup

# Create a backup dump
savant-context db dump ./backup.dump

# Restore from a backup
savant-context db restore ./backup.dump

# Destroy all indexed data (permanent!)
savant-context db destroy
```

### Repository Management

```bash
# Index current directory
savant-context index repo

# Index specific path
savant-context index repo ./path/to/repo

# Index with custom name
savant-context index repo ./path/to/repo --name custom-name

# Show all indexed repositories with statistics
savant-context status
```

### Server

```bash
# Start MCP server on stdio transport
savant-context run

```

### Help & Documentation

```bash
# Show banner and version info
savant-context

# Display full README
savant-context readme

# Show help for any command
savant-context --help
savant-context db --help
```

## MCP Tools

Once the server is running, these tools are available to MCP clients (and via CLI under `savant-context tool <name>`):

- `code_search`: Semantic search across indexed code
  - Example (CLI): `savant-context tool code_search "def authenticate" --repo my-repo --limit 5`

- `memory_bank_search`: Semantic search within memory bank markdown
  - Example (CLI): `savant-context tool memory_bank_search "architecture" --repo my-repo`

- `repos_list`: List indexed repos with README excerpts
  - Example (CLI): `savant-context tool repos_list --filter context`

- `repo_status`: Per-repo index status (file/chunk counts)
  - Example (CLI): `savant-context tool repo_status`

- `memory_resources_list`: List memory bank resources
  - Example (CLI): `savant-context tool memory_resources_list --repo my-repo`

- `memory_resources_read`: Read a memory bank resource by URI
  - Example (CLI): `savant-context tool memory_resources_read "my-repo:memory_bank/architecture.md"`

```json
{
  "name": "repo-name"
}
```

## Configuration

Configuration uses environment variables only (no config files):

```bash
# PostgreSQL Connection
export POSTGRES_HOST=localhost                   # default: localhost
export POSTGRES_PORT=5432                       # default: 5432
export POSTGRES_DB=savant-context-standalone   # default: savant-context-standalone
export POSTGRES_USER=$USER                      # default: current user
export POSTGRES_PASSWORD=                       # optional

# Logging
export LOG_LEVEL=info                           # default: info
```

## Usage Examples

### Index Multiple Repositories

```bash
savant-context index repo ~/projects/project-a --name project-a
savant-context index repo ~/projects/project-b --name project-b
savant-context index repo ~/projects/project-c --name project-c
```

### Backup and Restore

```bash
# Backup current index
savant-context db dump ~/backups/index-$(date +%Y%m%d).dump

# Restore from backup
savant-context db restore ~/backups/index-20250115.dump
```

### Use with Claude Desktop

Configure in `~/.config/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "savant-context": {
      "command": "savant-context",
      "args": ["run"]
    }
  }
}
```

Restart Claude Desktop to connect to the MCP server.

## Database Schema

### `repos` Table

- `id` (SERIAL PRIMARY KEY) - Repository ID
- `name` (TEXT UNIQUE) - Repository name
- `path` (TEXT) - Repository file system path
- `indexed_at` (TIMESTAMP) - Last indexing time
- `created_at` (TIMESTAMP) - Creation time

### `files` Table

- `id` (SERIAL PRIMARY KEY) - File ID
- `repo_id` (INTEGER FK) - Repository ID
- `rel_path` (TEXT) - Relative path from repo root
- `language` (TEXT) - Detected programming language
- `mtime_ns` (BIGINT) - File modification time
- `indexed_at` (TIMESTAMP) - Indexing time
- `created_at` (TIMESTAMP) - Creation time

### `chunks` Table

- `id` (SERIAL PRIMARY KEY) - Chunk ID
- `file_id` (INTEGER FK) - File ID
- `chunk_index` (INTEGER) - Chunk sequence number
- `content` (TEXT) - Chunk content
- `embedding` (vector) - pgvector embedding for search
- `created_at` (TIMESTAMP) - Creation time

## Troubleshooting

### Database Connection Error

**Error:** `Error: Failed to connect to database`

**Solution:** Ensure PostgreSQL is running:

```bash
# macOS
brew services start postgresql@15

# Linux
sudo systemctl start postgresql
```

### pg_dump Not Found

**Error:** `pg_dump command not found`

**Solution:** Install PostgreSQL client tools:

```bash
# macOS
brew install postgresql@15

# Ubuntu
sudo apt-get install postgresql-client

# Fedora
sudo dnf install postgresql
```

## Architecture

```
savant-context/
├── cli.py              # Command-line interface
├── config.py           # Configuration management
├── db/
│   ├── client.py       # PostgreSQL connection
│   ├── schema.py       # Database schema
│   └── operations.py   # Dump/restore operations
├── indexer/
│   ├── walker.py       # File system traversal
│   ├── chunker.py      # Content chunking
│   └── indexer.py      # Indexing coordinator
└── mcp/
    ├── server.py       # MCP server implementation
    └── tools.py        # Tool handlers
```

## Performance Tips

1. **Large Files** - Files over 50MB are skipped automatically
2. **Incremental Indexing** - Re-indexing only processes changed files
3. **Chunk Configuration** - Adjust chunk size in `savant_context/indexer/chunker.py` if needed
4. **Search Optimization** - pgvector indexes are created automatically

## Roadmap

- [ ] Web UI for repository management
- [ ] Hybrid search (vector + metadata filters)
- [ ] Incremental indexing optimization
- [ ] Multi-language support improvements
- [ ] Export capabilities (JSON, CSV)

## License

MIT - See LICENSE file for details

## Support

- 🐛 [Report issues](https://github.com/ashabbir/context/issues)
- 📖 [Full documentation](https://github.com/ashabbir/context)
- 💬 Check this README for common questions

## Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Write tests
5. Submit a pull request
