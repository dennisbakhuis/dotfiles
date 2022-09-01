from pathlib import Path
from azureml.core import Workspace

ws = Workspace.from_config()
kv = ws.get_default_keyvault()

secret_name_rsaid_private = 'tennet-compute-rsaid-private-key-dennis'
secret_name_rsaid_public = 'tennet-compute-rsaid-public-key-dennis'

private_key_path = Path('/home/azureuser/.ssh/id_rsa')
if not private_key_path.exists():
    with open(private_key_path, 'w') as f:
        private_key = kv.get_secret(
            secret_name_rsaid_private,
        )
        f.write(private_key)

public_key_path = Path('/home/azureuser/.ssh/id_rsa.pub')
if not public_key_path.exists():
    with open(public_key_path, 'w') as f:
        public_key = kv.get_secret(
            secret_name_rsaid_public,
        )
        f.write(public_key)

