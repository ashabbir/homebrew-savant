class SavantAbilities < Formula
  include Language::Python::Virtualenv

  desc "Abilities MCP server for persona + rules resolution"
  homepage "https://github.com/ashabbir/savant-abilities"
  url "https://raw.githubusercontent.com/ashabbir/homebrew-savant/d433d682452589c050d1ceef2baa23259e5748f2/savant-abilities-1.0.0.tar.gz"
  version "1.0.0"
  sha256 "8cb3f6bb9641a62c5001eebd25ee4faf48511a62953f37a1b4b6bdf554905e4b"
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

