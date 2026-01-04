class SavantAbilities < Formula
  include Language::Python::Virtualenv

  desc "Abilities MCP server for persona + rules resolution"
  homepage "https://github.com/ashabbir/savant-abilities"
  url "https://raw.githubusercontent.com/ashabbir/homebrew-savant/c77a8a3dc77a60a34259dc406a78712ce4fd8e2e/savant-abilities-1.0.0.tar.gz"
  version "1.0.0"
  sha256 "f680bb41c198bf9c92bc9e95c8b696cc9b9f003b2414e657d705848abe161cd2"
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

