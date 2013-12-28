role-pypi Cookbook
===================

This role cookbook installs and configures a devpi server.  [Devpi][1] is a
PyPI-compatible Python Index server that acts as both a freestanding
Python Index as well as a pull-through cache of the official Python
Package Index.

[1]: http://doc.devpi.net/latest/

Requirements
------------
* **Python Versions**: Python 2.6 amd 2.7
* **Operating Systems**: Debian/Ubuntu

Attributes
----------

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <th><tt>[:devpiserver][:admin_group]</tt></th>
    <td>String</td>
    <td>This group can administer the devpi server.  This group
        will be created if it does not exist.</td>
    <td>devpi</td>
  </tr>
  <tr>
    <th><tt>[:devpiserver][:server_root]</tt></th>
    <td>String</td>
    <td>Store server data in this directory.  This directory will be
        created if it does not exist.</td>
    <td>/opt/devpi-server/data</td>
  </tr>
  <tr>
    <th><tt>[:devpiserver][:server_port]</tt></th>
    <td>Integer</td>
    <td>Port number that the server will listen on.</td>
    <td>3141</td>
  </tr>
  <tr>
    <th><tt>[:devpiserver][:daemon_user]</tt></th>
    <td>String</td>
    <td>Run the daemon as this user.  This user will be created if
        it does not exist.</td>
    <td>devpi</td>
  </tr>
  <tr>
    <th><tt>[:devpiserver][:version]</tt></th>
    <td>String or <tt>nil</tt></td>
    <td>Install this version of the devpi-server package.
        Set this attribute to <tt>nil</tt> to install the latest
        version.</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <th><tt>[:devpiserver][:virtualenv]</tt></th>
    <td>Path</td>
    <td>Install Python virtual environment here</td>
    <td>/opt/devpi-server</td>
  </tr>
</table>

Setup
=====

Setup your environment like:

```bash
$ cd ~/code/bp/chef
$ echo $CONFUCIUS_ROOT
/code/bp/chef/confucius
$ cd cookbooks
$ git clone git@github.com:balanced-cookbooks/role-pypi.git
...
$ cd role-pypi

```

Environments
============

Nodes are created in these environments:

- `prod`
- `dev`

Testing
=======

```bash
vagrant up --provision
...
vagrant ssh

```

Provisioning
============

IAM role:
- *balanced-pypi*

Images:
- ephemeral *ami-aa4070ef*
- ebs *ami-???*

Here's how you create a node in the `dev` environment:

```bash
knife ec2 server create \
  --region us-west-1  \
  --availability-zone us-west-1a \
  --image ami-aa4070ef \
  --flavor m1.medium \
  --ssh-key mahmoud-gauss \
  --ssh-user ubuntu \
  --identity-file ~/.ssh/id_rsa \
  --associate-eip ${SOME_EIP}
  --groups balanced-pypi \
  --environment dev

Instance ID: i-800c6cdd
Flavor: m1.medium
Image: ami-aa4070ef
Region: us-west-1
Availability Zone: us-west-1a
...
```

If something horrible happens during bootstrap you can always do:

```bash
knife bootstrap \
 --run-list 'role[pypi]' \
 --ssh-user ubuntu \
 --identity-file ~/.ssh/id_rsa \
 --sudo
 --environment dev
 ${SOME_EIP}

```


You can always find these nodes later like this:

```bash
$ ec-describe-instances --tags "Role=pypi"

```

and ssh then them like this:

```bash
$ ssh i-XXXXXX.vandelay.io

```