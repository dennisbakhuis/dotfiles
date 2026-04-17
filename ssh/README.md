# SSH Configuration

## Layout

- `ssh/config` (tracked, symlinked to `~/.ssh/config`): universal `Host *` defaults and a single `Include ~/.ssh/config.local`.
- `ssh/hosts/<hostname>.conf` (tracked): machine-specific host entries. Used when the machine's short hostname matches.
- `ssh/hosts/<os>.conf` (tracked, optional): OS-level fallback (`macos.conf`, `ubuntu.conf`, `arch.conf`). Used only if no hostname-specific file exists for this machine.
- `~/.ssh/config.local` (symlink, created by installer): points at the resolved hostname or OS file.

On every install the script picks `ssh/hosts/$(hostname -s).conf` if it exists, else `ssh/hosts/$OS_TYPE.conf`, else leaves a placeholder. Entries for a machine only live on that machine — editing one host file on one machine doesn't touch the others.

## Adding a new machine

1. `hostname -s` → lowercase → `<name>`
2. Create `ssh/hosts/<name>.conf` with the host blocks you want.
3. Re-run `./install.sh` (or just the ssh script).

# SSH Key Management

## Why Ed25519?
- More secure than RSA
- Smaller key size and faster
- Recommended modern standard
- Supported by GitHub, Azure DevOps, and most modern servers

## Generate New Ed25519 Key

### For GitHub
```bash
ssh-keygen -t ed25519 -C "github" -f ~/.ssh/id_ed25519_github
```

### For Azure DevOps
```bash
ssh-keygen -t ed25519 -C "azure-devops" -f ~/.ssh/id_ed25519_azure
```

### For a Server
```bash
ssh-keygen -t ed25519 -C "servername" -f ~/.ssh/id_ed25519_servername
```

**Note:** Press Enter when prompted for a passphrase (or set one for extra security).

## Install Keys

### For SSH Servers (Linux/Unix)
Copy your public key to the remote server:
```bash
ssh-copy-id -i ~/.ssh/id_ed25519_servername.pub user@hostname
```

Or manually:
```bash
cat ~/.ssh/id_ed25519_servername.pub | ssh user@hostname "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

### For GitHub
1. Copy your public key:
   ```bash
   cat ~/.ssh/id_ed25519_github.pub
   ```
2. Go to https://github.com/settings/keys
3. Click "New SSH key"
4. Paste the public key and save
5. Test: `ssh -T git@github.com`

### For Azure DevOps
1. Copy your public key:
   ```bash
   cat ~/.ssh/id_ed25519_azure.pub
   ```
2. Go to Azure DevOps → User Settings → SSH public keys
3. Click "New Key"
4. Paste the public key and save

## Update SSH Config

After creating keys, add entries to `~/.ssh/config`:

```ssh
Host myserver
  HostName 192.168.1.100
  User username
  IdentityFile ~/.ssh/id_ed25519_servername
  IdentitiesOnly yes
```

## Verify Keys
```bash
# List your keys
ls -la ~/.ssh/id_*

# Test GitHub connection
ssh -T git@github.com

# Test server connection
ssh myserver
```
