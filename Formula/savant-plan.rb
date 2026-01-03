class SavantPlan < Formula
  include Language::Python::Virtualenv

  desc "Standalone MCP server for planning sessions (add/revise steps)"
  homepage "https://github.com/ashabbir/savant-plan"
  url "https://raw.githubusercontent.com/ashabbir/homebrew-savant/2a573ccaeecb90caaadda10e6b30702dec73e746/savant-plan-1.0.0.tar.gz"
  version "1.0.0"
  sha256 "0a5b19df4d5247c451bbf21b8d99ed58194ae054256e470c00c54ede794070b2"
  license "MIT"

  depends_on "python@3.10"

  def install
    venv = virtualenv_create(libexec, "python3.10")
    venv.pip_install buildpath
    (bin/"savant-plan").write_env_script libexec/"bin/savant-plan", {}
  end

  test do
    system "#{bin}/savant-plan", "--version"
    system "#{bin}/savant-plan", "--help"
  end

  service do
    run [opt_bin/"savant-plan", "run"]
    keep_alive true
    environment_variables PATH: std_service_path_env
    log_path var/"log/savant-plan.log"
    error_log_path var/"log/savant-plan.error.log"
  end
end
