from azureml.core import Workspace

ws = Workspace.from_config()
kv = ws.get_default_keyvault()

secret_name_rsaid_private = 'tennet-compute-rsaid-private-key-dennis'
secret_name_rsaid_public = 'tennet-compute-rsaid-public-key-dennis'

with open('/home/azureuser/.ssh/id_rsa') as f:
    private_key = f.read()
    kv.set_secret(
        secret_name_rsaid_private,
        private_key,
    )

with open('/home/azureuser/.ssh/id_rsa.pub') as f:
    public_key = f.read()
    kv.set_secret(
        secret_name_rsaid_public,
        public_key,
    )

