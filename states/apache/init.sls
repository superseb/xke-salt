apache:
  pkg.installed:
    - name: httpd
  service.running:
    - name: httpd
    - require:
      - pkg: httpd

/var/www/html/index.html:
  file.managed:
    - source: salt://apache/index.html
    - require:
      - pkg: httpd

