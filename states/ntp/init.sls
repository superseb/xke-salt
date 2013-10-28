ntp:
  pkg:
    - installed

  service:
    - running
    - name: ntpd

  file:
    - managed
    - name: /etc/ntp.conf
    - source: salt://ntp/ntp.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - defaults:
      servers: {{ salt['pillar.get']('ntp.servers', ['9.pool.ntp.org']) }}
