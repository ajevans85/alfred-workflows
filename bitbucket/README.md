A Alfred workflow for accessing your Bitbucket repositories.

##Installation

###Keychain
This script uses your Bitbucket credentials from your Keychain. Ensure that your Bitbucket details are in your keychain, from a terminal run:

```bash
security find-internet-password -s bitbucket.org
```

If you see the below response you need to add your Bitbucket credentials to the keychain otherwise skip to the workflow installation

```bash
security: SecKeychainSearchCopyNext: The specified item could not be found in the keychain.
```

To add Bitbucket to your Keychain, from a terminal run the below command replacing the $username and $password values:
```bash
security add-internet-password -a "$username" -w "$password" -l "bitbucket.org" -s "https://bitbucket.org"
```

###Alfred
TODO

