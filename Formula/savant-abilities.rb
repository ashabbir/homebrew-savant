class SavantAbilities < Formula
  include Language::Python::Virtualenv

  desc "Abilities MCP server for persona + rules resolution"
  homepage "https://github.com/ashabbir/savant-abilities"
  url "https://raw.githubusercontent.com/ashabbir/homebrew-savant/bddb229cbcc259c74fd10dfbb01614639e4664d7/savant-abilities-1.0.0.tar.gz"
  version "1.0.0"
  sha256 "abf146f112c39e08547ba1a245d916c75e1186179c3695abeb0a177e08b0cdea"
  license "MIT"

  depends_on "python@3.10"

  def install
    venv = virtualenv_create(libexec, "python3.10")
    venv.pip_install buildpath
    (bin/"savant-abilities").write_env_script libexec/"bin/savant-abilities", {}
  end

  test do
    system "#{bin}/savant-abilities", "--version"
    system "#{bin}/savant-abilities", "--help"
  end

  service do
    run [opt_bin/"savant-abilities", "run"]
    keep_alive true
    environment_variables PATH: std_service_path_env
    log_path var/"log/savant-abilities.log"
    error_log_path var/"log/savant-abilities.error.log"
  end
end

