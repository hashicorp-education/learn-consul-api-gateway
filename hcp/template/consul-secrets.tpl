apiVersion: v1
kind: Secret
metadata:
  name: $name
  namespace: $namespace
type: Opaque
stringData:
  bootstrapToken: $bootstrapToken
  caCert: $caCert
  gossipEncryptionKey: $gossipEncryptionKey