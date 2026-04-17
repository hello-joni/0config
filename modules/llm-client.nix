{
  ...
}:

{
  # Point Zed at the remote Ollama server over Tailscale.
  # Update the hostname below to match your LLM server's Tailscale MagicDNS
  # name (e.g. "lemongrass").
  programs.zed-editor.userSettings.language_models.ollama = {
    api_url = "http://lemongrass:11434";
    available_models = [
      {
        name = "qwen3.6:35b-a3b";
        display_name = "Qwen3.6 35B";
        max_tokens = 131072;
      }
    ];
  };
}
