Equipments
====================
Equipments management to Redmine

Features
====================

Installation
====================
Change to redmine/plugins folder and run:
```
bash
git clone https://github.com/redmine_equipments.git equipments
bundle install
bundle exec rake redmine:plugins:migrate RAILS_ENV=production
```

Tested with...
====================

Redmine:
 * =4.1.0

License
====================

[LICENSE.md](README.md)
