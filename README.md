role-pypi Cookbook
===================

This role cookbook installs and configures a devpi server using
[balanced-devpi](https://github.com/balanced-cookbooks/balanced-devpi)

Requirements
------------
* **Python Versions**: Python 2.6 amd 2.7
* **Operating Systems**: Debian/Ubuntu

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
  --iam-profile pypi \
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