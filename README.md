# Vagrant Boilerplate for Wordpress

This is a Vagrant Boilerplate for Wordpress based on Vagrantfile/config.yaml generated on 
https://puphpet.com/

### Provisions
This vagrant environment provisions for VirtualBox the following:
1. Ubuntu Xenial 16.04 LTS x64
2. Packages: bash-completion, htop, vim, nano
3. Apache with _proxy_fcgi_ (for php) and _rewrite_ modules
4. Self-signed SSL
5. wordpress.test and www.wordpress.test pointing to /home/wordpress/public_html
6. PHP 7.2 with:
    1. display_errors = On
    2. error_reporting = -1 
    3. date.timezone = UTC
    4. PHP-FPM INI; error_log = /var/log/php-fpm.log
    5. PHP modules: cli, intl, xml, dom, gmagick, SimpleXML, ssh2, xml, xmlreader, curl, date, exif, filter, ftp, gd, hash, iconv, imagick, json, libxml, mbstring, mysqli, openssl, pcre, posix, sockets, SPL, tokenizer, zlib, gmagick, ssh2, exif, imagick
7. Composer
8. Xdebug
9. WP-CLI (available as system service: `$ wp-cli` )
10. Ruby 2.4
11. Node.js version 6
12. MariaDB 10.1
    1. **root password: 123**
    2. **username: dbuser**
    3. **password: 123**
    4. **database: wordpress**
13. phpMyAdmin which can be accessed from http://<your-ip-or-domain>/phpMyAdmin
    
The folder in which Vagrant runs contains `wordpress` directory. This belongs to 
`wordpress:wordpress` user/group created before provisioning. This directory corresponds
to `/home/wordpress` in the VM which contains user/bash configuration files such as 
`.bash_aliases`, `.bash_profile`, etc.

Inside this directory we have `public_html` which maps to `/home/wordpress/public_html`,
 which is also the root folder for the vhost we setup in apache for `wordpress.test`
 
I have purposefully left the directory empty so you may place an existing Wordpress 
installation or use `wp` to install a new one (see more on that [below](#wp-cli)).

#### Things you may want to change in _puphpet/config.yaml_ before running _'vagrant up'_ for the first time:

1. identifier: wordpress
2. hostname: wordpress.test
3. ipaddress: 192.168.56.111
4. memory: 512
5. cpus: 1

... in the following section of config.yaml

    machines:
        machine1:
            id: wordpress
            hostname: wordpress.test
            network:
                private_network: 192.168.56.111
                forwarded_port:
                    port1:
                        host: '7027'
                        guest: '22'
            memory: '512'
            cpus: '1'

6. default locale: en_GB.UTF-8
7. supported locales: en_GB.UTF-8, en_US.UTF-8
8. timezome: UTC

... in the following section of config.yaml

    locale:
        install: '1'
        settings:
            default_locale: en_GB.UTF-8
            locales:
                - en_GB.UTF-8
                - en_US.UTF-8
            timezone: UTC

Remember to also change the ServerName in your non-SSL and SSL vhosts.

For non-SSL:
    vhosts:
        vhost1:
            servername: wordpress.test
            serveraliases:
                - www.wordpress.test
            docroot: /home/wordpress/public_html
            port: '80'

For SSL:
    vhost_7a1:
        servername: wordpress.test
        serveraliases:
            - www.wordpress.test
        docroot: /home/wordpress/public_html
        port: '443'

### Important Note
During provisioning, Vagrant _might_ fail to install ruby since it requires GPG signing 
that require the keys already installed. (see https://rvm.io/rvm/security)

For now, I have added a script to install the keys, but it may still fail to install Ruby 
the first time you run `vagrant up`. If it does, simply run `vagrant provision` again. 
It will install Ruby and complete provisioning.

### Permission Issues with public_html
For the very first vagrant up, we need to mount `/home/wordpress` folder with vagrant 
user because our `wordpress` user doesn't yet exist. To be able to work in this folder as 
`wordpress` user, simply change the _owner_ and _group_ to `wordpress` in the following 
section of config.yaml...

    synced_folder:
        folder1:
            owner: vagrant
            group: vagrant
...then `vagrant halt`, followed up `vagrant up`. This will remount the folder as 
`wordpress` user.

### <a name="wp-cli"></a>Install Wordpress with WP-CLI
You will find detailed instructions [here](https://www.inmotionhosting.com/support/edu/wp-cli/getting-started/install-wordpress-using-wp-cli),
but **tldr** is as follows:
1. su into wordpress user
`$ sudo su wordpress`
2. change to wordpress/public_html directory `$ cd ~/public_html`
3. download wordpress into the current folder: `$ wp core download` ([more here](https://developer.wordpress.org/cli/commands/core/download/))
4. configure wordpress: `$ wp config create --dbname=wordpress --dbuser=dbuser --dbpass=123 --locale=en_GB` ([more here](https://developer.wordpress.org/cli/commands/config/create/))
5. install wordpress: `$ wp core install --url=wordpress.test --title=Wordpress --admin_user=admin --admin_password=StrongPassword --admin_email=info@wordpress.test` ([more here](https://developer.wordpress.org/cli/commands/core/install/))

You're done! Simply browse to https://wordpress.test