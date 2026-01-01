class SavantContext < Formula
  include Language::Python::Virtualenv

  desc "Context MCP server with PostgreSQL-based code indexer"
  homepage "https://github.com/ashabbir/context"
  url "https://raw.githubusercontent.com/ashabbir/homebrew-savant/45ac9a5370528017a273da9989f221ded13f6a4d/savant-context-1.0.0.tar.gz"
  version "1.0.0"
  sha256 "7f645a4ef97f7e1337b0655136864a4a3f69afe71b98b3b1f5df10db12750846"
  license "MIT"

  depends_on "python@3.10"
  depends_on "postgresql@17"

  # Pinned HF revision for on-install download (set a commit hash)
  PINNED_HF_REPO = "sentence-transformers/stsb-distilbert-base"
  PINNED_HF_REV  = "main" # TODO: set to a specific commit hash to pin

  # Pinned model resource hosted on public GitHub Release (preferred)
  resource "embedding-model-stsb-distilbert-base" do
    url "https://github.com/ashabbir/homebrew-savant/releases/download/model-stsb-distilbert-base-v1/stsb-distilbert-base-v1.tar.gz"
    sha256 "8ad82ab7ee0a73edcf4174f0cfebe074cf1742f5e9cf8a6f69df9245a203aed3"
  end

  # Vendored pgvector source to build against PostgreSQL@17
  resource "pgvector" do
    url "https://github.com/ashabbir/homebrew-savant/releases/download/model-stsb-distilbert-base-v1/pgvector-0.8.1.tar.gz"
    sha256 "a9094dfb85ccdde3cbb295f1086d4c71a20db1d26bf1d6c39f07a7d164033eb4"
  end

  def install
    require "uri"
    # Create virtualenv and install the package itself
    venv = virtualenv_create(libexec, "python3.10")
    # Install vendored Python dependencies into the venv
    # Exclude non-Python resources (model files, pgvector source)
    resources.each do |r|
      next if ["embedding-model-stsb-distilbert-base", "pgvector"].include?(r.name)
      if r.url.to_s.end_with?(".whl")
        r.stage do
          wheel_path = Dir["*.whl"].first
          system "python3.10", "-m", "pip", "--python=#{libexec/"bin/python"}",
                 "install", "--no-deps", "--only-binary=:all:", wheel_path
        end
      else
        venv.pip_install r
      end
    end
    # Install the package itself into the venv
    venv.pip_install buildpath

    # Stage and install the pinned embedding model into pkgshare (no network fallback)
    model_target = pkgshare/"embeddings/models/stsb-distilbert-base"
    resource("embedding-model-stsb-distilbert-base").stage do
      model_target.mkpath
      model_target.install Dir["*"]
    end

    # Wrap entry points to set the model directory for offline use
    # Explicitly write wrappers to ensure they exist under bin/
    env = {
      "EMBEDDING_MODEL_DIR" => model_target.to_s,
    }
    (bin/"savant-context").write_env_script libexec/"bin/savant-context", env
  end

  def post_install
    # Create data directory if needed
    (var/"savant-context").mkpath

    # Build and install pgvector extension for PostgreSQL@17 so vector.so is available
    resource("pgvector").stage do
      pg_config = Formula["postgresql@17"].opt_bin/"pg_config"
      system "make", "PG_CONFIG=#{pg_config}"
      system "make", "PG_CONFIG=#{pg_config}", "install"
    end
  end

  def caveats
    <<~EOS
      Savant Context is installed. Quick tips:

      IMPORTANT (after install):
        1) Start PostgreSQL (choose one):
             savant-context db start
           or brew services start postgresql@17
        2) Run Homebrew postinstall for pgvector:
             brew postinstall ashabbir/savant/savant-context

      - Initialize DB:    savant-context db setup
      - Index a repo:     savant-context index repo /path/to/repo --name my-repo
      - Run MCP server:   savant-context run

      Useful tools (via MCP or CLI):
        - code_search            Semantic search across indexed code
        - memory_bank_search     Search memory bank markdown
        - repos_list             List repos with README excerpts
        - repo_status            Per-repo index status
        - memory_resources_list  List memory bank resources
        - memory_resources_read  Read a memory bank resource

      Diagnostics:
        savant-context diagnostics

      Banner shows model, Postgres version, and pgvector status.

      If pgvector install reports a permission error during post-install,
      ensure PostgreSQL is started and re-run:
        brew postinstall ashabbir/savant/savant-context
      If it still fails, build manually:
        curl -L https://github.com/ashabbir/homebrew-savant/releases/download/model-stsb-distilbert-base-v1/pgvector-0.8.1.tar.gz -o pgvector-0.8.1.tar.gz
        tar -xzf pgvector-0.8.1.tar.gz && cd pgvector-0.8.1
        make PG_CONFIG=$(brew --prefix postgresql@17)/bin/pg_config
        make PG_CONFIG=$(brew --prefix postgresql@17)/bin/pg_config install
    EOS
  end

  test do
    system "#{bin}/savant-context", "--version"
    system "#{bin}/savant-context", "--help"
  end

  service do
    run [opt_bin/"savant-context", "run"]
    keep_alive true
    environment_variables PATH: std_service_path_env
    log_path var/"log/savant-context.log"
    error_log_path var/"log/savant-context.error.log"
  end
end
