# Scout Puppet Module 

Installs the agent for [Scout](http://scoutapp.com), a hosted server monitoring service. This Puppet Module:

* Installs the [Scout Ruby gem](https://rubygems.org/gems/scout)
* Configures a Cron job to run the monitoring agent

## Basic Config

```puppet
class {
        'scout':
            key => '0mZ6BD9DR0qyZjaBLCPZZWkW3n2Wn7DV9xp5gQPs',
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
      <td style="width:15%">key</td>
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
      <td>user</td>
      <td>User to run the Scout agent under. Will be created if it does not exist.</td>
      <td><code>scout</code></td>
    </tr>
    <tr>
      <td>group</td>
      <td>User group to run the Scout agent under. Will be created if it does not exist.</td>
      <td><code>scout</code></td>
    </tr>
    <tr>
      <td>server_name</td>
      <td>Optional name to display for this node within the Scout UI.</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>roles</td>
      <td>An Array of roles for this node. Roles are defined through Scout's UI.</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>gems</td>
      <td>An Array of plugin gem dependencies to install. For example, you may want to install the <code>redis</code> gem if this node uses the redis plugin.</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>bin</td>
      <td>The full path to the scout gem executable. When <code>nil</code>, this is discovered via <code>Gem#bindir</code>.</td>
      <td><code>nil</code></td>
    </tr>
  </tbody>
</table>

## Questions?

Contact Scout (<support@scoutapp.com>) with any questions, suggestions, bugs, etc.

## License

Apache 2.0