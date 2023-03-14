### Palybook to install nginx plus let's encrypt (tested on: ubuntu 16.04lts)_

* Copy your nginx config to roles/nginx-plus-letsencrypt/templates/{{ domain_name }}
* Check your the ssl config of your configuration (see: example in felix-test01.goerli.net)
* Run the playbook with the `domain_name=` variable set to your domain.
* 
**Warning!!** the playbook will delete the default nginx config named *default*, so
if you depend on it rename it before running the palybook.

Example Play:
```
---
- hosts: [felix-test01.goerli.net]
  become: yes
  vars:
    domain_name: "felix-test01.goerli.net"
  roles:
    - nginx-plus-letsencrypt
```
