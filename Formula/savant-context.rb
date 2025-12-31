class SavantContext < Formula
  include Language::Python::Virtualenv

  desc "Context MCP server with PostgreSQL-based code indexer"
  homepage "https://github.com/ashabbir/context"
  url "https://github.com/ashabbir/homebrew-savant/raw/main/savant-context-1.0.0.tar.gz"
  sha256 "55cdf6b3a8aae4f49fc85d4cef7ff9448413f63e21646cdf54d1363a80b8634f"
  license "MIT"

  depends_on "python@3.10"
  depends_on "postgresql@15"

  # Pinned HF revision for on-install download (set a commit hash)
  PINNED_HF_REPO = "sentence-transformers/stsb-distilbert-base"
  PINNED_HF_REV  = "main" # TODO: set to a specific commit hash to pin

  # Pinned model resource hosted on public GitHub Release (preferred)
  resource "embedding-model-stsb-distilbert-base" do
    url "https://github.com/ashabbir/homebrew-savant/releases/download/model-stsb-distilbert-base-v1/stsb-distilbert-base-v1.tar.gz"
    sha256 "8ad82ab7ee0a73edcf4174f0cfebe074cf1742f5e9cf8a6f69df9245a203aed3"
  end

  def install
    # Create virtualenv and install the package itself
    venv = virtualenv_create(libexec, "python3.10")
    venv.pip_install buildpath

    # Stage and install the pinned embedding model into pkgshare (no network fallback)
    model_target = pkgshare/"embeddings/models/stsb-distilbert-base"
    resource("embedding-model-stsb-distilbert-base").stage do
      model_target.mkpath
      model_target.install Dir["*"]
    end

    # Wrap entry points to set the model directory for offline use
    env = {
      "EMBEDDING_MODEL_DIR" => model_target.to_s,
    }
    bin.env_script_all_files libexec/"bin", env
  end

  def post_install
    # Create data directory if needed
    (var/"savant-context").mkpath
  end

  test do
    system "#{bin}/savant-context", "--version"
    system "#{bin}/savant-context", "--help"
    system "#{bin}/savant", "--help"
  end

  service do
    run [opt_bin/"savant-context", "run"]
    keep_alive true
    environment_variables PATH: std_service_path_env
    log_path var/"log/savant-context.log"
    error_log_path var/"log/savant-context.error.log"
  end
end
