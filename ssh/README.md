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
