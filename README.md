# Scout Puppet Module 

Installs the agent for [Scout](http://scoutapp.com), a hosted server monitoring service. This Puppet Module:

* Installs scoutd, the Scout monitoring daemon
* Runs scoutd

## Basic Config

```puppet
class {
        'scoutd':
            account_key => '0mZ6BD9DR0qyZjaBLCPZZWkW3n2Wn7DV9xp5gQPs',
}
```

## Required Parameters

<table>
  <thead>
    <tr>
      <th>Parameter</th>
      <th>Description</th>
      <th>Default Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="width:15%">account_key</td>
      <td>
        The agent requires a Scout account and the account's associated key. The key can be found in the account settings tab within the Scout UI or in the server setup instructions. The key looks like:
          <code>0mZ6BD9DR0qyZjaBLCPZZWkW3n2Wn7DV9xp5gQPs</code> 
      </td>
      <td style="width:15%"><code>nil</code></td>
    </tr>
  </tbody>
</table>

## Optional Parameters

<table>
  <thead>
    <tr>
      <th style="width:20%">Parameter</th>
      <th>Description</th>
      <th>Default Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>hostname</td>
      <td>Optional hostname override for this node.</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>display_name</td>
      <td>Optional name to display for this node within the Scout UI (defaults to the hostname).</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>log_file</td>
      <td>Optional location of the log file.</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>ruby_path</td>
      <td>Optional location of the ruby executable.</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>environment</td>
      <td>Specify the environment, like 'production' or 'staging' this server lives in. See https://www.scoutapp.com/help#overview_of_environments for more details.</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>roles</td>
      <td>An Array of roles for this node. Roles are defined through Scout's UI.</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>http_proxy</td>
      <td>Set an HTTP proxy if one is required to communicate with the Scoutapp service from your environment.</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>https_proxy</td>
      <td>Set an HTTPS proxy if one is required to communicate with the Scoutapp service from your environment.</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>gems</td>
      <td>An Array of plugin gem dependencies to install. For example, you may want to install the <code>redis</code> gem if this node uses the redis plugin.</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>plugin_pubkey</td>
      <td>Content of the private Plugin's public key. When not <code>nil</code>, key file is created in ~/scout_rsa.pub in home directory of user running scout.</td>
      <td><code>nil</code></td>
    </tr>
  </tbody>
</table>

## Questions?

Contact Scout (<support@scoutapp.com>) with any questions, suggestions, bugs, etc.

## License

Apache 2.0
