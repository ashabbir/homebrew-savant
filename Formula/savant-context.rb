class SavantContext < Formula
  include Language::Python::Virtualenv

  desc "Context MCP server with PostgreSQL-based code indexer"
  homepage "https://github.com/ashabbir/context"
  url "https://github.com/ashabbir/homebrew-savant/raw/main/savant-context-1.0.0.tar.gz"
  sha256 "fac180feedcd9f15fe5caec163a69c482ef61e60c9402e9d2e07f1b18c77962c"
  license "MIT"

  depends_on "python@3.10"
  # Use Homebrew's current PostgreSQL to avoid version mismatch with pgvector bottles
  depends_on "postgresql"
  depends_on "pgvector"

  # Pinned HF revision for on-install download (set a commit hash)
  PINNED_HF_REPO = "sentence-transformers/stsb-distilbert-base"
  PINNED_HF_REV  = "main" # TODO: set to a specific commit hash to pin

  # Pinned model resource hosted on public GitHub Release (preferred)
  resource "embedding-model-stsb-distilbert-base" do
    url "https://github.com/ashabbir/homebrew-savant/releases/download/model-stsb-distilbert-base-v1/stsb-distilbert-base-v1.tar.gz"
    sha256 "8ad82ab7ee0a73edcf4174f0cfebe074cf1742f5e9cf8a6f69df9245a203aed3"
  end

  # Note: pgvector is provided by Homebrew dependency above (no manual build needed)

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
    url "https://files.pythonhosted.org/packages/cb/bd/1a875e0d592d447cbc02805fd3fe0f497714d6a2583f59d14fa9ebad96eb/huggingface_hub-0.36.0-py3-none-any.whl"
    sha256 "7bcc9ad17d5b3f07b57c78e79d527102d08313caa278a641993acddcb894548d"
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

  # Prefer modern sentence-transformers to avoid deprecated huggingface_hub APIs
  resource "sentence-transformers" do
    url "https://files.pythonhosted.org/packages/2e/1b/7ae98a096eebf72e484d4e7b9b1a3d9fbd3d4b8fd17a0d6d9ab5e53a4109/sentence_transformers-5.2.0-py3-none-any.whl"
    sha256 "d3c637fef68d4a00a85cc9ab8d01d8d2dce5b9da569e3ba0b491c34832367a16"
  end

  # Supplemental deps used by sentence-transformers
  resource "nltk" do
    url "https://files.pythonhosted.org/packages/02/6e/550a9e30b48eaf8657cf4ee143046617070c3aabca4aa0f879210b1cd5b1/nltk-3.9.1-py3-none-any.whl"
    sha256 "00bbcd28f8f6a80f6aa11705f015d4dcd4465e6a191dbb4815c631a8dc89eafe"
  end
  resource "scikit-learn" do
    url "https://files.pythonhosted.org/packages/55/6f/a2b3a58444bf6c3fdc542da842f54bc4bea08d7b67d5bf61d7ed0f3050ff/scikit_learn-1.7.2-cp310-cp310-macosx_12_0_arm64.whl"
    sha256 "2ecbe9d6ac8d1111b23a9afa51a05ea7c3d92fe05453677643652d861274e886"
  end
  resource "scipy" do
    url "https://files.pythonhosted.org/packages/67/d4/26a1999a83bd173b2efa34a75bdf38cbc77df1abd70a0b9863ba31b56cf6/scipy-1.15.3-cp310-cp310-macosx_14_0_arm64.whl"
    sha256 "7aa9233b7c2ccdf8f756f26db1da2aa4b9fae24a70b84649b14174e280d9aa65"
  end
  resource "joblib" do
    url "https://files.pythonhosted.org/packages/3e/24/52e504c0a828d11b59b91220b06bb62b15c8533cb8a3c8187c250f3cae3f/joblib-1.5.3-py3-none-any.whl"
    sha256 "8d750a39cff6d4fb2e01f86d4ca1e044450b82268427c73d66aaf7399cb63379"
  end
  resource "threadpoolctl" do
    url "https://files.pythonhosted.org/packages/62/80/ef451a03401cdf08f58e43c6dc2109b88fb8dd31b3bd5c0f1f259bdb0715/threadpoolctl-3.6.0-py3-none-any.whl"
    sha256 "5ff7b3fdc280f2c82db26a4e6690ead04bc9bde08816b5fa28b086752a17333b"
  end

  def install
    require "uri"
    # Create virtualenv and install the package itself
    venv = virtualenv_create(libexec, "python3.10")
    # Install vendored Python dependencies from cached downloads (allow wheels)
    python = Formula["python@3.10"].opt_bin/"python3.10"
    py_resources = resources.reject { |r| ["embedding-model-stsb-distilbert-base"].include?(r.name) }
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
