# LLM Server Setup

Steps to set up a RunPod instance as a dedicated LLM inference server, accessible over Tailscale.

## 1. Rent the RunPod instance

Create an account at runpod.io and add ~$10 credit. Click Deploy > GPU Cloud, filter by RTX 5090. Community Cloud is fine for experimenting.

- **Template:** RunPod PyTorch (latest version — comes with CUDA drivers)
- Keep defaults for container disk, volume disk, and everything else
- **Start Jupyter Notebook:** uncheck this
- **SSH Terminal Access:** enable this and upload your public SSH key (useful as a fallback before Tailscale is set up)

Deploy, then SSH in using the command from the RunPod dashboard. Verify the GPU:
```bash
nvidia-smi
```

## 2. Create user (as root)

```bash
useradd -m jhen
passwd jhen
usermod -aG sudo jhen
```

## 3. Install Tailscale (as root)

```bash
curl -fsSL https://tailscale.com/install.sh | sh
```

RunPod containers don't have systemd as init or the TUN device, so start
Tailscale manually with userspace networking:
```bash
tailscaled --tun=userspace-networking --state=/var/lib/tailscale/tailscaled.state &
tailscale up --ssh
```

Authorize the machine via the URL it prints. Optionally rename it in the Tailscale admin console to whatever you like.

## 4. Reconnect via Tailscale SSH (as jhen)

```bash
ssh jhen@<hostname>
```

## 5. Install Nix and activate Home Manager

Clone 0config (public repo, no SSH key needed):
```bash
git clone https://github.com/averagewagon/0config.git
```

Install Nix (as root, since the container doesn't support multi-user daemon mode):
```bash
sudo su -c 'curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install'
sudo chown -R jhen /nix
```

Restart the shell, then activate:
```bash
nix-shell -p home-manager
home-manager switch --flake ~/0config#llmServer
```

## 6. Install Ollama

The official install script handles CUDA detection automatically:
```bash
curl -fsSL https://ollama.com/install.sh | sh
```

Start the services using the wrapper script from `llm-server.nix`:
```bash
llm-start
```

To stop them later: `llm-stop`

## 7. Pull a model and verify

```bash
ollama pull qwen3.6:35b-a3b
```

If the model name isn't available yet in Ollama's library, check `ollama list` for available Qwen models, or try `qwen3-coder:30b` as a fallback.

Test locally:
```bash
curl http://localhost:11434
# Should print: Ollama is running
```

Test from your laptop (with Tailscale connected):
```bash
curl http://<hostname>:11434
```

Open `http://<hostname>:8080` in a browser — you should see the Open WebUI login page. The first account you create is the admin.

## 8. Client setup

**Zed (laptop):** If `llm-client.nix` is in your laptop's Home Manager config, just run `home-manager switch` on the laptop. The Ollama model will appear in Zed's model picker. Update the hostname in `llm-client.nix` if your server has a different Tailscale name.

**Android (Maid):** Install Maid from F-Droid. Go to Settings, choose Ollama as the backend, and set the server URL to `http://<hostname>:11434`.

## 9. Shutting down

**Stop the pod** from the RunPod dashboard when you're done. Billing stops immediately. The volume disk (with your models) persists.

When you restart the pod later, you'll need to:
- Re-run Tailscale as root: `tailscaled --tun=userspace-networking --state=/var/lib/tailscale/tailscaled.state &`
- Re-run `llm-start` as jhen

If you destroy and recreate a pod, it's a fresh setup from step 1 — but the volume disk can be reattached to preserve models.

## Debugging

Check if the services are running:
```bash
pgrep -a ollama
pgrep -a open-webui
curl http://localhost:11434
```

Check GPU utilization while a model is running:
```bash
nvidia-smi
ollama ps
```
