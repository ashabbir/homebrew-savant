class SavantAbilities < Formula
  include Language::Python::Virtualenv

  desc "Abilities MCP server for persona + rules resolution"
  homepage "https://github.com/ashabbir/savant-abilities"
  url "https://raw.githubusercontent.com/ashabbir/homebrew-savant/41d6b08b1e08324e101a8572cf2b4087dcee3672/savant-abilities-1.0.0.tar.gz"
  version "1.0.0"
  sha256 "3f34fe43f41e8634c056897d7d71b301488ec1411cface2ad92ae61873291684"
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

