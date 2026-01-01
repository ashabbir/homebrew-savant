class SavantContext < Formula
  include Language::Python::Virtualenv

  desc "Context MCP server with PostgreSQL-based code indexer"
  homepage "https://github.com/ashabbir/context"
  url "https://github.com/ashabbir/homebrew-savant/raw/main/savant-context-1.0.0.tar.gz"
  sha256 "c06e329e3c0d571692026a23bdbe2e2cb652f12eac8e68d022b89228ef9e4791"
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

  # Vendored pgvector source to build against PostgreSQL@15
  resource "pgvector" do
    url "https://github.com/pgvector/pgvector/archive/refs/tags/v0.8.1.tar.gz"
    sha256 "a9094dfb85ccdde3cbb295f1086d4c71a20db1d26bf1d6c39f07a7d164033eb4"
  end

  # Python runtime dependencies (vendored wheels/sdists; macOS arm64, Python 3.10)
  resource "numpy" do
    url "https://files.pythonhosted.org/packages/20/f7/b24208eba89f9d1b58c1668bc6c8c4fd472b20c45573cb767f59d49fb0f6/numpy-1.26.4-cp310-cp310-macosx_11_0_arm64.whl"
    sha256 "2e4ee3380d6de9c9ec04745830fd9e2eccb3e6cf790d39d7b98ffd19b0dd754a"
  end

  resource "torch" do
    url "https://files.pythonhosted.org/packages/dc/fb/1333ba666bbd53846638dd75a7a1d4eaf964aff1c482fc046e2311a1b499/torch-2.4.1-cp310-none-macosx_11_0_arm64.whl"
    sha256 "d36a8ef100f5bff3e9c3cea934b9e0d7ea277cb8210c7152d34a9a6c5830eadd"
  end

  resource "transformers" do
    url "https://files.pythonhosted.org/packages/6a/6b/2f416568b3c4c91c96e5a365d164f8a4a4a88030aa8ab4644181fdadce97/transformers-4.57.3-py3-none-any.whl"
    sha256 "c77d353a4851b1880191603d36acb313411d3577f6e2897814f333841f7003f4"
  end

  resource "tokenizers" do
    url "https://files.pythonhosted.org/packages/1c/58/2aa8c874d02b974990e89ff95826a4852a8b2a273c7d1b4411cdd45a4565/tokenizers-0.22.1-cp39-abi3-macosx_11_0_arm64.whl"
    sha256 "8d4e484f7b0827021ac5f9f71d4794aaef62b979ab7608593da22b1d2e3c4edc"
  end

  resource "safetensors" do
    url "https://files.pythonhosted.org/packages/e8/00/374c0c068e30cd31f1e1b46b4b5738168ec79e7689ca82ee93ddfea05109/safetensors-0.7.0-cp38-abi3-macosx_11_0_arm64.whl"
    sha256 "94fd4858284736bb67a897a41608b5b0c2496c9bdb3bf2af1fa3409127f20d57"
  end

  resource "huggingface_hub" do
    url "https://pypi.io/packages/source/h/huggingface_hub/huggingface_hub-0.13.4.tar.gz"
    sha256 "db83d9c2f76aed8cf49893ffadd6be24e82074da2f64b1d36b8ba40eb255e115"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/e3/7f/a1a97644e39e7316d850784c642093c99df1290a460df4ede27659056834/filelock-3.20.1-py3-none-any.whl"
    sha256 "15d9e9a67306188a44baa72f569d2bfd803076269365fdea0934385da4dc361a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/20/12/38679034af332785aac8774540895e234f4d07f7545804097de4b666afd8/packaging-25.0-py3-none-any.whl"
    sha256 "29572ef2b1f17581046b3a2227d5c611fb25ec70ca1ba8554b24b0e69331a484"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/05/14/52d505b5c59ce73244f59c7a50ecf47093ce4765f116cdb98286a71eeca2/pyyaml-6.0.3-cp310-cp310-macosx_11_0_arm64.whl"
    sha256 "02ea2dfa234451bbb8772601d7b8e426c2bfa197136796224e50e35a78777956"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/39/b3/9a231475d5653e60002508f41205c61684bb2ffbf2401351ae2186897fc4/regex-2025.11.3-cp310-cp310-macosx_11_0_arm64.whl"
    sha256 "d8b4a27eebd684319bdf473d39f1d79eed36bf2cd34bd4465cdb4618d82b3d56"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/1e/db/4254e3eabe8020b458f1a747140d32277ec7a271daf1d235b70dc0b4e6e3/requests-2.32.5-py3-none-any.whl"
    sha256 "2462f94637a34fd532264295e186976db0f5d453d1cdd31473c85a6a161affb6"
  end

  resource "typing_extensions" do
    url "https://files.pythonhosted.org/packages/18/67/36e9267722cc04a6b9f15c7f3441c2363321a3ea07da7ae0c0707beb2a9c/typing_extensions-4.15.0-py3-none-any.whl"
    sha256 "f0fa19c6845758ab08074a0cfa8b7aecb71c999ca73d62883bc25cc018c4e548"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/de/86/5486b0188d08aa643e127774a99bac51ffa6cf343e3deb0583956dca5b22/fsspec-2024.12.0-py3-none-any.whl"
    sha256 "b520aed47ad9804237ff878b504267a3b0b441e97508bd6d2d8774e3db85cee2"
  end

  resource "hf_xet" do
    url "https://files.pythonhosted.org/packages/7f/8c/c5becfa53234299bc2210ba314eaaae36c2875e0045809b82e40a9544f0c/hf_xet-1.2.0-cp37-abi3-macosx_11_0_arm64.whl"
    sha256 "27df617a076420d8845bea087f59303da8be17ed7ec0cd7ee3b9b9f579dff0e4"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/a2/09/77d55d46fd61b4a135c444fc97158ef34a095e5681d0a6c10b75bf356191/sympy-1.14.0-py3-none-any.whl"
    sha256 "e091cc3e99d2141a0ba2847328f5479b05d94a6635cb96148ccb3f34671bd8f5"
  end

  resource "sentencepiece" do
    url "https://files.pythonhosted.org/packages/fc/ef/3751555d67daf9003384978f169d31c775cb5c7baf28633caaf1eb2b2b4d/sentencepiece-0.2.1-cp310-cp310-macosx_11_0_arm64.whl"
    sha256 "60937c959e6f44159fdd9f56fbdd302501f96114a5ba436829496d5f32d8de3f"
  end

  # Use ST 2.2.2 with compatible huggingface_hub to avoid deprecated APIs
  resource "sentence-transformers" do
    url "https://files.pythonhosted.org/packages/20/9c/f07bd70d128fdb107bc02a0c702b9058b4fe147d0ba67b5a0f4c3cf15a54/sentence-transformers-2.2.2.tar.gz"
    sha256 "dbc60163b27de21076c9a30d24b5b7b6fa05141d68cf2553fa9a77bf79a29136"
  end

  def install
    require "uri"
    # Create virtualenv and install the package itself
    venv = virtualenv_create(libexec, "python3.10")
    # Install vendored Python dependencies from cached downloads (allow wheels)
    python = Formula["python@3.10"].opt_bin/"python3.10"
    # Only Python wheels/sdists should be installed via pip.
    # Exclude the vendored embedding model and non-Python resources like pgvector.
    py_resources = resources.reject { |r| ["embedding-model-stsb-distilbert-base", "pgvector"].include?(r.name) }
    py_resources.each do |r|
      r.fetch
      # Copy to a filename without Homebrew cache prefix to satisfy pip's wheel parser
      url = URI(r.url)
      orig = File.basename(url.path)
      cp r.cached_download, orig
      system python, "-m", "pip", "--python=#{libexec/"bin/python"}", "install", "--no-deps", "--no-compile", orig
    end
    # Install the package itself
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
    (bin/"savant").write_env_script libexec/"bin/savant", env
  end

  def post_install
    # Create data directory if needed
    (var/"savant-context").mkpath

    # Build and install pgvector extension for PostgreSQL@15 so vector.so is available
    resource("pgvector").stage do
      pg_config = Formula["postgresql@15"].opt_bin/"pg_config"
      system "make", "PG_CONFIG=#{pg_config}"
      system "make", "PG_CONFIG=#{pg_config}", "install"
    end
  end

  def caveats
    <<~EOS
      Savant Context is installed. Quick tips:

      - Initialize DB:    savant-context db setup
      - Index a repo:     savant-context index repo /path/to/repo --name my-repo
      - Run MCP server:   savant-context run   (or use shortcut: savant)

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
    EOS
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
