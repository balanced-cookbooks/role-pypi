name             'role-pypi'
maintainer       'balanced'
maintainer_email 'dev@balancedpayments.com'
license          'Apache2'
description      'Installs/Configures role-pypi'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends          'role-base', '~> 0.3.6'
depends          'devpi', '~> 1.0.1'
