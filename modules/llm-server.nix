{
  pkgs,
  ...
}:

{
  allowedUnfreePackages = [ "open-webui" ];

  home.packages = with pkgs; [
    open-webui

    # Wrapper scripts for starting services in containers without systemd.
    # Ollama itself is installed via the official install script (see
    # LLM_SERVER_SETUP.md), not Nix, because CUDA detection on non-NixOS is
    # unreliable with the nix-packaged ollama-cuda.
    (pkgs.writeShellScriptBin "llm-start" ''
      echo "Starting Ollama..."
      OLLAMA_HOST=0.0.0.0:11434 /usr/local/bin/ollama serve &
      sleep 2

      echo "Starting Open WebUI..."
      OLLAMA_BASE_URL=http://localhost:11434 \
      DATA_DIR=$HOME/.local/share/open-webui \
      HOST=0.0.0.0 \
      PORT=8080 \
      ${pkgs.open-webui}/bin/open-webui serve &

      echo "Services started. Ollama on :11434, Open WebUI on :8080"
    '')
    (pkgs.writeShellScriptBin "llm-stop" ''
      echo "Stopping services..."
      pkill -f "ollama serve" 2>/dev/null
      pkill -f "open-webui serve" 2>/dev/null
      echo "Done."
    '')
  ];
}
